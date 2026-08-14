import mongoose from "mongoose";

import { Goal, type GoalStatus } from "./goal.model.js";

export interface CreateGoalInput {
  userId: string;
  title: string;
  description?: string;
  category: string;
  startDate?: string;
  targetDate?: string | null;
}

export interface UpdateGoalInput {
  title?: string;
  description?: string;
  category?: string;
  status?: GoalStatus;
  startDate?: string;
  targetDate?: string | null;
}

export const createGoal = async (
  input: CreateGoalInput
) => {
  if (!mongoose.isValidObjectId(input.userId)) {
    throw new Error("Invalid user ID");
  }

  const startDate = input.startDate
    ? new Date(input.startDate)
    : new Date();

  if (Number.isNaN(startDate.getTime())) {
    throw new Error("Invalid start date");
  }

  let targetDate: Date | null = null;

  if (input.targetDate) {
    targetDate = new Date(input.targetDate);

    if (Number.isNaN(targetDate.getTime())) {
      throw new Error("Invalid target date");
    }

    if (targetDate < startDate) {
      throw new Error("Target date cannot be before start date");
    }
  }

  const goal = await Goal.create({
    userId: new mongoose.Types.ObjectId(input.userId),
    title: input.title.trim(),
    description: input.description?.trim() ?? "",
    category: input.category.trim(),
    status: "active",
    startDate,
    targetDate,
  });

  return goal;
};

export const getUserGoals = async (
  userId: string
) => {
  if (!mongoose.isValidObjectId(userId)) {
    throw new Error("Invalid user ID");
  }

  return Goal.find({
    userId,
  }).sort({
    createdAt: -1,
  });
};

export const getGoalById = async (
  userId: string,
  goalId: string
) => {
  if (!mongoose.isValidObjectId(userId)) {
    throw new Error("Invalid user ID");
  }

  if (!mongoose.isValidObjectId(goalId)) {
    throw new Error("Invalid goal ID");
  }

  const goal = await Goal.findOne({
    _id: goalId,
    userId,
  });

  if (!goal) {
    throw new Error("Goal not found");
  }

  return goal;
};

export const updateGoal = async (
  userId: string,
  goalId: string,
  input: UpdateGoalInput
) => {
  const goal = await getGoalById(userId, goalId);

  if (input.title !== undefined) {
    const title = input.title.trim();

    if (title.length < 2) {
      throw new Error("Title must be at least 2 characters");
    }

    goal.title = title;
  }

  if (input.description !== undefined) {
    goal.description = input.description.trim();
  }

  if (input.category !== undefined) {
    goal.category = input.category.trim();
  }

  if (input.status !== undefined) {
    goal.status = input.status;
  }

  if (input.startDate !== undefined) {
    const startDate = new Date(input.startDate);

    if (Number.isNaN(startDate.getTime())) {
      throw new Error("Invalid start date");
    }

    goal.startDate = startDate;
  }

  if (input.targetDate !== undefined) {
    if (input.targetDate === null) {
      goal.targetDate = null;
    } else {
      const targetDate = new Date(input.targetDate);

      if (Number.isNaN(targetDate.getTime())) {
        throw new Error("Invalid target date");
      }

      goal.targetDate = targetDate;
    }
  }

  if (
    goal.targetDate &&
    goal.targetDate < goal.startDate
  ) {
    throw new Error(
      "Target date cannot be before start date"
    );
  }

  await goal.save();

  return goal;
};

export const deleteGoal = async (
  userId: string,
  goalId: string
): Promise<void> => {
  if (!mongoose.isValidObjectId(userId)) {
    throw new Error("Invalid user ID");
  }

  if (!mongoose.isValidObjectId(goalId)) {
    throw new Error("Invalid goal ID");
  }

  const result = await Goal.deleteOne({
    _id: goalId,
    userId,
  });

  if (result.deletedCount === 0) {
    throw new Error("Goal not found");
  }
};