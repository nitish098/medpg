import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medpg/presentation/home_page.dart';
import 'package:medpg/presentation/login/login_page.dart';
import 'package:medpg/view_model/user_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _intialiseApp();
  }

  Future<void> _intialiseApp() async {
    final userAuthenticationProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userAuthenticationProvider.loadUserFromPrefs();

    Timer(
      const Duration(seconds: 2),
      () {
        final isLoggedin = userAuthenticationProvider.userData != null;
        // print("nitish $isLoggedin");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                (isLoggedin) ? const DashboardScreen() : const LoginScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: FlutterLogo(
          size: 30,
        ),
      ),
    );
  }
}
