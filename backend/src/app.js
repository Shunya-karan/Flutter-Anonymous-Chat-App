const express = require("express");
const cors = require("cors");

const authRoutes = require("./routes/authRoutes");
const errorMiddleware = require("./middleware/errorMiddleware");
const userRoutes = require("./routes/userRoutes");

const app = express();

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.send("Backend Server Running");
});

app.use("/api/auth", authRoutes);
app.use("/api/users", userRoutes);

// Must be the last middleware
app.use(errorMiddleware);

module.exports = app;