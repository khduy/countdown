import 'package:countdown/services/notification/notification_service.dart';
import 'package:countdown/views/home_page/home.dart';
import 'package:countdown/views/home_page/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countdown',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
