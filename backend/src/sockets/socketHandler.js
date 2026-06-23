module.exports = (io) => {

  const partners = {};
  let waitingUsers = [];
  let onlineUsers = 0;
  const userRooms = {};

  function addToQueue(socket, interests) {
    waitingUsers = waitingUsers.filter(
      user => user.socket.id !== socket.id
    );

    waitingUsers.push({
      socket,
      interests,
    });
  }

  io.on("connection", (socket) => {
   onlineUsers++;
   io.emit("online_count", onlineUsers);

   // FIND STRANGER
   socket.on("find_stranger", (data) => {
      const interests = data?.interests || [];
     // If someone waiting
     if (waitingUsers.length > 0) {
       const partnerIndex = waitingUsers.findIndex(
       (user)=>
       user.socket.id!==socket.id &&
       user.interests.some(
            (interest)=>interests.includes(interest))
       );
       let partnerData;
       if (partnerIndex !== -1) {
         partnerData =
           waitingUsers.splice(partnerIndex, 1)[0];
       } else{
        addToQueue(socket, interests);
        return;
       }
       if (!partnerData) {
         addToQueue(socket, interests);
         return;
       }
       const partner=partnerData.socket;
       const roomId = `${socket.id}-${partner.id}-${Date.now()}`;
       partners[socket.id] = partner.id;
       partners[partner.id] = socket.id;
       userRooms[socket.id] = roomId;
       userRooms[partner.id] = roomId;
       socket.join(roomId);
       partner.join(roomId);
       socket.emit("matched", roomId);
       partner.emit("matched", roomId);
     } else {
       // Add current user to waiting list
        addToQueue(socket, interests);
     }
   });

   // SEND MESSAGE
   socket.on("send_message", (data) => {
     io.to(data.roomId).emit("receive_message", {
       sender: socket.id,
       message: data.message,
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

     if (partnerId) {
       io.to(partnerId).emit(
         "stranger_disconnected"
       );
       delete partners[socket.id];
       delete partners[partnerId];
       delete userRooms[socket.id];
       delete userRooms[partnerId];
     }
     waitingUsers = waitingUsers.filter(
       user => user.socket.id !== socket.id
     );
   });

    //Skip Stranger
    socket.on("skip_stranger", () => {
      const partnerId = partners[socket.id];
      if (partnerId) {
        const roomId = userRooms[socket.id];
        socket.leave(roomId);

        const partnerSocket = io.sockets.sockets.get(partnerId);

        if (partnerSocket) {
           partnerSocket.leave(roomId);
        }

        io.to(partnerId).emit("stranger_disconnected");
        // Notify the user who clicked skip
        socket.emit("skip_success");
        waitingUsers = waitingUsers.filter(
          user => user.socket.id !== socket.id
        );
        waitingUsers = waitingUsers.filter(
          user => user.socket.id !== partnerId
        );
        delete partners[socket.id];
        delete partners[partnerId];
        delete userRooms[socket.id];
        delete userRooms[partnerId];
      }

    });

    socket.on("typing",(roomId)=>{
     socket.to(roomId).emit("user_typing");
    });

    socket.on("stop_typing",(roomId)=>{
    socket.to(roomId).emit("user_stop_typing");
    });

  }
 );

}