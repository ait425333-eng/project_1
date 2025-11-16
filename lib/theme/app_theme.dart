import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Modern Color Palette
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color secondaryColor = Color(0xFF8B5CF6); // Purple
  static const Color accentColor = Color(0xFF10B981); // Green
  static const Color errorColor = Color(0xFFEF4444); // Red
  static const Color warningColor = Color(0xFFF59E0B); // Amber
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  );

  // Modern Button Style
  static ButtonStyle modernButtonStyle({
    Color? backgroundColor,
    double? borderRadius = 16,
    EdgeInsetsGeometry? padding,
  }) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        backgroundColor ?? primaryColor,
      ),
      foregroundColor: MaterialStateProperty.all(Colors.white),
      elevation: MaterialStateProperty.all(8),
      shadowColor: MaterialStateProperty.all(
        (backgroundColor ?? primaryColor).withOpacity(0.4),
      ),
      padding: MaterialStateProperty.all(
        padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      ),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 16),
        ),
      ),
      overlayColor: MaterialStateProperty.all(
        Colors.white.withOpacity(0.1),
      ),
    );
  }

  // Modern Card Style
  static BoxDecoration modernCardDecoration({
    Color? color,
    double borderRadius = 20,
    bool hasShadow = true,
  }) {
    return BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: hasShadow
          ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ]
          : null,
    );
  }

  // Glassmorphism Effect
  static BoxDecoration glassmorphismDecoration({
    double borderRadius = 20,
    double opacity = 0.2,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: Colors.white.withOpacity(0.2),
        width: 1.5,
      ),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(opacity),
          Colors.white.withOpacity(opacity * 0.5),
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  // Text Styles
  static TextStyle headingStyle({double fontSize = 32, Color? color}) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color ?? Colors.white,
      letterSpacing: -0.5,
    );
  }

  static TextStyle subheadingStyle({double fontSize = 18, Color? color}) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color ?? Colors.white,
    );
  }

  static TextStyle bodyStyle({double fontSize = 16, Color? color}) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
      color: color ?? Colors.white,
    );
  }
}

