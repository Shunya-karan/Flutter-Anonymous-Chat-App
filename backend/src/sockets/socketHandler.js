const AnonymousProfile = require("../models/anonymousProfile");
const blockedUserModel = require("../models/blockUserModel");
const reportModel = require("../models/reportModel");
const { randomUUID } = require("crypto");

module.exports = (io) => {

  let waitingUsers = [];
  let onlineUsers = 0;

  const partners = {};
  const userRooms = {};
  const partnerUserIds = {};
  const searchTimeouts = {};
  // LIMITS
  const messageRateLimits = {};
  const findStrangerRateLimits = {};

  // Add user to queue for chatting
  function addToQueue(socket, interests, anonymousProfile) {
    // Remove existing queue entry before adding again
    // Prevents duplicate users in the waiting queue
    waitingUsers = waitingUsers.filter(
      user => user.socket.id !== socket.id
    );

    //store information for matching
    waitingUsers.push({
      socket,
      userId: socket.user.id,
      interests,
      anonymousProfile
    });
    startSearchTimeout(socket);

  }
  // cheking that user is already waiting or not
  function isUserWaiting(socket) {
    return waitingUsers.some(
      user => user.socket.id === socket.id
    );
  }

  // Searching user for 30 second then it will stop 
  function startSearchTimeout(socket) {
    clearSearchTimeout(socket.id);

    searchTimeouts[socket.id] = setTimeout(() => {

      const stillWaiting = waitingUsers.some(
        user => user.socket.id === socket.id
      );

      if (!stillWaiting) {
        delete searchTimeouts[socket.id];
        return;
      }

      // Remove user from queue
      waitingUsers = waitingUsers.filter(
        user => user.socket.id !== socket.id
      );

      socket.emit("search_timeout");

      delete searchTimeouts[socket.id];

    }, 30000); // 30 seconds
  }

  function clearSearchTimeout(socketId) {
    if (searchTimeouts[socketId]) {
      clearTimeout(searchTimeouts[socketId]);
      delete searchTimeouts[socketId];
    }
  }

  // Ending chat and removing user from queue
  function endCurrentChat(socket) {
    // find stranger who is connected to this socket
    const partnerId = partners[socket.id];

    if (!partnerId) return null;

    const roomId = userRooms[socket.id];

    // remove current user from the chat room
    if (roomId) {
      socket.leave(roomId);
    }

    const partnerSocket = io.sockets.sockets.get(partnerId);

    // remove partner from same chat roomm
    if (partnerSocket) {
      partnerSocket.leave(roomId);
    }

    // clear all mapping active 
    delete partners[socket.id];
    delete partners[partnerId];
    delete userRooms[socket.id];
    delete userRooms[partnerId];
    delete partnerUserIds[socket.id];
    delete partnerUserIds[partnerId];

    return { partnerId };
  }

  // ending chats after block and report
  function endChatAfterModeration(socket) {
    const result = endCurrentChat(socket);

    if (!result) return;

    io.to(result.partnerId).emit("stranger_ended_chat");
    socket.emit("chat_ended");
  }



  /*=============Rate LimitS============== */

  // Rate Limits For Sending MEssage And receiving
  function _sendingMessageRateLimit(socket, data) {

    if (!data || typeof data.message !== "string") {
      return;
    }

    const message = data.message.trim();

    if (!message) return;

    if (message.length > 1000) {
      socket.emit("message_error", {
        message: "Message is too long. Maximum 1000 characters allowed.",
      });
      return null;
    }

    const now = Date.now();

    //  Create rate-limit record for this socket
    if (!messageRateLimits[socket.id]) {
      messageRateLimits[socket.id] = {
        timestamps: [],
        blockedUntil: 0,
      };
    }

    const rateLimit = messageRateLimits[socket.id];

    // Check cooldown
    if (now < rateLimit.blockedUntil) {
      const remainingSeconds = Math.ceil(
        (rateLimit.blockedUntil - now) / 1000
      );

      socket.emit("rate_limit", {
        message: `You're sending messages too quickly. Wait ${remainingSeconds}s.`,
        remainingSeconds,
      });

      return null;
    }
    // Keep only messages from the last 5 seconds
    rateLimit.timestamps = rateLimit.timestamps.filter(
      timestamp => now - timestamp < 5000
    );

    // Maximum 5 messages in 5 seconds
    if (rateLimit.timestamps.length >= 5) {
      rateLimit.blockedUntil = now + 10000;

      socket.emit("rate_limit", {
        message: "You're sending messages too quickly. Wait 10s.",
        remainingSeconds: 10,
      });

      return null;
    }
    // Record this message
    rateLimit.timestamps.push(now);
    return message;

  }

  // Rate Limits For Finding Stranger
  function _findStrangerRateLimit(socket) {
    const now = Date.now();

    // Create rate-limit record
    if (!findStrangerRateLimits[socket.id]) {
      findStrangerRateLimits[socket.id] = {
        timestamps: [],
        blockedUntil: 0,
      };
    }

    const rateLimit = findStrangerRateLimits[socket.id];

    // Check cooldown
    if (now < rateLimit.blockedUntil) {
      const remainingSeconds = Math.ceil(
        (rateLimit.blockedUntil - now) / 1000
      );
      socket.emit("match_rate_limit", {
        message: `You're searching too quickly. Wait ${remainingSeconds}s.`,
        remainingSeconds,
      });

      return false;
    }

    // Keep only requests from the last 10 seconds
    rateLimit.timestamps = rateLimit.timestamps.filter(
      timestamp => now - timestamp < 10000
    );

    // Maximum 3 searches in 10 seconds
    if (rateLimit.timestamps.length >= 3) {
      rateLimit.blockedUntil = now + 10000;

      socket.emit("match_rate_limit", {
        message: "You're searching too quickly. Wait 10s.",
        remainingSeconds: 10,
      });

      return false;
    }

    // Record request
    rateLimit.timestamps.push(now);

    return true;
  }




  // Connection of sockets
  io.on("connection", (socket) => {

    onlineUsers++;
    io.emit("online_count", onlineUsers);

    // FIND STRANGER
    socket.on("find_stranger", async (data) => {
      try {

        // searching or not
        if (isUserWaiting(socket)) {
          socket.emit("already_searching", {
            message: "You are already searching for a stranger.",
          });
          return;
        }

        // Rate Limits
        if (!_findStrangerRateLimit(socket)) {
          return;
        }

        const interests = data?.interests || [];

        const currentUserProfile = await AnonymousProfile.findOne({
          user: socket.user.id,
        }).select("displayName avatar -_id");

        // If someone waiting who shares atleast one interest
        if (waitingUsers.length > 0) {
          // find a stranger 
          const [
            blockedUsers,
            blockedByUsers,
            reportedUsers,
            reportedByUsers,
          ] = await Promise.all([

            // Users I blocked
            blockedUserModel
              .find({ user: socket.user.id })
              .select("blockedUser"),

            // Users who blocked me
            blockedUserModel
              .find({ blockedUser: socket.user.id })
              .select("user"),

            // Users I reported
            reportModel
              .find({ reporter: socket.user.id })
              .select("reportedUser"),

            // Users who reported me
            reportModel
              .find({ reportedUser: socket.user.id })
              .select("reporter"),
          ]);

          const blockedSet = new Set(
            blockedUsers.map(
              item => item.blockedUser.toString()
            )
          );

          const blockedBySet = new Set(
            blockedByUsers.map(
              item => item.user.toString()
            )
          );

          const reportedSet = new Set(
            reportedUsers.map(
              item => item.reportedUser.toString()
            )
          );

          const reportedBySet = new Set(
            reportedByUsers.map(
              item => item.reporter.toString()
            )
          );


          // Find a stranger with common interests
          // while respecting blocked and reported users.
          const partnerIndex = waitingUsers.findIndex((user) => {

            // Skip yourself
            if (user.userId.toString()==socket.user.id.toString()) return false;
            const partnerUserId = user.userId.toString();

            // Must share at least one common interest
            const hasCommonInterest = user.interests.some(
              (interest) => interests.includes(interest)
            );

            if (!hasCommonInterest) return false;
            // I blocked them
            if (blockedSet.has(partnerUserId)) return false;

            // They blocked me
            if (blockedBySet.has(partnerUserId)) return false;


            // I reported them
            if (reportedSet.has(partnerUserId)) return false;


            // They reported me
            if (reportedBySet.has(partnerUserId)) return false;


            return true;
          }
          );

          let partnerData;
          if (partnerIndex !== -1) {
            partnerData = waitingUsers.splice(partnerIndex, 1)[0];
            clearSearchTimeout(socket.id);
            clearSearchTimeout(partnerData.socket.id);
          } else {
            addToQueue(socket, interests, currentUserProfile);
            return;
          }
          if (!partnerData) {
            addToQueue(socket, interests, currentUserProfile);
            return;
          }
          const partnerProfile = partnerData.anonymousProfile;
          const partner = partnerData.socket;



          const roomId = randomUUID();

          // save users dbs id
          // it is require for Reporting and Blocking
          partnerUserIds[socket.id] = partner.user.id;
          partnerUserIds[partner.id] = socket.user.id;

          // store active socket pairing
          partners[socket.id] = partner.id;
          partners[partner.id] = socket.id;
          // storing chat roomm for both users 
          userRooms[socket.id] = roomId;
          userRooms[partner.id] = roomId;


          socket.join(roomId);
          partner.join(roomId);


          socket.emit("matched", {
            roomId,
            stranger: partnerProfile,
            strangerUserId: partner.user.id,
          });

          partner.emit("matched", {
            roomId,
            stranger: currentUserProfile,
            strangerUserId: socket.user.id,
          })

        } else {
          // Add current user to waiting list
          addToQueue(socket, interests, currentUserProfile);
        }
      } catch (error) {
        socket.emit("matching_failed", {
          message: "Unable to find a stranger."
        });
      }
    });

    // socket.on("cancel_search", () => {
    //   waitingUsers = waitingUsers.filter(
    //     user => user.socket.id !== socket.id
    //   );

    //   socket.emit("search_cancelled");
    // });

    /* SEND MESSAGE */
    socket.on("send_message", (data) => {
      // msg to everyone inside the chatroom
      if (!data.roomId || !data.message?.trim()) {
        return;
      }

      const activeRoomId = userRooms[socket.id];

      if (!activeRoomId || activeRoomId !== data.roomId) {
        socket.emit("message_error", {
          message: "You are not connected to this chat.",
        });
        return;
      }

      // Validate message + apply rate limit
      const message = _sendingMessageRateLimit(socket, data);

      if (!message) return;


      const messageId = randomUUID();
      io.to(data.roomId).emit("receive_message", {
        messageId,
        sender: socket.id,
        message: message,
        sentAt: Date.now(),
      });

    });

    // msg deliverd and receive_message
    socket.on("message_received", (data) => {

      const partnerId = partners[socket.id];

      if (!partnerId) {
        return;
      }

      io.to(partnerId).emit("message_delivered", {
        messageId: data.messageId,
      });

    });

    // DISCONNECT
    socket.on("disconnect", () => {
      clearSearchTimeout(socket.id);
      delete messageRateLimits[socket.id];
      delete findStrangerRateLimits[socket.id];

      const roomId = userRooms[socket.id];
      if (roomId) {
        socket.leave(roomId);
      }
      const partnerId = partners[socket.id];
      onlineUsers--;
      io.emit("online_count", onlineUsers);
      //Notify the stranger that the connection was lost.
      if (partnerId) {
        io.to(partnerId).emit(
          "stranger_disconnected"
        );

        // Remove all active chat references.
        // Prevents stale socket mappings after disconnect.
        delete partners[socket.id];
        delete partners[partnerId];
        delete userRooms[socket.id];
        delete userRooms[partnerId];

        delete partnerUserIds[socket.id];
        delete partnerUserIds[partnerId];
      }
      // Remove user from the waiting queue if they disconnect while searching.
      waitingUsers = waitingUsers.filter(
        user => user.socket.id !== socket.id
      );
    });

    // End current chat but continue searching for another stranger.
    socket.on("skip_stranger", () => {
      const result = endCurrentChat(socket);

      if (!result) return;

      const { partnerId } = result;

      io.to(partnerId).emit("stranger_disconnected");
      socket.emit("skip_success");

      waitingUsers = waitingUsers.filter(
        user => user.socket.id !== socket.id
      );

      waitingUsers = waitingUsers.filter(
        user => user.socket.id !== partnerId
      );
    });

    // End current chat and return user to the Home screen.
    socket.on("end_chat", () => {
      const result = endCurrentChat(socket);

      if (!result) return;

      const { partnerId } = result;

      io.to(partnerId).emit("stranger_ended_chat");

      socket.emit("chat_ended");
    });

    // Notify the stranger that the user is typing.
    socket.on("typing", (roomId) => {
      if (!roomId) return;
      socket.to(roomId).emit("user_typing");
    });

    // Notify the stranger that typing has stopped.
    socket.on("stop_typing", (roomId) => {
      if (!roomId) return;
      socket.to(roomId).emit("user_stop_typing");
    });

    // Reporting user 
    socket.on("report_user", async (data) => {
      try {
        const reporter = socket.user.id;
        const reportedUser = partnerUserIds[socket.id];
        const reportingReason = data.reason;

        if (!reportedUser) {
          socket.emit("report_failed", {
            message: "No active chat found."
          });
          return;
        }
        const existing = await reportModel.findOne({
          reporter,
          reportedUser
        });
        if (existing) {
          socket.emit("report_failed", {
            message: "You have already reported this user."
          });
          return;
        }
        if (!reportingReason) {
          socket.emit("report_failed", {
            message: "Report reason is required."
          });
          return;
        }
        await reportModel.create({
          reporter,
          reportedUser,
          reason: reportingReason
        });
        socket.emit("report_success");

        const result = endCurrentChat(socket)
        endChatAfterModeration(socket);

      } catch (error) {
        socket.emit("report_failed", {
          message: "Unable to submit report."
        });
      }
    })

    // Blocking user 
    socket.on("block_user", async () => {
      try {
        const user = socket.user.id;
        const blockedUser = partnerUserIds[socket.id];

        if (!blockedUser) {
          socket.emit("blocked_failed", {
            message: "No active chat found."
          });
          return;
        }
        const existing = await blockedUserModel.findOne({
          user,
          blockedUser
        });
        if (existing) {
          socket.emit("blocked_failed", {
            message: "You have already blocked this user."
          });
          return;
        }

        await blockedUserModel.create({
          user,
          blockedUser,
        });
        socket.emit("blocked_success");
        endChatAfterModeration(socket);


      } catch (error) {
        socket.emit("blocked_failed", {
          message: "Unable to submit block."
        });
      }
    })

  }
  )
}
