import mongoose, { Schema } from "mongoose";

export type GoalStatus = "active" | "completed" | "archived";

export interface IGoal {
  userId: mongoose.Types.ObjectId;
  title: string;
  description: string;
  category: string;
  status: GoalStatus;
  startDate: Date;
  targetDate: Date | null;
  createdAt: Date;
  updatedAt: Date;
}

const goalSchema = new Schema<IGoal>(
  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true,
    },

    title: {
      type: String,
      required: true,
      trim: true,
      minlength: 2,
      maxlength: 100,
    },

    description: {
      type: String,
      default: "",
      trim: true,
      maxlength: 1000,
    },

    category: {
      type: String,
      required: true,
      trim: true,
      maxlength: 50,
    },

    status: {
      type: String,
      enum: ["active", "completed", "archived"],
      default: "active",
      required: true,
    },

    startDate: {
      type: Date,
      required: true,
    },

    targetDate: {
      type: Date,
      default: null,
    },
  },
  {
    timestamps: true,
  }
);

goalSchema.index({
  userId: 1,
  status: 1,
});

export const Goal = mongoose.model<IGoal>("Goal", goalSchema);