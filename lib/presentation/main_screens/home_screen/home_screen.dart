import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/widgets/home_appbar.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/widgets/home_stories.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/widgets/quick_navigation.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/widgets/user_balance_box.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/widgets/user_tariff_box.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: const [
          HomeAppbar(),
          Gap(16),
          HomeStories(),
          Gap(16),
          UserBalanceBox(),
          Gap(12),
          UserTariffBox(),
          Gap(12),
          QuickNavigation(),
        ],
      ),
    );
  }
}