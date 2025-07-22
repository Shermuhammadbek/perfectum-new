import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:perfectum_new/presentation/enterance/book_number/booking_bloc/booking_bloc.dart';
import 'package:perfectum_new/presentation/enterance/book_number/screens/contact_information_form.dart';
import 'package:perfectum_new/presentation/enterance/book_number/screens/imei_icc_form/imei_icc_form_controller.dart';
import 'package:perfectum_new/presentation/enterance/book_number/screens/scanner.dart';
import 'package:perfectum_new/presentation/enterance/book_number/widgets/booking_prosses.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/screens/offers_section/screens/offer_details_screen.dart';
import 'package:perfectum_new/presentation/main_widgets/app_appbar.dart';
import 'package:perfectum_new/presentation/main_widgets/custom_loading_animation.dart';

class ImeiIccInputForm extends StatefulWidget {
  const ImeiIccInputForm({super.key});

  @override
  State<ImeiIccInputForm> createState() => _ImeiIccInputFormState();
}

class _ImeiIccInputFormState extends State<ImeiIccInputForm> {
  final int active = 3;
  bool isUserAccepted = false;

  final ImeiIccFormController getController = ImeiIccFormController();

  @override
  void initState() {
    getController.initController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if(state is BookingAddItemsLoading) {
          showDialog(
            context: context, 
            builder: (ctx) {
              return const LoadingAnimation();
            },
          );
        }
        if(state is BookingAddItemsSuccess) {
          Navigator.of(context).pop();
          context.read<BookingBloc>().add(BookingStartMyId());

          Future.delayed(const Duration(seconds: 1), () {
            if(context.mounted) {
              Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                return const ContactInformationForm();
              }));
            }
          });
        }

        // if(state is BookingMyIdError) {
        //   ErrorDialog.show(context, title: "", message: state.errorText,
        //     onRetry: () {
              
        //     },
        //     icon: Icons.warning_amber,
        //     onCancel: () {
        //       Navigator.of(context).pop();
        //     },
        //   );
        // }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            MyAppBar(
              title: "Регистрация",
              trailing: Container(
                height: 26,
                padding: const EdgeInsets.only(right: 16),
                child: Image.asset("assets/settings_icons/info.png"),
              ),
            ),
            const Gap(8),
            BookingProsses(
              activeIndex: active,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Выберите устройство и тип SIM-карты",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      Gap(8),
                      Text(
                        "Введите IMEI вашего устройства, чтобы активировать SIM-карту. Также выберите тип SIM-карты: стандартная, микро или нано, в зависимости от вашего устройства.",
                        style: TextStyle(
                            color: Color(0xff616161),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  const Gap(8),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 16,
                    ),
                    height: 56,
                    decoration: BoxDecoration(
                        color: const Color(0xfff5f5f5),
                        borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: getController.imeiController,
                            decoration: const InputDecoration(
                                hintText: "Введите IMEI устройства",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    fontSize: 16, color: Colors.black45),
                                counter: SizedBox()),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            maxLength: 16,
                          ),
                        ),
                        const Gap(12),
                        GestureDetector(
                          onTap: () async {
                            final result = await scanBarcode(context: context);
                            if (result.isNotEmpty) {
                              getController.imeiController.text = result;
                            }
                          },
                          child: Container(
                            decoration:
                                const BoxDecoration(color: Colors.transparent),
                            padding: const EdgeInsets.all(16),
                            child: SizedBox(
                              height: 22,
                              child:
                                  Image.asset("assets/booking_icons/scan.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                    if (getController.imeiCount < 1) {
                      return const SizedBox();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(
                        right: 10,
                        top: 5,
                      ),
                      child: SizedBox(
                        height: 16,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (getController.imeiStatus.value ==
                                ItemStatusEnum.available)
                              const Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 17,
                                  ),
                                  Gap(4),
                                  Text(
                                    "Доступно",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green),
                                  ),
                                ],
                              ),
                            if (getController.imeiStatus.value ==
                                ItemStatusEnum.loading)
                              const Row(
                                children: [
                                  SizedBox(
                                    height: 16,
                                    child: CustomLoadingAnimation(
                                      size: 16,
                                      color: Colors.blue,
                                      strokeWidth: 3,
                                    ),
                                  ),
                                  Gap(4),
                                  Text(
                                    "В процессе проверки...",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            if (getController.imeiStatus.value ==
                                ItemStatusEnum.inUse)
                              const Row(
                                children: [
                                  Icon(
                                    Icons.info,
                                    color: Color.fromARGB(255, 249, 151, 76),
                                    size: 17,
                                  ),
                                  Gap(4),
                                  Text(
                                    "Зарегистрировано!",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            Color.fromARGB(255, 249, 151, 76)),
                                  ),
                                ],
                              ),
                            const Spacer(),
                            Text(
                              "${getController.imeiCount}/16",
                              style: const TextStyle(
                                  fontSize: 11, letterSpacing: 0.8),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                  const Gap(12),
                  Container(
                    padding: const EdgeInsets.only(
                      left: 16,
                    ),
                    height: 56,
                    decoration: BoxDecoration(
                        color: const Color(0xfff5f5f5),
                        borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: getController.iccController,
                            decoration: const InputDecoration(
                                hintText: "Введите ICCID SIM-карты",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    fontSize: 16, color: Colors.black45),
                                counter: SizedBox()),
                            maxLength: 19,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const Gap(12),
                        GestureDetector(
                          onTap: () async {
                            final result = await scanBarcode(context: context);
                            if (result.isNotEmpty) {
                              getController.iccController.text = result;
                            }
                          },
                          child: Container(
                            decoration:
                                const BoxDecoration(color: Colors.transparent),
                            padding: const EdgeInsets.all(16),
                            child: SizedBox(
                              height: 22,
                              child:
                                  Image.asset("assets/booking_icons/scan.png"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                    if (getController.iccCount < 1) {
                      return const SizedBox();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(
                        right: 10,
                        top: 5,
                      ),
                      child: SizedBox(
                        height: 16,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (getController.iccStatus.value ==
                                ItemStatusEnum.available)
                              const Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 17,
                                  ),
                                  Gap(4),
                                  Text(
                                    "Доступно",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green),
                                  ),
                                ],
                              ),
                            if (getController.iccStatus.value ==
                                ItemStatusEnum.loading)
                              const Row(
                                children: [
                                  SizedBox(
                                    height: 16,
                                    child: CustomLoadingAnimation(
                                      size: 16,
                                      color: Colors.blue,
                                      strokeWidth: 3,
                                    ),
                                  ),
                                  Gap(4),
                                  Text(
                                    "В процессе проверки...",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            if (getController.iccStatus.value ==
                                ItemStatusEnum.inUse)
                              const Row(
                                children: [
                                  Icon(
                                    Icons.info,
                                    color: Color.fromARGB(255, 249, 151, 76),
                                    size: 17,
                                  ),
                                  Gap(4),
                                  Text(
                                    "Зарегистрировано!",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            Color.fromARGB(255, 249, 151, 76)),
                                  ),
                                ],
                              ),
                            const Spacer(),
                            Text(
                              "${getController.iccCount}/19",
                              style: const TextStyle(
                                  fontSize: 11, letterSpacing: 0.8),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                  const Gap(16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isUserAccepted = !isUserAccepted;
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: isUserAccepted
                                      ? Colors.green
                                      : const Color(0xffe0e0e0),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.transparent),
                            height: 22,
                            width: 22,
                            child: isUserAccepted
                                ? const Icon(
                                    Icons.check_rounded,
                                    size: 18,
                                    color: Colors.green,
                                  )
                                : null,
                          ),
                          const Gap(8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                                children: [
                                  const TextSpan(text: 'Принятие требований '),
                                  TextSpan(
                                    text: 'публичного предложения',
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        log('Public offer link tapped');
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              final isValid =
                  getController.imeiStatus.value == ItemStatusEnum.available &&
                      getController.iccStatus.value == ItemStatusEnum.available;
              return GestureDetector(
                onTap: () async {
                  if (isValid) {
                    context.read<BookingBloc>().add(BookingAddItems(
                        imei: getController.imeiController.text,
                        icc: getController.iccController.text));
                  }
                },
                child: MyCustomButton(
                  label: "Подтвердить",
                  color: isValid
                      ? const Color(0xffe50101)
                      : const Color(0xffe50101).withAlpha(60),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}








class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onCancel;
  final IconData? icon;

  const ErrorDialog({
    Key? key,
    required this.title,
    required this.message,
    this.onRetry,
    this.onCancel,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            icon ?? Icons.error_outline,
            color: Colors.red,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(false),
          child: const Text(
            'Отмена',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onRetry ?? () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Повторить',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  /// Показывает диалог ошибки и возвращает true, если пользователь нажал "Повторить"
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    IconData? icon,
    VoidCallback? onRetry,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ErrorDialog(
        title: title,
        message: message,
        icon: icon,
        onRetry: onRetry,
        onCancel: onCancel,
      ),
    );
  }
}
