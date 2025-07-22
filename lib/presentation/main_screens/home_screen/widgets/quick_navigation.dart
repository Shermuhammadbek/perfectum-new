import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/screens/faq_screen.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/screens/map_screen.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/screens/offers_section/screens/offer_details_screen.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/screens/offers_section/screens/offers_screen.dart';

class QuickNavigation extends StatelessWidget {
  const QuickNavigation({super.key});

  @override
  Widget build(BuildContext context) {

    List<Map<String, dynamic>> navigationItems = [
      {
        "label" : "Карта",
        "image" : "map.png",
        "on_tap" : () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return MapScreen();
          }));
        }
      },
      {
        "label" : "Тарифы",
        "image" : "tariffs.png",
        "on_tap" : () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return const OffersScreen();
          }));
        }
      },
      {
        "label" : "FAQ",
        "image" : "faq.png",
        "on_tap" : () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
            return const FaqScreen();
          }));
        }
      },
      {
        "label" : "Поддержка",
        "image" : "support.png",
        "on_tap" : () {
          showDialog(
            context: context, builder: (ctx) {
              return const AppSupportDialog();
            },
          );
        }
      }
    ];

    return Container(
      height: 125,
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16, right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          strokeAlign: BorderSide.strokeAlignInside,
          width: 1, color: const Color(0xffE0E0E0)
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(navigationItems.length, (index) {
          return Expanded(
            child: GestureDetector(
              onTap: navigationItems[index]["on_tap"],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 52, width: 52,
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: Color(0xfff5f5f5),
                      shape: BoxShape.circle
                    ),
                    child: Image.asset(
                      "assets/home_icons/${navigationItems[index]["image"]}"
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    navigationItems[index]["label"],
                    style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}


class AppSupportDialog extends StatelessWidget {
  const AppSupportDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32)
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(8),
                Container(
                  width: 72,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xff007aff).withAlpha(40),
                    shape: BoxShape.circle
                  ),
                  child: Image.asset("assets/home_icons/support_blue.png"),
                ),
                const Gap(24),
                const Text(
                  "+998 98 305 11 11",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700
                  ),
                ),
                const Gap(8),
                const Text(
                  "Если у вас возникли вопросы или вам нужна помощь, пожалуйста, свяжитесь с нашей службой поддержки по номеру.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xff757575)
                  ),
                ),
                const Gap(24),
                const MyCustomButton(
                  label: "Позвонить",
                  hasMargin: false,
                  color: Color(0xfff5f5f5),
                  labelColor: Colors.black,
                )
              ],
            ),
            Positioned(
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 5, top: 5),
                  width: 12,
                  decoration: const BoxDecoration(
                    color: Colors.transparent
                  ),
                  child: Image.asset("assets/home_icons/close.png"),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}