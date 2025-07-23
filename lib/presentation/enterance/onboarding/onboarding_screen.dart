import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = "/onboarding_screen";
  final String? nextRoute;
  const OnboardingScreen({super.key, required this.nextRoute});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'Welcome to the Onboarding Screen',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              nextRoute != null
                  ? Navigator.pushNamed(context, nextRoute!)
                  : Navigator.pop(context);
            },
            child: const Text('Get Started'),
          ),
        ),
      ),
    );
  }
}