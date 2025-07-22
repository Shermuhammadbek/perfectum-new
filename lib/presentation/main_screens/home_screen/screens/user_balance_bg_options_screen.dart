import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/widgets/user_balance_box.dart';
import 'package:perfectum_new/presentation/main_widgets/app_appbar.dart';

class UserBalanceBgOptionsScreen extends StatefulWidget {
  const UserBalanceBgOptionsScreen({super.key});

  @override
  State<UserBalanceBgOptionsScreen> createState() => _UserBalanceBgOptionsScreenState();
}

class _UserBalanceBgOptionsScreenState extends State<UserBalanceBgOptionsScreen> {  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyAppBar(
            title: "Фоны",
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: 3,
              physics: BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast
              ),
              itemBuilder: (ctx, index) {
                return SizedBox(
                  height: 175,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset(
                          "assets/home_icons/balance_bg${index + 1}.png", fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.only(
                          left: 20, right: 16, top: 16, bottom: 16
                        ),
                        child: Container(
                          padding: EdgeInsets.only(left: 4),
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Ваш баланс",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xffFFFFFF),
                                    ),
                                  ),
                                  //! Balance amount
                                  UserBalance()
                                ],
                              ),
                              if(index == 0)
                              Container(
                                height: 52, width: 52,
                                decoration: BoxDecoration(
                                  color: Color(0xffF5F5F5),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: SizedBox(
                                  height: 20,
                                  child: Image.asset(
                                    "assets/home_icons/correct.png",
                                    fit: BoxFit.cover,
                                  ),
                                )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return Gap(16);
              },
            ),
          )
        ],
      ),
    );
  }
}