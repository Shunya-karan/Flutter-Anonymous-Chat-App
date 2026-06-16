const express = require("express");
const http = require("http");
const { Server } = require("socket.io");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json());

const server = http.createServer(app);

const io = new Server(server, {
  cors: {
    origin: "*",
  },
});

const partners = {};
let waitingUsers = [];
let onlineUsers = 0;
const userRooms = {};

// ADD THIS ROUTE
app.get("/", (req, res) => {
  res.send("Backend Server Running");
});


io.on("connection", (socket) => {

   console.log("User connected:", socket.id);

   onlineUsers++;
   io.emit("online_count", onlineUsers);

   // FIND STRANGER
   socket.on("find_stranger", () => {

     // If someone waiting
     if (waitingUsers.length > 0) {

       const partner = waitingUsers.shift();
       const roomId = `${socket.id}-${partner.id}-${Date.now()}`;
       partners[socket.id] = partner.id;
       partners[partner.id] = socket.id;
       userRooms[socket.id] = roomId;
       userRooms[partner.id] = roomId;
       socket.join(roomId);
       partner.join(roomId);
       socket.emit("matched", roomId);
       partner.emit("matched", roomId);
       console.log("Matched:", socket.id, partner.id);
     } else {
       // Add current user to waiting list
       waitingUsers.push(socket);
       console.log("Added to waiting queue");
     }
   });

   // SEND MESSAGE
   socket.on("send_message", (data) => {
   console.log(
       "MESSAGE",
       socket.id,
       data.roomId,
       data.message
     );

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
       user => user.id !== socket.id
     );
     console.log("User disconnected");
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
        delete partners[socket.id];
        delete partners[partnerId];
        delete userRooms[socket.id];
        delete userRooms[partnerId];
      }

    });

    socket.on("typing",(roomId)=>{
     socket.to(roomId).emit("user_typing");
    });

    socket.on("stop_typing",(roomId)=>
    {socket.to(roomId).emit("user_stop_typing");});
 });


server.listen(3000,"0.0.0.0", () => {
  console.log("Server running on port 3000");
});