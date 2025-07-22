import 'package:flutter/material.dart';
import 'package:perfectum_new/logic/providers/auth_bloc/auth_bloc.dart';
import 'package:perfectum_new/logic/providers/main_bloc/main_bloc.dart';
import 'package:perfectum_new/presentation/enterance/login/login_screen.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash_screen';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if(state is AuthNavigateToLogin) {
          Navigator.pushReplacementNamed(
            context, LoginScreen.routeName,
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
