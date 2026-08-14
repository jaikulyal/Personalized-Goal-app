import { Router } from "express";

import { authenticate } from "../../middleware/auth.middleware.js";
import {
  create,
  getAll,
  getOne,
  remove,
  update,
} from "./goals.controller.js";

const router = Router();

router.use(authenticate);

router.post("/", create);
router.get("/", getAll);
router.get("/:goalId", getOne);
router.patch("/:goalId", update);
router.delete("/:goalId", remove);

export default router;