const AnonymousProfile = require("../models/anonymousProfile");
const blockedUserModel = require("../models/blockUserModel");
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

  function endChatAfterModeration(socket) {
    const result = endCurrentChat(socket);

    if (!result) return;

    io.to(result.partnerId).emit("stranger_ended_chat");
    socket.emit("chat_ended");
  }

  io.on("connection", (socket) => {

    onlineUsers++;
    io.emit("online_count", onlineUsers);

    // FIND STRANGER
    socket.on("find_stranger", async (data) => {
      try{
      const interests = data?.interests || [];

      const currentUserProfile = await AnonymousProfile.findOne({
        user: socket.user.id,
      }).select("displayName avatar -_id");

      // If someone waiting who shares atleast one interest
      if (waitingUsers.length > 0) {
        // find a stranger 
        const [blockedUsers, blockedByUsers] = await Promise.all([
        blockedUserModel.find({ user: socket.user.id }).select("blockedUser"),
        blockedUserModel.find({ blockedUser: socket.user.id }).select("user"),
        ]);

        const blockedSet = new Set(
        blockedUsers.map(item => item.blockedUser.toString())
        );

        const blockedBySet = new Set(
        blockedByUsers.map(item => item.user.toString())
        );
        // Find a stranger with common interests
        // while respecting blocked users.
        const partnerIndex = waitingUsers.findIndex((user) =>{

            // Skip yourself
            if(user.socket.id===socket.id) return false;

            // Must share at least one common interest
            const hasCommonInterest = user.interests.some(
              (interest) => interests.includes(interest)
            );

            if(!hasCommonInterest) return false;

            // Skip if current user has blocked them
            if(blockedBySet.has(user.userId.toString())) return false;

            // Skip if they have blocked the current user
            if(blockedSet.has(user.userId.toString())) return false;

            return true;
        }
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
    }catch(error){
      console.error(error);
      socket.emit("matching_failed", {
      message: "Unable to find a stranger."
      });
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

        const result = endCurrentChat(socket)
        endChatAfterModeration(socket);
      
    }catch(error){
      console.error(error);
      socket.emit("report_failed", {
      message: "Unable to submit report."
    });
    }
    })

   // Blocking user 
    socket.on("block_user",async ()=>{
      try{
      const user = socket.user.id;
      const blockedUser = partnerUserIds[socket.id];

      if(!blockedUser){
        socket.emit("blocked_failed",{
          message: "No active chat found."
        });
        return;
      }
      const existing =await blockedUserModel.findOne({
        user,
        blockedUser
      });
      if(existing){
        socket.emit("blocked_failed",{
          message:"You have already blocked this user."
        });
        return;
      }
      
      await blockedUserModel.create({
          user,
          blockedUser,
      });
        socket.emit("blocked_success");
        endChatAfterModeration(socket);
      
      
    }catch(error){
      console.error(error);
      socket.emit("blocked_failed", {
      message: "Unable to submit block."
    });
    }
    })

  }
  )
}
