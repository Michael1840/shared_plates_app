part of 'theme.dart';

class AppColors {
  static const Color backgroundDark = Color(0xFF212121);
  static const Color backgroundLight = Color(0xFFF8F8F8);

  static const Color containerDark = Color(0xFF282828);
  static const Color containerLight = Color(0xFFEAEAEA);

  static const Color onContainer = Color(0xFF8F8F8F);
}

class LightAppColors {
  static const Color background = Color(0xFFF8F8F8);

  static const Color container = Color(0xFFEAEAEA);

  static const Color onContainer = Color(0xFF8F8F8F);
}

class AccentColors {
  static const Color primary = Color(0xFFDE6109);

  static const Color green = Color(0xFF89AC46);

  static const Color purple = Color.fromARGB(255, 121, 70, 172);

  static const Color red = Color.fromARGB(255, 172, 70, 70);
}

class LoadingColors {
  static const Color darkOnContainer = Color(0xFF333333);
  static const Color darkContainer = Color(0xFF282828);
  static const Color darkShimmer = Color(0xFF474747);

  static const Color lightOnContainer = Color(0xFFD6D6D6);
  static const Color lightContainer = Color(0xFFEAEAEA);
  static const Color lightShimmer = Color(0xFFF0F0F0);
}

class TextColors {
  static const Color accent = Color(0xFF89AC46);

  static const Color primaryDark = Color(0xFFFFFFFF);
  static const Color primaryLight = Color(0xFF222222);

  static const Color secondary = Color(0xFF8F8F8F);
}

class BorderColors {
  static const Color primary = Color(0xFF212121);

  static const Color secondary = Color(0xFF282828);
}

class Gradients {}

class StatusColors {
  static const Color success = Color(0xFF54D071);
  static const Color failure = Color(0xFFF45D64);

  static const Color redLight = Color(0xFFE11D48);
  static const Color redDark = Color(0xFF2E1721);

  static const Color greenLight = Color(0xFF34D399);
  static const Color greenDark = Color(0xFF142322);

  static const Color yellowLight = Color(0xFFFB9C1C);
  static const Color yellowDark = Color(0xFF2B1E19);
}

class Weights {
  static const FontWeight thin = FontWeight.w100;

  static const FontWeight reg = FontWeight.w400;

  static const FontWeight medium = FontWeight.w500;

  static const FontWeight semiBold = FontWeight.w600;

  static const FontWeight bold = FontWeight.w700;
}

class Shadows {
  static final dark = BoxShadow(
    color: Colors.black.withValues(alpha: 0.2),
    spreadRadius: 1,
    blurRadius: 5,
    offset: const Offset(0, 2),
  );

  static final light = BoxShadow(
    color: Colors.white.withValues(alpha: 0.2),
    spreadRadius: 1,
    blurRadius: 5,
    offset: const Offset(0, 2),
  );
}
