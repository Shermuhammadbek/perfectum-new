import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/screens/offers_section/widgets/all_tariffs.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/screens/offers_section/widgets/user_tariff.dart';
import 'package:perfectum_new/presentation/main_widgets/app_appbar.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {

  int selectedIndex = 0;
  final pageController = PageController();

  @override
  void initState() {
    pageController.addListener(lisenPage);
    super.initState();
  }

  void lisenPage() {
    // ignore: no_leading_underscores_for_local_identifiers
    // final _pageIndex = (pageController.page ?? 0.0).round(); 
    // if(_pageIndex != selectedIndex) { 
    //   setState(() {
    //     selectedIndex = _pageIndex;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {

    List<String> pageTitles = ["Мой тариф", "Другие тарифы"];

    return Scaffold(
      body: Column(
        children: [
          MyAppBar(
            title: "Тарифы",
          ),
          Gap(16),
          Container(
            height: 36, width: double.infinity,
            padding: EdgeInsets.all(2.5),
            margin: EdgeInsets.only(left: 16, right: 16),
            decoration: BoxDecoration(
              color: Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(8.91),
            ),
            child: Row(
              children: List.generate(pageTitles.length, (index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if(index != selectedIndex) {
                        setState(() {selectedIndex = index;});
                        pageController.animateToPage(
                          index, duration: const Duration(milliseconds: 200), 
                          curve: Curves.fastOutSlowIn,
                        );
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selectedIndex == index ? Colors.white : null,
                        borderRadius: BorderRadius.circular(6.93),
                        boxShadow: index == selectedIndex ? const [
                          BoxShadow(
                            color: Color(0x05000000), // #05000000
                            offset: Offset(0, 3),
                            blurRadius: 1,
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Color(0x14000000), // #14000000
                            offset: Offset(0, 3),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ] : null,
                      ),
                      child: Text(
                        pageTitles[index],
                        style: TextStyle(
                          fontWeight: selectedIndex == index 
                            ? FontWeight.w700 : FontWeight.w400 
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Gap(8),
          Expanded(
            child: PageView.builder(
              itemCount: pageTitles.length,
              //! neet to edit controller
              controller: pageController,
              itemBuilder: (ctx, index) {
                if(index == 0) {
                  return UserTariff();
                } else {
                  return AllTariffs();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}