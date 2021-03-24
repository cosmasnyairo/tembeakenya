import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final primarycolor = Color(0xFF2F4858);
final accentcolor = Color(0xFFFFA000);

final primaryswatch = MaterialColor(0xFF2F4858, {
  50: const Color(0xFF2A414F),
  100: const Color(0xFF2A414F),
  200: const Color(0xFF263A46),
  300: const Color(0xFF21323E),
  400: const Color(0xFF1C2b35),
  500: const Color(0xFF18242C),
  600: const Color(0xFF131D23),
  700: const Color(0xFF0E161A),
  800: const Color(0xFF090E12),
  900: const Color(0xFF050709),
});

//for dark mode
final accentswatch = MaterialColor(0xFFFFA000, {
  50: const Color(0xFFffa000),
  100: const Color(0xFFe69000),
  200: const Color(0xFFcc8000),
  300: const Color(0xFFb37000),
  400: const Color(0xFF996000),
  500: const Color(0xFF805000),
  600: const Color(0xFF664000),
  700: const Color(0xFF4c3000),
  800: const Color(0xFF332000),
  900: const Color(0xFF191000),
});

final apptheme = ThemeData(
  primarySwatch: primaryswatch,
  primaryColor: primarycolor,
  accentColor: accentcolor,
  canvasColor: Colors.white,
  primaryTextTheme: GoogleFonts.notoSansTextTheme(TextTheme()),
  textTheme: GoogleFonts.notoSansTextTheme(TextTheme()),
);

										
  // F58025