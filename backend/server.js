const express = require("express");
const http = require("http");
const { Server } = require("socket.io");
const cors = require("cors");

const socketHandler = require("./sockets/socketHandler");

const app = express();

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.send("Backend Server Running");
});

const server = http.createServer(app);

const io = new Server(server, {
  cors: {
    origin: "*",
  },
});

socketHandler(io);

server.listen(3000, "0.0.0.0", () => {
  console.log("Server running on port 3000");
});