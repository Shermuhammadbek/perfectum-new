import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:perfectum_new/presentation/enterance/book_number/widgets/booking_prosses.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/screens/offers_section/widgets/all_tariffs.dart';
import 'package:perfectum_new/presentation/main_widgets/app_appbar.dart';

class SelectTariff extends StatefulWidget {
  const SelectTariff({super.key});

  @override
  State<SelectTariff> createState() => _SelectTariffState();
}

class _SelectTariffState extends State<SelectTariff> {

  int active = 2;
  int selectedIndex = 0;

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

          BookingProsses(activeIndex: active,),

          Container(
            padding: const EdgeInsets.only(
              left: 16, right: 16, top: 10, bottom: 16
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Выберите тариф",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700
                  ),
                ),
                Gap(8),
                Text(
                  "На этой странице вы можете выбрать тарифный план, который наилучшим образом соответствует вашим потребностям. Ознакомьтесь с доступными тарифами и выберите тот, который подходит именно вам!",
                  style: TextStyle(
                    color: Color(0xff616161),
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                  ),
                )
              ],
            ),
          ),
          const Expanded(
            child: AllTariffs(fromRegister: true,),
          ),
        ],
      ),
    );
  }
}