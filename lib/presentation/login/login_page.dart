import 'package:flutter/material.dart';
import 'package:medpg/view_model/user_provider.dart';
import 'package:provider/provider.dart';

import '../home/home_page.dart';
import 'build_feature_section.dart';
import 'build_header.dart';
import 'build_welcome.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with logos
            const BuildHeader(),
            const SizedBox(
              height: 30,
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Login Card
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Welcome text
                              const BuildWelcomText(),
                              const SizedBox(height: 30),

                              // Login form
                              _buildLoginForm(),

                              // Create account section
                              const BuildCreateAccountSection(),

                              // Terms and policy
                              const BuildTermsText(),

                              // Footer with "Powered by" and "Know More"
                              const BuildCardFooter(),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Features section below the login card
                    const BuildFeatureSection(),
                    const BuildEndSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Username field
        const Text(
          'Username, Email or Phone',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: 'Enter username, email or phone number',
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF0074BD), width: 2),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Password field
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Password',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF0074BD), width: 2),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Forgot password
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Forgot password?',
              style: TextStyle(
                color: Color.fromARGB(255, 51, 152, 214),
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Sign in button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              final authProvider =
                  Provider.of<UserProvider>(context, listen: false);
              final success = await authProvider.loginData(
                _usernameController.text,
                _passwordController.text,
              );

              if (context.mounted) {
                final loginMessenger = ScaffoldMessenger.of(context);
                loginMessenger.clearSnackBars();

                if (success) {
                  loginMessenger.showSnackBar(
                    const SnackBar(
                      content: Text("Login Successful"),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 3),
                    ),
                  );

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const DashboardScreen(),
                    ),
                  );
                } else {
                  loginMessenger.showSnackBar(SnackBar(
                    content: Text(authProvider.errorMessage ?? "Login Failed"),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(
                      seconds: 3,
                    ),
                  ));
                }
              }

              // print( "nitishsdfd$name");

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 21, 142, 218),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Sign in',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BuildEndSection extends StatelessWidget {
  const BuildEndSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Mission & Vission for NEET-PG | INI-CET 2025",
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.2),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Learn about our mission and vision for medical education and how MEDICO can help you achieve your goals.",
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF4B5563),
              height: 1.5,
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
              child: const Text(
                "Explore us",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}

class BuildCardFooter extends StatelessWidget {
  const BuildCardFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        // Powered by section
        Center(
          child: Row(
            children: [
              const Text(
                'Powered by',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'MED',
                      style: TextStyle(
                        color: Color(0xFF0074BD),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextSpan(
                      text: 'PG',
                      style: TextStyle(
                        color: Color(0xFFCC0000),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Know More button
        Center(
          child: TextButton(
            onPressed: () {},
            child: const Text(
              'Know More',
              style: TextStyle(
                color: Color(0xFF0074BD),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BuildTermsText extends StatelessWidget {
  const BuildTermsText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFFECEEF1),
            width: 1,
          ),
        ),
      ),
      child: RichText(
        text: const TextSpan(
          style: TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 14,
          ),
          children: [
            TextSpan(text: 'By signing in, you agree to our '),
            TextSpan(
              text: 'Terms of Service',
              style: TextStyle(
                color: Color(0xFF0074BD),
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(
                color: Color(0xFF0074BD),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildCreateAccountSection extends StatelessWidget {
  const BuildCreateAccountSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Row(
          children: [
            const Expanded(
              child: Divider(
                color: Color(0xFFD1D5DB),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'New to MEDICO?',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
            const Expanded(
              child: Divider(
                color: Color(0xFFD1D5DB),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Color(0xFFD1D5DB)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Create an account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
