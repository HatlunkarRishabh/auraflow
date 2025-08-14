import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuraFlowTheme {
  static const Color _darkBackground = Color(0xFF121212);
  static const Color _darkSurface = Color(0xFF1E1E1E);
  static const Color _lightBackground = Color(0xFFF7F7F7);
  static const Color _lightSurface = Color(0xFFFFFFFF);

  static ThemeData light(Color accentColor) {
    return _buildTheme(
      brightness: Brightness.light,
      accentColor: accentColor,
      backgroundColor: _lightBackground,
      surfaceColor: _lightSurface,
      onSurfaceColor: Colors.black87,
      completedSurfaceColor: Colors.grey.shade200,
      completedOnSurfaceColor: Colors.grey.shade500,
    );
  }

  static ThemeData dark(Color accentColor) {
    return _buildTheme(
      brightness: Brightness.dark,
      accentColor: accentColor,
      backgroundColor: _darkBackground,
      surfaceColor: _darkSurface,
      onSurfaceColor: Colors.white,
      completedSurfaceColor: const Color(0xFF222224),
      completedOnSurfaceColor: Colors.grey.shade600,
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color accentColor,
    required Color backgroundColor,
    required Color surfaceColor,
    required Color onSurfaceColor,
    required Color completedSurfaceColor,
    required Color completedOnSurfaceColor,
  }) {
    final textTheme = GoogleFonts.nunitoSansTextTheme(
      ThemeData(brightness: brightness).textTheme,
    ).apply(
      bodyColor: onSurfaceColor.withOpacity(0.8),
      displayColor: onSurfaceColor,
    );

    return ThemeData(
      brightness: brightness,
      colorSchemeSeed: accentColor,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: textTheme,
      cardTheme: CardThemeData(
        elevation: 0,
        color: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        AuraFlowCustomColors(
          completedSurface: completedSurfaceColor,
          completedOnSurface: completedOnSurfaceColor,
        ),
      ],
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        iconTheme: IconThemeData(color: onSurfaceColor),
        titleTextStyle: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: accentColor,
        unselectedItemColor: onSurfaceColor.withOpacity(0.6),
        elevation: 2,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
      ),
      checkboxTheme: CheckboxThemeData(
        shape: const CircleBorder(),
        side: BorderSide(width: 2, color: onSurfaceColor.withOpacity(0.3)),
      ),
      dialogBackgroundColor: surfaceColor,
    );
  }
}

@immutable
class AuraFlowCustomColors extends ThemeExtension<AuraFlowCustomColors> {
  const AuraFlowCustomColors({
    required this.completedSurface,
    required this.completedOnSurface,
  });

  final Color? completedSurface;
  final Color? completedOnSurface;

  @override
  AuraFlowCustomColors copyWith({Color? completedSurface, Color? completedOnSurface}) {
    return AuraFlowCustomColors(
      completedSurface: completedSurface ?? this.completedSurface,
      completedOnSurface: completedOnSurface ?? this.completedOnSurface,
    );
  }

  @override
  AuraFlowCustomColors lerp(ThemeExtension<AuraFlowCustomColors>? other, double t) {
    if (other is! AuraFlowCustomColors) {
      return this;
    }
    return AuraFlowCustomColors(
      completedSurface: Color.lerp(completedSurface, other.completedSurface, t),
      completedOnSurface: Color.lerp(completedOnSurface, other.completedOnSurface, t),
    );
  }
}