
import 'dart:developer';

import 'package:perfectum_new/logic/providers/main_bloc/main_bloc.dart';
import 'package:perfectum_new/presentation/enterance/login/login_bloc/login_bloc.dart';
import 'package:perfectum_new/presentation/enterance/login/widgets/log_out_dialog.dart';
import 'package:perfectum_new/presentation/enterance/login/widgets/password_num_box.dart';

import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:perfectum_new/presentation/main_screens/home.dart';

class PasswordScreen extends StatefulWidget {
  static const String routeName = "PasswordScreen";

  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  late final LogInBloc bloc;
  late List<bool> indicator; 
  late DevicePasswordEnum devicePasswordEnum;
  bool autoPlay = false;

  @override
  void initState() {
    bloc = context.read<LogInBloc>();
    indicator = bloc.indicator;
    devicePasswordEnum = bloc.devicePasswordEnum;
    super.initState();
  }

  @override
  void dispose() {
    bloc.add(LoginClearAll());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scheme = Theme.of(context).colorScheme;
    return BlocConsumer<LogInBloc, LoginState>(
      listener: (context, state) async {
        if(state is LoginReadyToEnter) {
          Get.snackbar("Success", "Password successfully added",
          duration: const Duration(milliseconds: 1500),
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
            borderRadius: 10,
            titleText: const Text(
              "Success",
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: (snack) {
              Get.back();
            },
          ); 
        }
        if(state is LoginAllThinksReady){
          context.read<MainBloc>().add(
            MainUserLoggedIn(userNumber: context.read<LogInBloc>().userPhone),
          );
          Get.offAllNamed(Home.routeName);
        }
        if(state is LoginNavigateToHome){
          Navigator.pushReplacementNamed(context, Home.routeName);
        }
        if(state is LoginPasswordNotSame){
          Get.showSnackbar(
            const GetSnackBar(
              snackPosition: SnackPosition.TOP,
              duration: Duration(milliseconds: 2000),
              messageText: Text("Passwords are not the same", style: TextStyle(color: Color(0xffe50101)),),
              margin: EdgeInsets.only(bottom: 20, left: 15, right: 15, top: 20),
              backgroundColor: Color(0x329E9E9E),
              borderRadius: 10,
            ),
          );
          bloc.add(LoginClearAll());
          bloc.add(LoginChangePasswordState(
            devicePasswordEnum: DevicePasswordEnum.createPassword,
          ));
        }
        if(state is LoginAttempsEnded){
          // showModalBottomSheet(
          //   context: context, 
          //   builder: (ctx){}
          // );
        }
        log("PasswordScreen: $state");
      },
      buildWhen: (previous, current) {
        return current is LoginPasswordStateChanged;
      },
      builder: (context, state) {
        if(state is LoginPasswordStateChanged){
          devicePasswordEnum = state.devicePasswordEnum;
          indicator = bloc.indicator;
          autoPlay = false;
        }
        log("Password main build");
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              SafeArea(
                child: Container(
                  height: 60,
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: devicePasswordEnum == DevicePasswordEnum.enterExistingPassword ? 
                    GestureDetector(
                    onTap: () {
                      logOutDialog(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 15),
                      width: 60,
                      alignment: Alignment.centerLeft,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: SizedBox(
                        width: 22, height: 22,
                        child: Image.asset("assets/icons/log-out.png"),
                      ),
                    ),
                  ) : null
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        devicePasswordEnum.name,
                        style: TextStyle(
                          color: scheme.onSurface,
                          fontSize: 18,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Gap(size.height * 0.03),
                      BlocBuilder<LogInBloc, LoginState>(
                        builder: (context, state) {
                          if (state is LoginTypingEnded) {
                            log("${state.password} password");
                            indicator = state.indicator;
                          }
                          if(state is LoginPasswordError || state is LoginPasswordNotSame) {
                            autoPlay = true;
                          }
                          log("Password dots build");
                          return ShakeWidget(
                            shakeConstant: ShakeHorizontalConstant1(),
                            autoPlay: autoPlay,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(bloc.passwordLength, (index) {
                                return Container(
                                  width: 29, height: 14,
                                  alignment: Alignment.center,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 100),
                                    margin: const EdgeInsets.only(
                                      left: 7.5, right: 7.5,
                                    ),
                                    height: indicator[index] ? 14 : 12,
                                    width: indicator[index] ? 14 : 12,
                                    decoration: BoxDecoration(
                                      color: state is LoginPasswordError || state is LoginPasswordNotSame
                                        ? Colors.red 
                                          : indicator[index]  
                                            ? Colors.blue : null,
                                      shape: BoxShape.circle,
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 1.5,
                                          blurStyle: BlurStyle.outer,
                                          color: Colors.grey,
                                          // spreadRadius: 0.,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        },
                      ),
                      // Gap(size.height * 0.015),
                      // Text("Password incorrect. Remaining attempts: ${bloc.attemps + 1}",
                      //   style: const TextStyle(
                      //     color: red,
                      //     fontSize: 12,
                      //     letterSpacing: 0.5,
                      //   ),
                      // ),
                      Gap(size.height * 0.03),
                      if(devicePasswordEnum == DevicePasswordEnum.enterExistingPassword 
                        || devicePasswordEnum == DevicePasswordEnum.resetPassword)
                      GestureDetector(
                        onTap: () {
                          // showDialog(
                          //   context: context, 
                          //   builder: (ctx){
                          //     return const ResetPasswodDialog();
                          //   },
                          // );
                        },
                        child: const Text("Forgot password?",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(flex: 3, child: Container()),
              const PasswordNumBox(),
              Expanded(flex: 7, child: Container())
            ],
          ),
        );
      },
    );
  }
}

// class ResetPasswodDialog extends StatelessWidget {
//   const ResetPasswodDialog({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       content: SizedBox(
//         width: double.maxFinite,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Gap(5),
//             Container(
//               alignment: Alignment.centerLeft,
//               child: Text("Reset password",
//                 style: titleStyle19_5.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const Gap(5),
//             Text(
//               "To reset your password, you need to sign in again. Would you like to proceed to the login screen?",
//               // textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.grey[800],
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//             const Gap(20),
//             Row(
//               children: List.generate(2, (index){
//                 return Expanded(
//                   child: MyCustomBox(
//                     label: index == 0 ? "Go to Login" : "Cancel", 
//                     boxHeight: 40,
//                     boxMargin: EdgeInsets.only(
//                       right: index == 0 ? 5 : 0,
//                       left: index == 1 ? 5 : 0,
//                     ),
//                     boxColor: index == 1 ? grey : red,
//                     textSize: 14,
//                     onTap: (){
//                       if(index == 0){
//                         Navigator.popUntil(context, ModalRoute.withName(Home.routeName));
//                       } else {
//                         Navigator.pop(context);
//                       }
//                     },
//                   ),
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
