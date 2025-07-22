import 'package:flutter/material.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/screens/offers_section/screens/offers_screen.dart';

class UserTariffBox extends StatelessWidget {
  const UserTariffBox({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (ctx) {
          return OffersScreen();
        }));
      },
      child: Container(
        height: 160,
        width: double.infinity,
        margin: EdgeInsets.only(left: 16, right: 16),
        padding: EdgeInsets.symmetric(horizontal: 13, vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(
            strokeAlign: BorderSide.strokeAlignInside,
            width: 1, color: Color(0xffE0E0E0)
          ),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 7, right: 7,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ваш тариф",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff616161),
                        ),
                      ),
                      SizedBox(height: 1.5,),
                      Text(
                        "Класс Люкс",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 40,
                    width: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xffF5F5F5),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: SizedBox(
                      height: 16, width: 16,
                      child: Image.asset(
                        "assets/additional_icons/arrow_right_ios.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 15 ,),
            Container(
              width: double.infinity,
              height: 1.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.white,
                    Color(0xffE0E0E0),
                    Colors.white,
                  ],
                ),
              ),
            ),
            SizedBox(height: 15,),
      
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7),
              child: Row(
                children: List.generate(2, (index) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: index == 1 ? 12 : 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            index == 0 ? "Ежемесячная оплата" : "Следующий платеж",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff616161),
                            ),
                          ),
                          SizedBox(height: 2,),
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
            )
          ],
        ),
      ),
    );
  }
}