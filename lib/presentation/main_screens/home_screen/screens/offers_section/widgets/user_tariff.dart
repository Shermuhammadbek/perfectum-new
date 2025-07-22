import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserTariff extends StatelessWidget {
  const UserTariff({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ваш план",
                    style: TextStyle(
                      fontSize: 14, 
                      color: Color(0xff616161)
                    ),
                  ),
                  Gap(3),
                  Text(
                    "Класс Люкс",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 13, right: 13, top: 8, bottom: 8,
                ),
                decoration: BoxDecoration(
                  color:  Color(0xffe50101).withAlpha(26),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Text(
                  "5G",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xffe50101),
                    fontWeight: FontWeight.w700
                  ),
                ),
              )
            ],
          ),
          Gap(24),
          Container(
            height: 80, width: double.infinity,
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xffe0e0e0),
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: List.generate(2, (index) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: index == 1 ? 12 : 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          index == 0 ? "Ежемесячная оплата" : "Следующий платеж",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff616161),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          index == 0 ? "200 000 UZS" : "24.07.2025",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          Gap(12),
          Container(
            height: 125, width: double.infinity,
            padding: EdgeInsets.only(top: 18.5, bottom: 18.5, left: 20, right: 20),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xffe0e0e0),
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Лимиты по тарифу",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700
                  ),
                ),  
                Gap(16),
                SizedBox(
                  height: 44,
                  child: Row(
                    children: [
                      Container(
                        height: 44, width: 44,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xfff5f5f5),
                          shape: BoxShape.circle
                        ),
                        child: Image.asset("assets/home_icons/internet.png"),
                      ),
                      Gap(12),
                      Text(
                        "100 ГБ",
                        style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700
                        ),
                      )
                    ],
                  ),
                ),
              ]
            ),
          ),
          Gap(16),
          Container(
            padding: EdgeInsets.only(top: 18.5, bottom: 18.5, left: 20, right: 20),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xffe0e0e0),
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Описание",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700
                  ),
                ),
                Gap(12),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff616161)
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}


String description = "Оставайтесь на связи в любое время и в любом месте с Smart+ — идеальным мобильным тарифом для ваших повседневных нужд. Получите щедрый интернет, минуты звонков и варианты сообщений, всё в одном пакете.";