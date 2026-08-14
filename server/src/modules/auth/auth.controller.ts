import type { Request, Response } from "express";

import {
  loginUser,
  registerUser,
} from "./auth.service.js";

export const register = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    const { name, email, password } = req.body as {
      name?: unknown;
      email?: unknown;
      password?: unknown;
    };

    if (
      typeof name !== "string" ||
      typeof email !== "string" ||
      typeof password !== "string"
    ) {
      res.status(400).json({
        success: false,
        message: "Name, email and password are required",
      });

      return;
    }

    if (name.trim().length < 2) {
      res.status(400).json({
        success: false,
        message: "Name must be at least 2 characters",
      });

      return;
    }

    if (password.length < 8) {
      res.status(400).json({
        success: false,
        message: "Password must be at least 8 characters",
      });

      return;
    }

    const result = await registerUser({
      name,
      email,
      password,
    });

    res.status(201).json({
      success: true,
      message: "Account created successfully",
      data: result,
    });
  } catch (error) {
    const message =
      error instanceof Error
        ? error.message
        : "Something went wrong";

    res.status(400).json({
      success: false,
      message,
    });
  }
};

export const login = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    const { email, password } = req.body as {
      email?: unknown;
      password?: unknown;
    };

    if (
      typeof email !== "string" ||
      typeof password !== "string"
    ) {
      res.status(400).json({
        success: false,
        message: "Email and password are required",
      });

      return;
    }

    if (!email.trim()) {
      res.status(400).json({
        success: false,
        message: "Email is required",
      });

      return;
    }

    if (!password) {
      res.status(400).json({
        success: false,
        message: "Password is required",
      });

      return;
    }

    const result = await loginUser({
      email,
      password,
    });

    res.status(200).json({
      success: true,
      message: "Login successful",
      data: result,
    });
  } catch (error) {
    const message =
      error instanceof Error
        ? error.message
        : "Something went wrong";

    res.status(401).json({
      success: false,
      message,
    });
  }
};