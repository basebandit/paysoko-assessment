const express = require("express");
const { Pool } = require("pg");
const axios = require("axios");
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

const port = process.env.PORT || 3001;

// User service URL (configurable via environment variable)
const userServiceUrl =
  process.env.USER_SERVICE_URL || "http://user-service:3000";

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
    service: "task-service",
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

// Simple tasks endpoint (just returns mock data)
app.get("/tasks", (req, res) => {
  res.json([
    { id: 1, title: "Task One", status: "pending" },
    { id: 2, title: "Task Two", status: "completed" },
  ]);
});

// Endpoint that communicates with user-service to demonstrate microservice interaction
app.get("/tasks-with-users", async (req, res) => {
  try {
    // Get tasks (mock data)
    const tasks = [
      { id: 1, title: "Task One", status: "pending", assignedTo: 1 },
      { id: 2, title: "Task Two", status: "completed", assignedTo: 2 },
    ];

    // Call the user-service to get user data
    const userResponse = await axios.get(`${userServiceUrl}/users`);
    const users = userResponse.data;

    // Combine task and user data
    const tasksWithUsers = tasks.map((task) => {
      const user = users.find((u) => u.id === task.assignedTo);
      return {
        ...task,
        assignedUser: user ? user.name : "Unknown User",
      };
    });

    res.json({
      status: "success",
      data: tasksWithUsers,
      microserviceCommunication: "successful",
    });
  } catch (error) {
    console.error("Error fetching user data:", error.message);
    res.status(500).json({
      status: "error",
      message: "Failed to fetch user data from user-service",
      error: error.message,
    });
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Task Service listening at http://localhost:${port}`);
});
