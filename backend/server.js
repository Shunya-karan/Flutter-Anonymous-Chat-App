const express = require("express");
const http = require("http");
const { Server } = require("socket.io");
const cors = require("cors");
require("dotenv").config();
const connectDB = require("./config/db");
const socketHandler = require("./sockets/socketHandler");
const authRoutes = require("./routes/authRoutes");
const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/auth",authRoutes);

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

connectDB();
server.listen(3000, "0.0.0.0", () => {
  console.log("Server running on port 3000");
});