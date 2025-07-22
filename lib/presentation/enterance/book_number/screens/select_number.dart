import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:perfectum_new/logic/models/phone_number_model.dart';
import 'package:perfectum_new/presentation/enterance/book_number/booking_bloc/booking_bloc.dart';
import 'package:perfectum_new/presentation/enterance/book_number/screens/select_tariff.dart';
import 'package:perfectum_new/presentation/enterance/book_number/widgets/booking_prosses.dart';
import 'package:perfectum_new/logic/providers/home_bloc/home_page_bloc.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/screens/offers_section/screens/offer_details_screen.dart';
import 'package:perfectum_new/presentation/main_widgets/app_appbar.dart';
import 'package:perfectum_new/presentation/main_widgets/custom_loading_animation.dart';
import 'package:perfectum_new/source/extentions/string_extentions.dart';

class SelectNumber extends StatefulWidget {
  const SelectNumber({super.key});

  @override
  State<SelectNumber> createState() => _SelectNumberState();
}

class _SelectNumberState extends State<SelectNumber> {
  late final HomePageBloc homeBloc;

  List<PhoneNumber> numbers = [];

  int active = 1;
  // ignore: non_constant_identifier_names
  int? selectedIndex;
  late PhoneNumber selectedNumber;
  int pageIndex = 1;

  @override
  void initState() {
    homeBloc = context.read<HomePageBloc>();
    homeBloc.add(HomeLoadNumbers(pageIndex: pageIndex));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Container(
            padding: const EdgeInsets.only(
              left: 16, right: 16, top: 10, bottom: 8,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Выберите номер телефона",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                Gap(8),
                Text(
                  "На этой странице вы можете выбрать свой номер телефона. Ознакомьтесь с доступными номерами, чтобы выбрать то, что лучше всего подходит именно вам!",
                  style: TextStyle(
                    color: Color(0xff616161),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<HomePageBloc, HomePageState>(
              builder: (context, state) {
                if (state is HomeNumbersLoading || state is HomeNumbersLoadingNextPage) {
                  selectedIndex = null;
                  return const Center(
                    child: CustomLoadingAnimation(size: 40,),
                  );
                }
                if (state is HomeNumbersLoaded) {
                  numbers = state.numbers;
                }
                return ListView.separated(
                  itemCount: numbers.length,
                  padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 8, bottom: 16,
                  ),
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedIndex == index) {
                            selectedIndex = null;
                          } else {
                            selectedIndex = index;
                          }
                        });
                        selectedNumber = numbers[index];
                      },
                      child: Container(
                        height: 56,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: selectedIndex == index
                              ? Border.all(
                                  color: const Color(0xffe50101),
                                  strokeAlign: BorderSide.strokeAlignInside)
                              : null,
                          borderRadius: BorderRadius.circular(16),
                          color: selectedIndex == index
                              ? null
                              : const Color(0xfff5f5f5),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${numbers[index].number}".formatPhoneNumber(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              height: 16,
                              width: 16,
                              decoration: BoxDecoration(
                                  border: selectedIndex == index
                                      ? Border.all(
                                          color: const Color(0xffe50101),
                                          width: 5)
                                      : Border.all(
                                          color: const Color(0xff9e9e9e)),
                                  shape: BoxShape.circle),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (ctx, index) {
                    return const Gap(12);
                  },
                );
              },
            ),
          ),
          const Gap(4),
          BlocBuilder<HomePageBloc, HomePageState>(
            builder: (context, state) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (pageIndex > 1 && state is! HomeNumbersLoadingNextPage) {
                              homeBloc.add(HomeLoadNumbers(pageIndex: --pageIndex));
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xfff5f5f5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            height: 41,
                            width: 41,
                            child: Icon(
                              Icons.arrow_back_ios_rounded,
                              size: 18,
                              color: pageIndex > 1
                                  ? const Color(0xff303030)
                                  : const Color(0xff757575),
                            ),
                          ),
                        ),
                        Text(
                          "$pageIndex/10",
                        ),
                        GestureDetector(
                          onTap: () {
                            if (pageIndex < 10 && state is! HomeNumbersLoadingNextPage) {
                              homeBloc.add(HomeLoadNumbers(pageIndex: ++pageIndex));
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xfff5f5f5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            height: 41,
                            width: 41,
                            child: Transform.rotate(
                              angle: math.pi,
                              child: const Icon(
                                Icons.arrow_back_ios_rounded,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(8),
                  GestureDetector(
                    onTap: () {
                      if (selectedIndex != null) {
                        context.read<BookingBloc>().add(
                          BookingNumberSelected(selectedNumber: selectedNumber),
                        );
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                          return const SelectTariff();
                        }));
                      }
                    },
                    child: MyCustomButton(
                      label: "Подтвердить",
                      color: selectedIndex != null
                          ? null
                          : const Color(0xffe50101).withAlpha(100),
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}




