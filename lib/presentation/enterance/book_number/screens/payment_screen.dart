import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:perfectum_new/presentation/enterance/book_number/screens/pay_with_card_screen.dart';
import 'package:perfectum_new/presentation/enterance/book_number/widgets/booking_prosses.dart';
import 'package:perfectum_new/presentation/enterance/login/login_screen.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/screens/offers_section/screens/offer_details_screen.dart';
import 'package:perfectum_new/presentation/main_widgets/app_appbar.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  final int active = 6;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {

    List<String> payOptions = [
      "assets/booking_icons/payme.png", 
      "assets/booking_icons/click.png",
      "Картой", "Наличными c Paynet",
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          MyAppBar(
            title: "Регистрация",
            trailing: Container(
              height: 26,
              padding: const EdgeInsets.only(right: 16),
              child: Image.asset("assets/settings_icons/info.png"),
            ),
            onTap: () async {
              Navigator.of(context).popUntil((route) {
                return route.settings.name == LoginScreen.routeName;
              },);
            },
          ),
          const Gap(8),
          BookingProsses(activeIndex: active,),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Оплата и активация аккаунта",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    const Gap(8),
                    const Text(
                      "У вас есть 37 часов для завершения оплаты. Если время истечет, ваш заказ будет отменен.",
                      style: TextStyle(
                        color: Color(0xff616161),
                        fontSize: 14,
                        fontWeight: FontWeight.w400
                      ),
                    ),
                    const Gap(8),
                    Container(
                      padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 9, bottom: 9
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff007aff).withAlpha(39),
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: const Text(
                        "36 часов 45 минут 50 секунд",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff007aff)
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(24),

                GestureDetector(
                  onTap: () {
                    showDialog(context: context, builder: (ctx) {
                      return const Dialog(
                        insetPadding: EdgeInsets.all(16),
                        child: PriceInfomationDialog(),
                      );
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xffe0e0e0),
                        width: 1, strokeAlign: BorderSide.strokeAlignInside,
                      ),
                      borderRadius: BorderRadius.circular(24)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Общая стоимость:",
                              style: TextStyle(
                                color: Color(0xff616161)
                              ),
                            ),
                            Gap(4),
                            Text(
                              "1 420 000 сум",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 48, height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xfff5f5f5),
                            borderRadius: BorderRadius.circular(24)
                          ),
                          child: SizedBox(
                            height: 16, width: 16,
                            child: Image.asset("assets/additional_icons/arrow_right_ios.png"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const Gap(24),
                const Text(
                  "Выберите способ оплаты",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(16),
                ...List.generate(payOptions.length, (index){
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if(selectedIndex == index) {
                          selectedIndex = null;
                        } else {
                          selectedIndex = index;
                        }
                      });
                    },
                    child: Container(
                      height: 56,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: selectedIndex == index ? Border.all(
                          color: const Color(0xffe50101),
                          strokeAlign: BorderSide.strokeAlignInside
                        ) : null,
                        borderRadius: BorderRadius.circular(16),
                        color: selectedIndex == index ? null : const Color(0xfff5f5f5),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if(payOptions[index].startsWith("assets"))
                            SizedBox(
                              height: 19,
                              child: Image.asset(payOptions[index]),
                            ) 
                          else Text(
                            payOptions[index],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          Container(
                            height: 16, width: 16,
                            decoration: BoxDecoration(
                              border: selectedIndex == index ? Border.all(
                                color: const Color(0xffe50101),
                                width: 5
                              ) : Border.all(
                                color: const Color(0xff9e9e9e)
                              ),
                              shape: BoxShape.circle
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                })
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if(selectedIndex == 2) {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return const PayWithCardScreen();
                }));
              }
            },
            child: const MyCustomButton(
              label: "Подтвердить",
            ),
          ),
        ],
      ),
    );
  }
}





class PriceInfomationDialog extends StatelessWidget {
  const PriceInfomationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                child: Image.asset("assets/booking_icons/file.png"),
              ),
              const Gap(24),
              const Text(
                "Детали заказа",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700
                ),
              ),
              const Gap(8),
              const Text(
                "В этом диалоговом окне вы можете просмотреть детали вашего заказа, включая список товаров, их количество и общую стоимость.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff757575)
                ),
              ),
              const Gap(24),
              buildRow("SIM-card", "20 000 сум"),
              const Gap(16),
              buildRow("Tariff Asl 5G", "200 000 сум"),
              const Gap(16),
              buildRow("Tozed", "1 200 000 сум"),
              const Gap(16),
              buildRow("Итого", "1 420 000 сум", isTotal: true),
              const Gap(8)
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
    );
  }



  Widget buildRow(String title, String amount, {bool isTotal = false}) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Container(
            height: 18,
            alignment: Alignment.bottomCenter,
            child: LayoutBuilder(
              builder: (context, constraints) {
                const dotWidth = 5.0;
                const dotSpacing = 5.0;
                final dotsCount = (constraints.maxWidth / (dotWidth + dotSpacing)).floor();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    dotsCount,
                    (index) => Container(
                      width: ((index == 0) || (index == dotsCount - 1 )) ? 2 : dotWidth,
                      height: 1,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

}
