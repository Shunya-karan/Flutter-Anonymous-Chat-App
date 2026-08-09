const express = require("express");
const cors = require("cors");
const {
  apiRateLimit,
  authRateLimit,
  sensitiveRateLimit,
} = require("./middleware/rateLimits.js");

const authRoutes = require("./routes/authRoutes");
const errorMiddleware = require("./middleware/errorMiddleware");
const userRoutes = require("./routes/userRoutes");
const anonymousRoutes = require("./routes/anonymousRoutes.js")

const app = express();

app.use(cors());
app.use(express.json());
app.use(apiRateLimit);


app.get("/", (req, res) => {
  res.send("Backend Server Running");
});

app.use("/api/auth",authRateLimit, authRoutes);
app.use("/api/users", userRoutes);
app.use("/api/anonymous/",anonymousRoutes);
// Must be the last middleware
app.use(errorMiddleware);

module.exports = app;