import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:perfectum_new/presentation/enterance/login/login_screen.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/screens/offers_section/screens/offer_details_screen.dart';
import 'package:perfectum_new/presentation/main_widgets/app_appbar.dart';

class EditUserProfileScreen extends StatefulWidget {
  const EditUserProfileScreen({super.key});

  @override
  State<EditUserProfileScreen> createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {

  final List<Map<String, dynamic>> userInfo = [
    {
      "label": "Полное имя",
      "value": "Karim Salimov",
    },
    {
      "label": "Номер телефона",
      "value": "+998 66 666 66 66",
    },
    {
      "label": "Электронная почта",
      "value": "salimov@gmail.com",
    },
    {
      "label": "Дата рождения",
      "value": "12.06.1997",
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const MyAppBar(title: "Личные данные"),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(left: 16, right: 16),
              children: [
                Container(
                  height: 100,
                  alignment: Alignment.center,
                  child: Container(
                    height: 100, width: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x1F9CA3AF), // 12% opacity of #9CA3AF
                          offset: Offset(5, 15),
                          blurRadius: 50,
                          spreadRadius: 0,
                        ),
                      ],
                      color: Color.fromARGB(255, 251, 253, 255)
                    ),
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: Image.asset("assets/settings_icons/avatar.png"),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          padding: const EdgeInsets.only(right: 5),
                          child: SizedBox(
                            width: 28,
                            child: Image.asset("assets/settings_icons/edit.png"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const Gap(24),
                ...List.generate(userInfo.length, (index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userInfo[index]['label'],
                          style: const TextStyle(
                            color: Color(0xff616161)
                          ),
                        ),
                        const Gap(8),
                        Text(
                          userInfo[index]['value'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                          ),
                        )
                      ],
                    ),
                  );
                })
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.offAllNamed(LoginScreen.routeName);
            },
            child: MyCustomButton(
              label: "Выйти",
              color: const Color(0xffe50101).withAlpha(26),
              labelColor: const Color(0xffe50101),
            ),
          )
        ],
      ),
    );
  }
}