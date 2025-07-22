import 'package:perfectum_new/logic/providers/auth_bloc/auth_bloc.dart';
import 'package:perfectum_new/logic/providers/main_bloc/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:perfectum_new/presentation/enterance/book_number/booking_bloc/booking_bloc.dart';
import 'package:perfectum_new/presentation/enterance/login/login_bloc/login_bloc.dart';
import 'package:perfectum_new/logic/providers/home_bloc/home_page_bloc.dart';

class MyBlocs extends StatelessWidget {
  final Widget child;
  const MyBlocs({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        
        BlocProvider(create: (ctx){
          return AuthBloc()..add(AuthInitialEvent());
        }),

        //! Main bloc
        BlocProvider(create: (ctx){
          return MainBloc()..add(
            StartMainBloc(
              ctx: ctx, authBloc: ctx.read<AuthBloc>(),
            ),
          );
        }),

        //? Home Page bloc
        BlocProvider(create: (ctx){
          return HomePageBloc(
            mainBloc: ctx.read<MainBloc>(),
          );
        }),

        //? Login Bloc
        BlocProvider(create: (ctx){
          return LogInBloc(
            mainBloc: ctx.read<MainBloc>(),
            homePageBloc: ctx.read<HomePageBloc>(),
          );
        }),

        //? Booking bloc
        BlocProvider<BookingBloc>(create: (ctx){
          return BookingBloc(
            homeBloc: ctx.read<HomePageBloc>(),
            mainBloc: ctx.read<MainBloc>()
          );
        }),
      ], 
      child: child
      // ScreenUtilInit(
      //   designSize: const Size(430, 800),
      //   builder: (context, utilChild) {
      //     return child;
      //   },
      // ),
    );
  }
}