import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:perfectum_new/logic/providers/auth_bloc/auth_bloc.dart';
import 'package:perfectum_new/preferences/display_status/display_status_screen.dart';
import 'package:perfectum_new/preferences/display_status/status_enum.dart';
import 'package:perfectum_new/presentation/enterance/book_number/screens/look_up_locations.dart';
import 'package:perfectum_new/presentation/enterance/login/login_bloc/login_bloc.dart';
import 'package:perfectum_new/presentation/enterance/login/otp_screen.dart';
import 'package:perfectum_new/presentation/main_widgets/custom_snackbar.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

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
      
      context.read<AuthBloc>().add(
        AuthSendOtp(phoneNumber: "998${controller.text}"),
      );

      // context.read<LogInBloc>().add(
      //   LoginGetVerificationCode(
      //     phone: "998${controller.text}",
      //     context: context
      //   ),
      // );
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
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if(state is AuthSensOtpLoading || state is AuthSendOtpError){
                        isLoading = !isLoading;
                      }
                      if(state is AuthSendOtpSuccess){
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
                      return MyLoadingButton(
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
                  const Gap(16),
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





class MyLoadingButton extends StatefulWidget {
  final bool isLoading;
  final Function onTap;
  final String? label;
  final Color? color;
  
  const MyLoadingButton({
    super.key,
    required this.isLoading,
    required this.onTap,
    this.label,
    this.color,
  });

  @override
  State<MyLoadingButton> createState() => _MyLoadingButtonState();
}

class _MyLoadingButtonState extends State<MyLoadingButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _loadingController;
  late Animation<double> _scaleAnimation;
  
  // ignore: unused_field
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _loadingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    if (widget.isLoading) {
      _loadingController.repeat();
    }
  }

  @override
  void didUpdateWidget(MyLoadingButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !oldWidget.isLoading) {
      _loadingController.repeat();
    } else if (!widget.isLoading && oldWidget.isLoading) {
      _loadingController.stop();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (!widget.isLoading) {
          setState(() => _isPressed = true);
          _scaleController.forward();
          HapticFeedback.lightImpact();
        }
      },
      onTapUp: (_) {
        if (!widget.isLoading) {
          setState(() => _isPressed = false);
          _scaleController.reverse();
        }
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _scaleController.reverse();
      },
      onTap: () {
        if (!widget.isLoading) {
          widget.onTap();
        }
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: double.infinity,
              height: 51,
              decoration: BoxDecoration(
                color: widget.isLoading 
                  ? const Color(0xffe50101).withAlpha(40)
                  : (widget.color ?? const Color(0xffe50101)),
                borderRadius: BorderRadius.circular(16),
                gradient: !widget.isLoading ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.color ?? const Color(0xffe50101),
                    (widget.color ?? const Color(0xffe50101)).withOpacity(0.8),
                  ],
                ) : null,
                boxShadow: !widget.isLoading ? [
                  BoxShadow(
                    color: (widget.color ?? const Color(0xffe50101))
                        .withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ] : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      widget.label ?? "",
                      style: TextStyle(
                        color: widget.isLoading 
                          ? const Color(0xffe50101)
                          : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const Gap(10),
                  if(widget.isLoading)
                    GeometricDanceLoader(
                      color: widget.color ?? const Color(0xffe50101),
                      controller: _loadingController,
                    )
                ],
              )
            ),
          );
        },
      ),
    );
  }
}


class GeometricDanceLoader extends StatelessWidget {
  final Color color;
  final double size;
  final AnimationController controller;
  
  const GeometricDanceLoader({
    super.key,
    required this.color,
    required this.controller,
    this.size = 20
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            for (int i = 0; i < 3; i++)
              Transform.rotate(
                angle: (controller.value + i / 3) * 2 * math.pi,
                child: Transform.scale(
                  scale: 0.5 + 0.5 * math.sin(controller.value * 2 * math.pi + i),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: color.withOpacity(0.8 - i * 0.2),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}





class GeometricLoadingAnimation extends StatefulWidget {
  final Color color;
  final double size;
  
  const GeometricLoadingAnimation({
    super.key,
    this.color = const Color(0xFFE50101),
    this.size = 100,
  });

  @override
  State<GeometricLoadingAnimation> createState() => _GeometricLoadingAnimationState();
}

class _GeometricLoadingAnimationState extends State<GeometricLoadingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _morphController;
  
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _morphAnimation;

  @override
  void initState() {
    super.initState();
    
    // Rotation animation
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    // Scale animation
    _scaleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    // Morph animation
    _morphController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
    
    _morphAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _morphController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _morphController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _rotationAnimation,
          _scaleAnimation,
          _morphAnimation,
        ]),
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Center circle
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: widget.size * 0.25,
                    height: widget.size * 0.25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.color,
                        width: widget.size * 0.03,
                      ),
                    ),
                  ),
                ),
                
                // Top left circle
                Transform.translate(
                  offset: Offset(
                    -widget.size * 0.3 * (1 + 0.1 * math.sin(_morphAnimation.value * 2 * math.pi)),
                    -widget.size * 0.3 * (1 + 0.1 * math.cos(_morphAnimation.value * 2 * math.pi)),
                  ),
                  child: Transform.scale(
                    scale: 1 + 0.2 * math.sin(_morphAnimation.value * 2 * math.pi),
                    child: Container(
                      width: widget.size * 0.2,
                      height: widget.size * 0.2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.color.withOpacity(0.8),
                          width: widget.size * 0.025,
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Right square (rounded)
                Transform.translate(
                  offset: Offset(
                    widget.size * 0.35 * (1 + 0.1 * math.cos(_morphAnimation.value * 2 * math.pi)),
                    widget.size * 0.05 * math.sin(_morphAnimation.value * 2 * math.pi),
                  ),
                  child: Transform.rotate(
                    angle: _morphAnimation.value * math.pi,
                    child: Transform.scale(
                      scale: 1 + 0.15 * math.sin(_morphAnimation.value * 2 * math.pi + math.pi / 2),
                      child: Container(
                        width: widget.size * 0.18,
                        height: widget.size * 0.18,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(widget.size * 0.04),
                          border: Border.all(
                            color: widget.color.withOpacity(0.9),
                            width: widget.size * 0.025,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Bottom left square
                Transform.translate(
                  offset: Offset(
                    -widget.size * 0.25 * (1 + 0.15 * math.sin(_morphAnimation.value * 2 * math.pi + math.pi)),
                    widget.size * 0.3 * (1 + 0.1 * math.sin(_morphAnimation.value * 2 * math.pi + math.pi / 3)),
                  ),
                  child: Transform.rotate(
                    angle: -_morphAnimation.value * math.pi * 0.5,
                    child: Transform.scale(
                      scale: 1 + 0.1 * math.cos(_morphAnimation.value * 2 * math.pi),
                      child: Container(
                        width: widget.size * 0.15,
                        height: widget.size * 0.15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(widget.size * 0.02),
                          border: Border.all(
                            color: widget.color.withOpacity(0.7),
                            width: widget.size * 0.02,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
