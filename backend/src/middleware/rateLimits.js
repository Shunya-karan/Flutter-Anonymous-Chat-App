const { rateLimit } = require("express-rate-limit");

// General API limiter
const apiRateLimit = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  limit: 200,

  standardHeaders: "draft-8",
  legacyHeaders: false,

  message: {
    success: false,
    message: "Too many requests. Please try again later.",
  },
});


// Authentication limiter
const authRateLimit = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  limit: 10,

  standardHeaders: "draft-8",
  legacyHeaders: false,

  message: {
    success: false,
    message: "Too many authentication attempts. Please try again later.",
  },
});


// Sensitive action limiter
const sensitiveRateLimit = rateLimit({
  windowMs: 10 * 60 * 1000, // 10 minutes
  limit: 5,

  standardHeaders: "draft-8",
  legacyHeaders: false,

  message: {
    success: false,
    message: "Too many requests. Please try again later.",
  },
});


module.exports = {
  apiRateLimit,
  authRateLimit,
  sensitiveRateLimit,
};