import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:perfectum_new/preferences/display_status/display_status_screen.dart';
import 'package:perfectum_new/preferences/display_status/status_enum.dart';
import 'package:perfectum_new/presentation/enterance/book_number/screens/look_up_locations.dart';
import 'package:perfectum_new/presentation/enterance/login/login_bloc/login_bloc.dart';
import 'package:perfectum_new/presentation/enterance/login/otp_screen.dart';
import 'package:perfectum_new/presentation/main_widgets/custom_snackbar.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "LoginScreen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late TextEditingController controller;
  bool isLoading = false;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  void sendOtp() {
    if(controller.text.length == 9){
      context.read<LogInBloc>().add(
        LoginGetVerificationCode(
          phone: "998${controller.text}",
          context: context
        ),
      );
    } else {
      Get.snackbar(
        "Enter valid phone number", "The entered phone number length must be 9.",
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.only(bottom: 20, left: 15, right: 15, top: 10),
        borderRadius: 10,
        titleText: const Text(
          "Enter valid phone number",
          style: TextStyle(
            color: Color(0xffe50101),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: (snack) {
          Get.back();
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              alignment: Alignment.bottomCenter,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Привет! 👋",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                  Gap(8),
                  Text(
                    "С возвращением, войдите в свою учетную запись",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff616161)
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Container(
                height: 56, width: double.infinity,
                padding: const EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                  color: const Color(0xfff5f5f5),
                  borderRadius: BorderRadius.circular(16)
                ),
                child:  Row(
                  children: [
                    const SizedBox(
                      child: Text(
                        "+998",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff757575),
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    const Gap(4),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: Platform.isAndroid ? 0 : 1.2,
                          top:  Platform.isIOS ? 0 : 0.8
                        ),
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            counter: null,
                            counterText: ""
                          ),
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),
                          maxLength: 9,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(left: 16, right: 16, bottom: Platform.isIOS ? 50 : 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocConsumer<LogInBloc, LoginState>(
                    listener: (context, state) {
                      if(state is LoginVerificationCodeLoading || state is LoginVerificationCodeSendingError){
                        isLoading = !isLoading;
                      }
                      if(state is LoginVerificationCodeSended){
                        isLoading = !isLoading;
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (ctx) {
                              late bool focus = false ;
                              return OtpScreen(
                                focus: focus,
                                number: state.userNumber,
                              );
                            },
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return LoadingButton(
                        isLoading: isLoading,
                        label: "Войти",
                        onTap: (){
                          if(!isLoading){
                            FocusScope.of(context).unfocus();
                            sendOtp();
                          }
                        },
                      );
                    }, 
                  ),
                  const Gap(4),
                  const Text(
                    "У вас нет учетной записи?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff616161)
                    ),
                  ),
                  const Gap(2),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return const LookUpLocations();
                      }));
                    },
                    child: const Text(
                      "Зарегистрироваться",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xffe50101),
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}




class LoadingButton extends StatefulWidget {
  final bool isLoading;
  final Function onTap;
  final String? label;
  final Color? color;
  const LoadingButton({
    super.key, required this.isLoading,
    required this.onTap, this.label,
    this.color,
  });

  @override
  _LoadingButtonState createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 51,
        decoration: BoxDecoration(
          color: widget.isLoading ? Colors.grey[200] : widget.color ?? const Color(0xffe50101),
          borderRadius: BorderRadius.circular(18),
        ),
        margin: const EdgeInsets.only(bottom: 20),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.label ?? "Continue",
              style: TextStyle(
                color: widget.isLoading ? const Color(0xffe50101) : Colors.white,
                fontSize: 16,
                letterSpacing: 0.7,
                fontWeight: FontWeight.bold,
              ),
            ),
            if(widget.isLoading)
            Transform.scale(
            scale: 0.5,
              child: const LoadingIndicator(
                indicatorType: Indicator.ballRotateChase,
                colors: [Color(0xffe50101)],
                strokeWidth: 1.5,
              ),
            )
          ],
        ),
      ),
    );
  }
}
