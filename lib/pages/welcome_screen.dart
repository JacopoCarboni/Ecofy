import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final double width;
  final double height;
  const WelcomeScreen({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 8,
              child: SizedBox(
                width: double.infinity,
                child: Image.asset(
                  'assets/recycle.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Ecofy',
                          style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text(
                            'Recycling Made Simple',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context,
                                  '/signup'); // Navigate to SignUpScreen
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              minimumSize: Size(double.infinity, height * 0.06),
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.01),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/login'); // Navigate to LoginScreen
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Colors.green, width: 3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              minimumSize: Size(double.infinity, height * 0.06),
                            ),
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
