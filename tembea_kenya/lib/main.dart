import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tembea_kenya/providers/destinationprovider.dart';
import 'package:provider/provider.dart';
import 'package:tembea_kenya/screens/screen.dart';
import 'package:tembea_kenya/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  ).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => DestinationProvider()),
      ],
      child: MaterialApp(
        title: 'Tembea Kenya',
        debugShowCheckedModeBanner: false,
        theme: apptheme,
        home: Screen(),
      ),
    );
  }
}
