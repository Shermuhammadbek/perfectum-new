
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:perfectum_new/logic/models/offer_model.dart';
import 'package:perfectum_new/presentation/enterance/book_number/booking_bloc/booking_bloc.dart';
import 'package:perfectum_new/presentation/enterance/book_number/screens/imei_icc_form/imei_icc_input_form_screen.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/screens/offers_section/widgets/user_tariff.dart';
import 'package:perfectum_new/presentation/main_widgets/app_appbar.dart';
import 'package:perfectum_new/presentation/main_widgets/custom_loading_animation.dart';
import 'package:perfectum_new/presentation/main_widgets/custom_snackbar.dart';
import 'package:perfectum_new/source/extentions/string_extentions.dart';

class OfferDetailsScreen extends StatefulWidget {
  final bool fromRegister;
  final ProductOffering offer;
  const OfferDetailsScreen(
      {super.key, required this.fromRegister, required this.offer});

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if(state is BookingCreateBacketLoading) {
            showDialog(
              context: context, 
              builder: (ctx) {
                return const LoadingAnimation();
              },
            );
          }
          if(state is BookingCreateBacketSuccess) {
            Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(builder: (ctx) {
              return const ImeiIccInputForm();
            }));
          }
          if(state is BookingCreateBacketError) {
            Navigator.of(context).pop();
            CustomSnackbar.showError(context, "Ошибка произошла, попробуйте снова!");
          }
        },
        child: Column(
          children: [
            const MyAppBar(title: "Тариф"),
            Expanded(
                child: ListView(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
              children: [
                Text(
                  widget.offer.name,
                  style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(16),
                const Text(
                  "Ежемесячная оплата",
                  style: TextStyle(color: Color(0xff616161)),
                ),
                const Gap(6),
                Text(
                  "${widget.offer.prices.first.amount.toString().formatPrice()} UZS",
                  style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(24),
                Container(
                  height: 125,
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 18.5, bottom: 18.5, left: 20, right: 20,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xffe0e0e0),
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Лимиты по тарифу",
                          style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Gap(16),
                        SizedBox(
                          height: 44,
                          child: Row(
                            children: [
                              Container(
                                height: 44,
                                width: 44,
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  color: Color(0xfff5f5f5),
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "assets/home_icons/internet.png",
                                ),
                              ),
                              const Gap(12),
                              const Text(
                                "Unlimited",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        ),
                      ]),
                ),
                const Gap(16),
                Container(
                  padding: const EdgeInsets.only(
                      top: 18.5, bottom: 18.5, left: 20, right: 20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xffe0e0e0),
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Описание",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const Gap(12),
                      Text(
                        description,
                        style: const TextStyle(
                            fontSize: 16, color: Color(0xff616161)),
                      )
                    ],
                  ),
                ),
              ],
            )),
            GestureDetector(
              onTap: () {
                if (widget.fromRegister) {
                  context.read<BookingBloc>().add(
                    BookingCreateBasket(productId: widget.offer.id),
                  );
                }
              },
              child: MyCustomButton(
                label: widget.fromRegister ? "Выбрать" : "Cменить",
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyCustomButton extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? labelColor;
  final bool hasMargin;
  const MyCustomButton(
      {super.key,
      required this.label,
      this.color,
      this.labelColor,
      this.hasMargin = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: color ?? const Color(0xffE50101),
          borderRadius: BorderRadius.circular(18)),
      alignment: Alignment.center,
      margin: hasMargin
          ? EdgeInsets.only(left: 16, right: 16, bottom: Platform.isIOS ? 46 : 24, top: 12)
          : null,
      child: Text(
        label,
        style: TextStyle(
            color: labelColor ?? Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16),
      ),
    );
  }
}

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(24)
        ),
        child: const CustomLoadingAnimation(size: 45,),
      ),
    );
  }
}






