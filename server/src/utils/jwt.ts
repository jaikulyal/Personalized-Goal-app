import jwt from "jsonwebtoken";

interface AccessTokenPayload {
  userId: string;
}

export const generateAccessToken = (userId: string): string => {
  const secret = process.env.JWT_ACCESS_SECRET;

  if (!secret) {
    throw new Error("JWT_ACCESS_SECRET is not defined");
  }

  const payload: AccessTokenPayload = {
    userId,
  };

  return jwt.sign(payload, secret, {
    expiresIn: "15m",
  });
};