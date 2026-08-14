import type { Request, Response } from "express";

import {
  createGoal,
  deleteGoal,
  getGoalById,
  getUserGoals,
  updateGoal,
} from "./goals.service.js";

const getGoalId = (req: Request): string | null => {
  const goalId = req.params.goalId;

  if (typeof goalId !== "string") {
    return null;
  }

  return goalId;
};

export const create = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    if (!req.userId) {
      res.status(401).json({
        success: false,
        message: "Authentication required",
      });
      return;
    }

    const {
      title,
      description,
      category,
      startDate,
      targetDate,
    } = req.body as {
      title?: unknown;
      description?: unknown;
      category?: unknown;
      startDate?: unknown;
      targetDate?: unknown;
    };

    if (
      typeof title !== "string" ||
      typeof category !== "string"
    ) {
      res.status(400).json({
        success: false,
        message: "Title and category are required",
      });
      return;
    }

    if (title.trim().length < 2) {
      res.status(400).json({
        success: false,
        message: "Title must be at least 2 characters",
      });
      return;
    }

    if (!category.trim()) {
      res.status(400).json({
        success: false,
        message: "Category is required",
      });
      return;
    }

const goalInput: {
  userId: string;
  title: string;
  category: string;
  description?: string;
  startDate?: string;
  targetDate?: string | null;
} = {
  userId: req.userId,
  title,
  category,
};

if (typeof description === "string") {
  goalInput.description = description;
}

if (typeof startDate === "string") {
  goalInput.startDate = startDate;
}

if (typeof targetDate === "string" || targetDate === null) {
  goalInput.targetDate = targetDate;
}

const goal = await createGoal(goalInput);

    res.status(201).json({
      success: true,
      message: "Goal created successfully",
      data: {
        goal,
      },
    });
  } catch (error) {
    const message =
      error instanceof Error
        ? error.message
        : "Failed to create goal";

    res.status(400).json({
      success: false,
      message,
    });
  }
};

export const getAll = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    if (!req.userId) {
      res.status(401).json({
        success: false,
        message: "Authentication required",
      });
      return;
    }

    const goals = await getUserGoals(req.userId);

    res.status(200).json({
      success: true,
      data: {
        goals,
      },
    });
  } catch (error) {
    const message =
      error instanceof Error
        ? error.message
        : "Failed to fetch goals";

    res.status(400).json({
      success: false,
      message,
    });
  }
};

export const getOne = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    if (!req.userId) {
      res.status(401).json({
        success: false,
        message: "Authentication required",
      });
      return;
    }

  const goalId = getGoalId(req);

if (!goalId) {
  res.status(400).json({
    success: false,
    message: "Goal ID is required",
  });

  return;
}

const goal = await getGoalById(
  req.userId,
  goalId
);

    res.status(200).json({
      success: true,
      data: {
        goal,
      },
    });
  } catch (error) {
    const message =
      error instanceof Error
        ? error.message
        : "Failed to fetch goal";

    res.status(404).json({
      success: false,
      message,
    });
  }
};

export const update = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    if (!req.userId) {
      res.status(401).json({
        success: false,
        message: "Authentication required",
      });
      return;
    }

 const goalId = getGoalId(req);

if (!goalId) {
  res.status(400).json({
    success: false,
    message: "Goal ID is required",
  });

  return;
}

const goal = await updateGoal(
  req.userId,
  goalId,
  req.body
);

    res.status(200).json({
      success: true,
      message: "Goal updated successfully",
      data: {
        goal,
      },
    });
  } catch (error) {
    const message =
      error instanceof Error
        ? error.message
        : "Failed to update goal";

    res.status(400).json({
      success: false,
      message,
    });
  }
};

export const remove = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    if (!req.userId) {
      res.status(401).json({
        success: false,
        message: "Authentication required",
      });
      return;
    }

   const goalId = getGoalId(req);

if (!goalId) {
  res.status(400).json({
    success: false,
    message: "Goal ID is required",
  });

  return;
}

await deleteGoal(
  req.userId,
  goalId
);

    res.status(200).json({
      success: true,
      message: "Goal deleted successfully",
    });
  } catch (error) {
    const message =
      error instanceof Error
        ? error.message
        : "Failed to delete goal";

    res.status(404).json({
      success: false,
      message,
    });
  }
};