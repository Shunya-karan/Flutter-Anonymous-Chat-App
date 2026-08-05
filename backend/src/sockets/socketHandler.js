const AnonymousProfile = require("../models/anonymousProfile");
const reportModel = require("../models/reportModel");
const { randomUUID } = require("crypto");

module.exports = (io) => {

  const partners = {};
  let waitingUsers = [];
  let onlineUsers = 0;
  const userRooms = {};

  const partnerUserIds  = {};

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
    delete partnerUserIds [socket.id];
    delete partnerUserIds [partnerId];

    return { partnerId };
  }


  io.on("connection", (socket) => {

    onlineUsers++;
    io.emit("online_count", onlineUsers);

    // FIND STRANGER
    socket.on("find_stranger", async (data) => {
      const interests = data?.interests || [];

      const currentUserProfile = await AnonymousProfile.findOne({
        user: socket.user.id,
      }).select("displayName avatar -_id");

      // If someone waiting who shares atleast one interest
      if (waitingUsers.length > 0) {
        // find a stranger 
        const partnerIndex = waitingUsers.findIndex(
          (user) =>
            user.socket.id !== socket.id &&
            user.interests.some(
              (interest) => interests.includes(interest))
        );
        let partnerData;
        if (partnerIndex !== -1) {
          partnerData = waitingUsers.splice(partnerIndex, 1)[0];
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
        partnerUserIds [socket.id] = partner.user.id;
        partnerUserIds [partner.id] = socket.user.id;

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
          stranger: partnerProfile
        });

        partner.emit("matched", {
          roomId,
          stranger: currentUserProfile
        })
      } else {
        // Add current user to waiting list
        addToQueue(socket, interests, currentUserProfile);
      }
    });

    /* SEND MESSAGE */
    socket.on("send_message", (data) => {
      // msg to everyone inside the chatroom
      if (!data.roomId || !data.message?.trim()) {
      return;
      }
      io.to(data.roomId).emit("receive_message", {
        sender: socket.id,
        message: data.message,
        sentAt: Date.now(),
      });

    });

    // DISCONNECT
    socket.on("disconnect", () => {
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
    socket.on("report_user",async (data)=>{
      try{
      const reporter = socket.user.id;
      const reportedUser = partnerUserIds[socket.id];
      const reportingReason = data.reason;

      if(!reportedUser){
        socket.emit("report_failed",{
          message: "No active chat found."
        });
        return;
      }
      const existing =await reportModel.findOne({
        reporter,
        reportedUser
      });
      if(existing){
        socket.emit("report_failed",{
          message:"You have already reported this user."
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
      
    }catch(error){
      console.error(error);
      socket.emit("report_failed", {
      message: "Unable to submit report."
    });
    }
    })

  }

  )
}
