import cors from "cors";
import express from "express";

import authRoutes from "./modules/auth/auth.routes.js";
import usersRoutes from "./modules/users/users.routes.js";
import goalsRoutes from "./modules/goals/goals.routes.js";
const app = express();

app.use(cors());
app.use(express.json());
app.use("/api/users", usersRoutes);
app.use("/api/goals", goalsRoutes);

app.get("/api/health", (_req, res) => {
  res.status(200).json({
    success: true,
    message: "Goal App API is running",
  });
});

app.use("/api/auth", authRoutes);
app.use("/api/users", usersRoutes);
app.use("/api/goals", goalsRoutes);
export default app;