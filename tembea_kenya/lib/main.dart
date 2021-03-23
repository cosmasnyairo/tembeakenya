import 'package:flutter/material.dart';
import 'package:tembea_kenya/providers/destinationprovider.dart';
import 'package:provider/provider.dart';
import 'package:tembea_kenya/screens/categorydetail.dart';
import 'package:tembea_kenya/screens/destinationdetail.dart';
import 'package:tembea_kenya/screens/screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tembea_kenya/screens/webview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
  // F58025
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => DestinationProvider()),
      ],
      child: MaterialApp(
        title: 'Tembea Kenya',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: primaryswatch,
          primaryColor: primarycolor,
          accentColor: accentcolor,
          primaryTextTheme: GoogleFonts.notoSansTextTheme(TextTheme()),
          textTheme: GoogleFonts.notoSansTextTheme(TextTheme()),
        ),
        home: Screen(),
        routes: {
          'categorydetail': (ctx) => CategoryDetail(),
          'destinationdetail': (ctx) => DestinationDetail(),
          'webview': (ctx) => MyWebview(),
        },
      ),
    );
  }
}
