require("dotenv").config();

const http = require("http");
const { Server } = require("socket.io");

const connectDB = require("./src/config/db");
const socketHandler = require("./src/sockets/socketHandler");
const socketAuth = require("./src/middleware/socketAuth");
const app = require("./src/app");

const server = http.createServer(app);

const io = new Server(server, {
  cors: {
    origin: "*",
  },
});

io.use(socketAuth);
socketHandler(io);

connectDB();

const PORT = process.env.PORT || 3000;

server.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running on port ${PORT}`);
});