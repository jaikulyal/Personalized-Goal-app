import 'package:flutter/material.dart';

abstract final class AppColors {
  // ─────────────────────────────────────────────
  // FOUNDATION
  // ─────────────────────────────────────────────

  /// Main application background.
  static const background = Color(0xFFF6F3EE);

  /// Primary cards and elevated surfaces.
  static const surface = Color(0xFFFFFCF7);

  /// Subtle secondary surface.
  static const surfaceSoft = Color(0xFFF0ECE5);

  // ─────────────────────────────────────────────
  // TEXT
  // ─────────────────────────────────────────────

  /// Main headings and important content.
  static const primary = Color(0xFF181715);

  /// Secondary / supporting text.
  static const secondary = Color(0xFF77736C);

  /// Very subtle text.
  static const muted = Color(0xFFA39E95);

  // ─────────────────────────────────────────────
  // BRAND ACCENTS
  // ─────────────────────────────────────────────

  /// Champagne — premium decorative accent.
  static const champagne = Color(0xFFB89B5E);

  /// Very subtle champagne background.
  static const champagneSoft = Color(0xFFEEE5D3);

  // ─────────────────────────────────────────────
  // COMPLETION / ACHIEVEMENT
  // ─────────────────────────────────────────────

  /// Gold — reserved for completed goals/tasks.
  static const gold = Color(0xFFD4AF37);

  /// Soft gold background for completed cards.
  static const goldSoft = Color(0xFFF4E8BD);

  /// Dark gold text/icon color.
  static const goldDark = Color(0xFF80681F);

  // ─────────────────────────────────────────────
  // PROGRESS
  // ─────────────────────────────────────────────

  /// Calm sage green for active progress/success.
  static const sage = Color(0xFF5E765F);

  /// Soft sage background.
  static const sageSoft = Color(0xFFE3EAE1);

  // ─────────────────────────────────────────────
  // SYSTEM
  // ─────────────────────────────────────────────

  static const warning = Color(0xFFC98A3D);

  static const error = Color(0xFFA85D52);

  static const border = Color(0xFFE4DED3);

  static const divider = Color(0xFFEAE5DD);
}
