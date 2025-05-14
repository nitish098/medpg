import 'package:flutter/material.dart';
import 'package:medpg/view_model/user_provider.dart';
import 'package:provider/provider.dart';

import 'presentation/login/login_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider()..loadUserFromPrefs(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MEDICO',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 54, 159, 224),
        scaffoldBackgroundColor: const Color(0xFFF5F7F9),
        fontFamily: 'Roboto',
      ),
      home: const LoginScreen(),
    );
  }
}
