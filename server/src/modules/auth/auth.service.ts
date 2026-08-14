import bcrypt from "bcryptjs";

import { User } from "../users/user.model.js";
import { generateAccessToken } from "../../utils/jwt.js";

export interface RegisterInput {
  name: string;
  email: string;
  password: string;
}

export interface AuthResponse {
  user: {
    id: string;
    name: string;
    email: string;
    profileImage: string | null;
    authProvider: "local" | "google";
  };
  accessToken: string;
}

export const registerUser = async (
  input: RegisterInput
): Promise<AuthResponse> => {
  const name = input.name.trim();
  const email = input.email.trim().toLowerCase();
  const password = input.password;

  const existingUser = await User.findOne({ email });

  if (existingUser) {
    throw new Error("An account with this email already exists");
  }

  const passwordHash = await bcrypt.hash(password, 12);

  const user = await User.create({
    name,
    email,
    passwordHash,
    profileImage: null,
    authProvider: "local",
  });

  const accessToken = generateAccessToken(user.id);

  return {
    user: {
      id: user.id,
      name: user.name,
      email: user.email,
      profileImage: user.profileImage,
      authProvider: user.authProvider,
    },
    accessToken,
  };
};
export interface LoginInput {
  email: string;
  password: string;
}

export const loginUser = async (
  input: LoginInput
): Promise<AuthResponse> => {
  const email = input.email.trim().toLowerCase();

  const user = await User.findOne({ email }).select("+passwordHash");

  if (!user) {
    throw new Error("Invalid email or password");
  }

  if (!user.passwordHash) {
    throw new Error("This account does not use password login");
  }

  const passwordMatches = await bcrypt.compare(
    input.password,
    user.passwordHash
  );

  if (!passwordMatches) {
    throw new Error("Invalid email or password");
  }

  const accessToken = generateAccessToken(user.id);

  return {
    user: {
      id: user.id,
      name: user.name,
      email: user.email,
      profileImage: user.profileImage,
      authProvider: user.authProvider,
    },
    accessToken,
  };
};