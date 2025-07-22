import 'dart:async';
import 'dart:developer';

import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:perfectum_new/presentation/enterance/login/login_bloc/login_bloc.dart';
import 'package:perfectum_new/presentation/enterance/login/login_screen.dart';
import 'package:perfectum_new/presentation/enterance/login/password_screen.dart';
import 'package:perfectum_new/presentation/main_widgets/app_appbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  final bool focus;
  final String number;

  const OtpScreen({super.key, required this.focus, required this.number});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with WidgetsBindingObserver {
  late bool focus;
  bool isLoading = false;
  String otpValue = '';
  bool isError = false;

  final SmsQuery _query = SmsQuery();
  List<SmsMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    focus = true;
    WidgetsBinding.instance.addObserver(this);
    _checkPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Refresh messages when app comes to foreground
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _getMessages();
    }
  }

  Future<void> _checkPermission() async {
    final permission = await Permission.sms.status;
    if (permission.isGranted) {
      _getMessages();
    } else {
      _requestPermission();
    }
  }

  Future<void> _requestPermission() async {
    final permission = await Permission.sms.request();
    if (permission.isGranted) {
      _getMessages();
    } else {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('SMS permission is required'),
          ),
        );
      }
    }
  }

  Future<void> _getMessages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final messages = await _query.querySms(
        kinds: [SmsQueryKind.inbox],
        count: 20,
      );

      setState(() {
        _messages = messages;
      });
    } catch (e) {
      print('Error fetching SMS: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    log("$_messages");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const MyAppBar(title: ""),
          BlocListener<LogInBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginVerificationCodeSended) {
                focus = true;
                log("$state");
              }
            },
            child: Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 16, right: 16,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Подтвердите, что это вы",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    const Gap(10),
                    Text(
                      "Мы отправляем код на адрес +${numberFormatDots(widget.number)}. "
                      "Введите его здесь, чтобы подтвердить свою личность",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Gap(16),
          Expanded(
            flex: 8,
            child: Container(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const OtpTextField(),
                  const Gap(35),
                  const MySmsIndicator(),
                  const Gap(35),
                  BlocConsumer<LogInBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginCodeVeryfying ||
                          state is LoginCodeVeryfyError) {
                        isLoading = !isLoading;
                      }
                      if (state is LoginCodeVeryfyError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Code is not correct"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                      if (state is LoginCodeVeryfyed) {
          
                        context.read<LogInBloc>().add(LoginChangePasswordState(
                            devicePasswordEnum:
                                DevicePasswordEnum.createPassword,
                          ));
                        Navigator.popAndPushNamed(
                          context, PasswordScreen.routeName,
                        );
                      }
                      log("$state otp Screen state");
                    },
                    builder: (context, state) {
                      log("$otpValue value");
                      log("$isLoading isloading");
                      return Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: LoadingButton(
                          isLoading: isLoading,
                          label: "Подтвердить",
                          color: otpValue.length == 6
                              ? null
                              : const Color(0xffe50101).withAlpha(100),
                          onTap: () {
                            if (!isLoading && otpValue.length == 6) {
                              context.read<LogInBloc>().add(
                                LoginVerifyCode(
                                    otp: otpValue, context: context),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}

class OtpTextField extends StatefulWidget {
  const OtpTextField({super.key});

  @override
  State<OtpTextField> createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  final pinController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  final fillColor = const Color.fromRGBO(243, 246, 249, 0);
  final borderColor = Colors.grey[800]!;

  bool errorState = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: const TextStyle(fontSize: 22, color: Colors.black),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: scheme.shadow),
      ),
      
    );


    return Form(
      key: formKey,
      child: BlocBuilder<LogInBloc, LoginState>(
        builder: (context, state) {
          if(state is LoginCodeVeryfyError) {
            errorState = true;
          }
          if(state is LoginCodePinFieldRepaired) {
            errorState = false;
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Pinput(
                  length: 6,
                  controller: pinController,
                  defaultPinTheme: defaultPinTheme,
                  forceErrorState: errorState,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  onCompleted: (pin) {
                    context.read<LogInBloc>().add(
                      LoginVerifyCode(otp: pin, context: context),
                    );
                  },
                  autofillHints: const [AutofillHints.oneTimeCode],
                  onChanged: (value) {
                    if(errorState) {
                      context.read<LogInBloc>().add(LoginRepairPinField());
                    }
                  },
                  showCursor: false,
                  // focusNode: ,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xffe50101)),
                    ),
                  ),
                  disabledPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      color: const Color(0xfff5f5f5),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.blue),
                    ),
                  ),
                  followingPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      color: const Color(0xfff5f5f5),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xfff5f5f5)),
                    ),
                  ),
                  submittedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      color: const Color(0xfff5f5f5),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.blue),
                    ),
                  ),
                  errorPinTheme: defaultPinTheme.copyBorderWith(
                    border: Border.all(color: Colors.redAccent),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MySmsIndicator extends StatefulWidget {
  const MySmsIndicator({super.key});

  @override
  State<MySmsIndicator> createState() => _MySmsIndicatorState();
}

class _MySmsIndicatorState extends State<MySmsIndicator> {
  int currentNumber = 59;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0), () {
      startCount();
    });
    super.initState();
  }

  void startCount() async {
    for (var i = currentNumber; i >= 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          currentNumber = i;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Calculate color transition from green (0,255,0) to red (255,0,0)
    double percentage = currentNumber / 59.0; // Normalize to range 0-1
    Color countdownColor =
        Color.lerp(Colors.red, scheme.onSurface, percentage)!;

    if (currentNumber == 0) {
      return GestureDetector(
        onTap: () {
          setState(() {
            currentNumber = 59;
            startCount();
          });
          context
              .read<LogInBloc>()
              .add(LoginResendVerificationCode(context: context));
        },
        child: const Text(
          "Отправить код еще раз",
          style: TextStyle(
            color: Color(0xffe50101),fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else {
      return Text(
        "00:$currentNumber",
        style: TextStyle(
          letterSpacing: 0.8,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: countdownColor, // Dynamic color change
        ),
      );
    }
  }
}

String numberFormatDots(String number) {
  String cleanNumber = number.replaceAll(RegExp(r'[^0-9]'), '');
  
  if (cleanNumber.length < 9) {
    // Agar 9 ta raqam bo'lmasa, oddiy formatda qaytarish
    return formatWithSpaces(cleanNumber);
  }
  
  // 999999999 -> 999 99 ... .. 99
  String first3 = cleanNumber.substring(0, 3);      // 999
  String next2 = cleanNumber.substring(3, 5);       // 99
  String last2 = cleanNumber.substring(10, 12);       // 99
  
  return '$first3 $next2 ... .. $last2';
}


String formatWithSpaces(String number, {List<int> groups = const [3, 2, 3]}) {
  if (number.isEmpty) return '';
  
  String cleanNumber = number.replaceAll(RegExp(r'[^0-9]'), '');
  List<String> parts = [];
  int index = 0;
  
  for (int groupSize in groups) {
    if (index >= cleanNumber.length) break;
    
    int endIndex = (index + groupSize).clamp(0, cleanNumber.length);
    parts.add(cleanNumber.substring(index, endIndex));
    index = endIndex;
  }
  
  // Qolgan raqamlarni qo'shish
  if (index < cleanNumber.length) {
    parts.add(cleanNumber.substring(index));
  }
  
  return parts.join(' ');
}