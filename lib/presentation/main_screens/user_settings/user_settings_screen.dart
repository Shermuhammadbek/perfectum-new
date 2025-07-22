import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:perfectum_new/preferences/language_options/language_screen.dart';
import 'package:perfectum_new/presentation/main_screens/user_settings/edit_user_profile_screen.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {

  

  @override
  Widget build(BuildContext context) {

    List<Map<String, dynamic>> appSettings = [
      {
        "icon" : "assets/home_icons/internet.png",
        "label" : "Язык",
        "on_tap" : () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx){
            return const LanguageScreen();
          }));
        }
      },
      {
        "icon" : "assets/settings_icons/theme.png",
        "label" : "Тема",
        "on_tap" : () {

        }
      },
      {
        "icon" : "assets/settings_icons/pin.png",
        "label" : "Пин-код",
        "on_tap" : () {

        }
      },
    ];

    List<Map<String, dynamic>> appInformations = [
      {
        "icon" : "assets/settings_icons/file.png",
        "label" : "Публичная оферта",
        "on_tap" : () {
          
        }
      },
      {
        "icon" : "assets/settings_icons/file.png",
        "label" : "Политика конфиденциальности",
        "on_tap" : () {

        }
      },
      {
        "icon" : "assets/settings_icons/info.png",
        "label" : "О приложении",
        "on_tap" : () {

        }
      },
    ];

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Text(
                'Настройки',
                style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w700
                ),
              ),
            ),
          ),
          const Gap(8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return const EditUserProfileScreen();
                    }));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: const Color(0xffE0e0e0)
                      ),
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.transparent
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          height: 50, width: 50,
                          clipBehavior: Clip.hardEdge,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle
                          ),
                          child: Image.asset(
                            "assets/settings_icons/avatar.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Gap(12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Shermuhammad",
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              Gap(4),
                              Text(
                                "abduolimovsh@gmail.com",
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xff757575)
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20, width: 20,
                          child: Image.asset(
                            "assets/additional_icons/arrow_right_ios.png"
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const Gap(12),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color(0xffE0e0e0)
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    children: List.generate(
                      appSettings.length, (index) {
                        return GestureDetector(
                          onTap: appSettings[index]["on_tap"],
                          child: Container(
                            padding: const EdgeInsets.only(top: 12, bottom: 12),
                            decoration: const BoxDecoration(
                              color: Colors.transparent
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 28,
                                  child: Image.asset(
                                    appSettings[index]['icon']
                                  ),
                                ),
                                const Gap(10),
                                Text(
                                  appSettings[index]["label"],
                                  style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500
                                  ),
                                ),
                                const Spacer(),
                                const Gap(5),
                                SizedBox(
                                  height: 20, width: 20,
                                  child: Image.asset(
                                    "assets/additional_icons/arrow_right_ios.png"
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ),
                const Gap(12),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color(0xffE0e0e0)
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    children: List.generate(
                      appInformations.length, (index) {
                        return Container(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 28,
                                child: Image.asset(
                                  appInformations[index]['icon']
                                ),
                              ),
                              const Gap(10),
                              Expanded(
                                child: Text(
                                  appInformations[index]["label"],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                              const Gap(5),
                              SizedBox(
                                height: 20, width: 20,
                                child: Image.asset(
                                  "assets/additional_icons/arrow_right_ios.png"
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    ) ;
  }
}
