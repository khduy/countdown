import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'src/services/notification/notification_service.dart';
import 'src/views/home_page/home.dart';
import 'src/views/home_page/provider/home_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().init();
  if (Platform.isIOS) {
    NotificationService().clearBadge();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.white,
    colorScheme: ThemeData.light().colorScheme.copyWith(secondary: Colors.black.withOpacity(0.87)),
    backgroundColor: Color(0xfffafafa),
    hoverColor: Color(0xffe3e6e9),
    iconTheme: IconThemeData(color: Colors.black54),
    textTheme: TextTheme().copyWith(
      headline1: TextStyle(
        fontFamily: 'Anton',
        fontSize: 30,
        color: Colors.black.withOpacity(0.87),
      ),
      headline2: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      bodyText1: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      bodyText2: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.black87,
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        color: Colors.black54,
      ),
    ),
  );

  final darkTheme = ThemeData.dark().copyWith(
    primaryColor: Color(0xff242526),
    colorScheme: ThemeData.dark().colorScheme.copyWith(secondary: Colors.white.withOpacity(0.87)),
    backgroundColor: Color(0xff18191a),
    hoverColor: Color(0xff3a3b3c),
    primaryColorLight: Colors.white.withOpacity(0.87),
    iconTheme: IconThemeData(color: Colors.white.withOpacity(0.8)),
    textTheme: TextTheme().copyWith(
      headline1: TextStyle(
        fontFamily: 'Anton',
        fontSize: 30,
        color: Colors.white.withOpacity(0.87),
      ),
      headline2: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white.withOpacity(0.87),
      ),
      bodyText1: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white.withOpacity(0.87),
      ),
      bodyText2: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.white.withOpacity(0.87),
      ),
      subtitle2: TextStyle(
        fontSize: 14,
        color: Colors.white54,
      ),
    ),
  );

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countdown',
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/':
            return MaterialWithModalsPageRoute(
              builder: (_) => ChangeNotifierProvider(
                create: (_) => HomeProvider(),
                child: HomePage(),
              ),
            );
        }
      },
    );
  }
}
