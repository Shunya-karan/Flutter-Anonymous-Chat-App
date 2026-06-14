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
// ADD THIS ROUTE
app.get("/", (req, res) => {
  res.send("Backend Server Running");
});


io.on("connection", (socket) => {

   console.log("User connected:", socket.id);

   // FIND STRANGER
   socket.on("find_stranger", () => {

     console.log(socket.id, "is searching");
     // If someone waiting
     if (waitingUsers.length > 0) {
       const partner = waitingUsers.shift();

       const roomId = `${socket.id}-${partner.id}`;
       partners[socket.id] = partner.id;
       partners[partner.id] = socket.id;
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
     io.to(data.roomId).emit("receive_message", {
       sender: socket.id,
       message: data.message,
     });

   });

   // DISCONNECT
   socket.on("disconnect", () => {

     const partnerId = partners[socket.id];

     if (partnerId) {
       io.to(partnerId).emit(
         "stranger_disconnected"
       );
       delete partners[socket.id];
       delete partners[partnerId];
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
        io.to(partnerId).emit("stranger_disconnected");
        // Notify the user who clicked skip
        socket.emit("skip_success");
        delete partners[socket.id];
        delete partners[partnerId];
      }

    });

    socket.on("typing",(roomId)=>{
        socket.to(roomId).emit("user_typing");
    });

    socket.on("stop_typing",(roomId)=>{
        socket.to(roomId).emit("user_stop_typing");
    });
 });


server.listen(3000,"0.0.0.0", () => {
  console.log("Server running on port 3000");
});