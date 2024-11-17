import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecofy/components/button.dart';
import 'package:ecofy/components/mytextfield.dart';
import 'package:ecofy/services/general/colors.dart';
import 'package:ecofy/services/general/snackBar.dart';
import 'package:ecofy/pages/signup_screen.dart';
import 'package:ecofy/services/general/main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final pwdController = TextEditingController();

  Future<void> login() async {
    String apiUrl = "https://qeh35ldygc.execute-api.eu-central-1.amazonaws.com";
    var paramsApiUrl =
        "$apiUrl/recyclingLoginApp?email=${emailController.text}&pwd=${pwdController.text}";

    try {
      var response = await http.put(Uri.parse(paramsApiUrl));

      // Check if the widget is still mounted before using context
      if (mounted) {
        var responseData = jsonDecode(response.body);

        // Show the appropriate message based on the status code
        showSnackbar(context, responseData['msg'], response.statusCode == 400);

        // If successful, navigate to the MainNavigation (which has BottomNavigationBar)
        if (response.statusCode == 200) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainNavigation()),
          );
        }
      }
    } catch (error) {
      // Handle errors (such as network issues)
      if (mounted) {
        showSnackbar(context, "An error occurred. Please try again.", true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: appBarColor,
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Icon(
                    Icons.recycling_sharp,
                    size: 80,
                    color: logoColor,
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    "Welcome back. You've been missed!",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 25),
                  MyTextField(controller: emailController, hintText: "Email"),
                  const SizedBox(height: 10),
                  MyTextField(
                    controller: pwdController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 25),
                  CButton(onTap: login, text: "Login"),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Register now',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
