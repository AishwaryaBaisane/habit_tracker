import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'DataBase/habit_database.dart';
import 'Screens/Home_Screen.dart';
import 'Screens/Splash_Sceen.dart';
import 'Themes/Theme_Provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initializing database
  await HabitDataBase.initialize();
  await HabitDataBase.saveFirstLaunchDate();

  runApp(MultiProvider(
    providers: [
      //  Provider of Theme
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
      ),

      // Provider of habit
      ChangeNotifierProvider(
        create: (context) => HabitDataBase(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      debugShowCheckedModeBanner: false,
      routes:
      {
        '/':(context)=>SplashSceen(),
        '/home':(context)=>HomeScreen()
      },
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}