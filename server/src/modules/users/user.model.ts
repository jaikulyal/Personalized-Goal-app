import mongoose, { Schema } from "mongoose";

export type AuthProvider = "local" | "google";

export interface IUser {
  name: string;
  email: string;
  passwordHash?: string;
  profileImage: string | null;
  authProvider: AuthProvider;
  createdAt: Date;
  updatedAt: Date;
}

const userSchema = new Schema<IUser>(
  {
    name: {
      type: String,
      required: true,
      trim: true,
      minlength: 2,
      maxlength: 50,
    },

    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
    },

    passwordHash: {
      type: String,
      select: false,
    },

    profileImage: {
      type: String,
      default: null,
    },

    authProvider: {
      type: String,
      enum: ["local", "google"],
      default: "local",
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

export const User = mongoose.model<IUser>("User", userSchema);