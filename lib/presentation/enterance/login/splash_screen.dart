import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:perfectum_new/logic/providers/auth_bloc/auth_bloc.dart';
import 'package:perfectum_new/presentation/enterance/login/login_screen.dart';
import 'package:perfectum_new/presentation/enterance/onboarding/onboarding_screen.dart';
import 'package:perfectum_new/presentation/main_screens/home.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash_screen';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        log("Auth state: $state");
        if(state is Authenticated) {
          Navigator.pushReplacementNamed(
            context, Home.routeName,
          );
        }
        if(state is Unauthenticated) {
          Navigator.pushReplacementNamed(
            context, LoginScreen.routeName,
          );
        }
        if(state is ShowOnboarding) {
          Navigator.push(context, MaterialPageRoute(builder: (ctx){
            return const OnboardingScreen(nextRoute: LoginScreen.routeName,);
          }));
        }

        if(state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? 'An error occurred')),
          );
        }
      },
      child: const Scaffold(
        body: Center(
          child: Text(
            'Splash Screen',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
