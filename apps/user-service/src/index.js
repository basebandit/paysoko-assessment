const express = require("express");
const { Pool } = require("pg");
const errorhandler = require("errorhandler");
const app = express();
const logger = require("pino")({
  level: process.env.LOG_LEVEL || "debug",
});

// logger middleware
app.use((req, res, next) => {
  logger.debug({
    method: req.method,
    path: req.path,
    query: req.query,
    body: req.body,
  });
  next();
});

if (process.env.NODE_ENV === "development") {
  // only use in development
  app.use(errorhandler());
}

const port = process.env.PORT || 3000;

// Configure database connection
const pool = new Pool({
  host: process.env.DB_HOST || "localhost",
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || "postgres",
  user: process.env.DB_USER || "postgres",
  password: process.env.DB_PASSWORD || "postgres",
  ssl: process.env.DB_SSL === "true",
});

// Health check endpoint
app.get("/health", (req, res) => {
  res.status(200).json({
    service: "user-service",
    status: "healthy",
    version: "1.0.0",
    timestamp: new Date().toISOString(),
  });
});

// DB connection check
app.get("/db-check", async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query("SELECT NOW() as time");
    client.release();

    res.status(200).json({
      status: "success",
      message: "Database connection successful",
      timestamp: result.rows[0].time,
    });
  } catch (error) {
    console.error("Database connection error:", error);
    res.status(500).json({
      status: "error",
      message: "Database connection failed",
      error: error.message,
    });
  }
});

// Simple user endpoint (just returns mock data)
app.get("/users", (req, res) => {
  res.json([
    { id: 1, name: "User One" },
    { id: 2, name: "User Two" },
  ]);
});

// Start the server
app.listen(port, () => {
  console.log(`User Service listening at http://localhost:${port}`);
});
