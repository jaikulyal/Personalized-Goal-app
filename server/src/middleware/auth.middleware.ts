import type { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken";

interface AccessTokenPayload {
  userId: string;
}

export const authenticate = (
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  const authorization = req.headers.authorization;

  if (!authorization?.startsWith("Bearer ")) {
    res.status(401).json({
      success: false,
      message: "Authentication required",
    });

    return;
  }

  const token = authorization.substring(7);
  const secret = process.env.JWT_ACCESS_SECRET;

  if (!secret) {
    res.status(500).json({
      success: false,
      message: "JWT configuration is missing",
    });

    return;
  }

  try {
    const payload = jwt.verify(
      token,
      secret
    ) as AccessTokenPayload;

    if (!payload.userId) {
      res.status(401).json({
        success: false,
        message: "Invalid authentication token",
      });

      return;
    }

    req.userId = payload.userId;

    next();
  } catch {
    res.status(401).json({
      success: false,
      message: "Invalid or expired authentication token",
    });
  }
};