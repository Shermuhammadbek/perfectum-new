
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:perfectum_new/presentation/enterance/book_number/screens/payment_screen.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/screens/offers_section/screens/offer_details_screen.dart';
import 'package:perfectum_new/presentation/main_widgets/app_appbar.dart';

class PayWithCardScreen extends StatefulWidget {
  const PayWithCardScreen({super.key});

  @override
  State<PayWithCardScreen> createState() => _PayWithCardScreenState();
}

class _PayWithCardScreenState extends State<PayWithCardScreen> {
  late final TextEditingController cardNumberController;
  late final TextEditingController cardDateController;
  
  // FocusNode'lar
  late final FocusNode cardNumberFocusNode;
  late final FocusNode cardDateFocusNode;

  @override
  void initState() {
    super.initState();

    cardDateController = TextEditingController();
    cardNumberController = TextEditingController();
    
    cardNumberFocusNode = FocusNode();
    cardDateFocusNode = FocusNode();
  }
  
  @override
  void dispose() {
    cardNumberFocusNode.dispose();
    cardDateFocusNode.dispose();
    cardNumberController.dispose();
    cardDateController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          MyAppBar(
            title: "Оплата картой",
            trailing: Container(
              height: 26,
              padding: const EdgeInsets.only(right: 16),
              child: Image.asset("assets/settings_icons/info.png"),
            ),
          ),
          const Gap(16),
          Container(
            padding: const EdgeInsets.only(
              left: 16, right: 16,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Оплата картой",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700
                  ),
                ),
                Gap(8),
                Text(
                  "Введите данные вашей банковской карты, чтобы завершить оплату. Пожалуйста, укажите номер карты, срок действия и код безопасности, который находится на обратной стороне",
                  style: TextStyle(
                    color: Color(0xff616161),
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                  ),
                )
              ],
            ),
          ),
          const Gap(24),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            padding: const EdgeInsets.only(left: 16, right: 16),
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xfff5f5f5),
              borderRadius: BorderRadius.circular(16)
            ),
            alignment: Alignment.center,
            child: TextField(
              focusNode: cardNumberFocusNode,
              controller: cardNumberController,
              keyboardType: TextInputType.number,
              maxLength: 19,  // 16 raqam + 3 ta bo'sh joy
              decoration: const InputDecoration(
                hintText: "Номер карты",
                border: InputBorder.none,
                counterText: "",
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.black45
                ),
              ),
              style: const TextStyle(
                fontSize: 16,
              ),
              onTapOutside: (event) {
                FocusScope.of(context).setFirstFocus(FocusScopeNode());
              },
              onChanged: (value) {
                String newValue = value.replaceAll(' ', '');
                if (newValue.isNotEmpty) {
                  // Faqat raqamlarni qoldirish
                  newValue = newValue.replaceAll(RegExp(r'[^0-9]'), '');
                  
                  // 4 tadan ajratish
                  final buffer = StringBuffer();
                  for (int i = 0; i < newValue.length; i++) {
                    if (i > 0 && i % 4 == 0) {
                      buffer.write(' ');
                    }
                    buffer.write(newValue[i]);
                  }
                  newValue = buffer.toString();
                }
                
                if (newValue != value) {
                  cardNumberController.text = newValue;
                  cardNumberController.selection = TextSelection.fromPosition(
                    TextPosition(offset: cardNumberController.text.length),
                  );
                }
              },
            ),
          ),
          const Gap(12),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            padding: const EdgeInsets.only(left: 16, right: 16),
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xfff5f5f5),
              borderRadius: BorderRadius.circular(16)
            ),
            alignment: Alignment.center,
            child: TextField(
              focusNode: cardDateFocusNode,
              controller: cardDateController,
              keyboardType: TextInputType.number,
              maxLength: 5,  // MM/YY
              decoration: const InputDecoration(
                hintText: "ММ/ГГ",
                border: InputBorder.none,
                counterText: "",
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.black45
                ),
              ),
              onTapOutside: (event) {
                FocusScope.of(context).setFirstFocus(FocusScopeNode());
              },
              style: const TextStyle(
                fontSize: 16,
              ),
              // onTap o'chirildi - TextField o'zi focus oladi
              onChanged: (value) {
                String numbers = value.replaceAll('/', '');
                numbers = numbers.replaceAll(RegExp(r'[^0-9]'), '');
                
                if (numbers.length >= 2) {
                  String month = numbers.substring(0, 2);
                  
                  // Oy 01-12 oralig'ida bo'lishi kerak
                  int? monthInt = int.tryParse(month);
                  if (monthInt != null && monthInt > 12) {
                    month = '12';
                  }
                  
                  String year = numbers.length > 2 ? numbers.substring(2, numbers.length > 4 ? 4 : numbers.length) : '';
                  
                  cardDateController.text = '$month${year.isNotEmpty ? '/$year' : ''}';
                  cardDateController.selection = TextSelection.fromPosition(
                    TextPosition(offset: cardDateController.text.length),
                  );
                }
              },
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (ctx) {
                  return const Dialog(
                    insetPadding: EdgeInsets.all(16),
                    child: PriceInfomationDialog(),
                  );
                }
              );
            },
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xffe0e0e0),
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignInside,
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
                    width: 48,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xfff5f5f5),
                      borderRadius: BorderRadius.circular(24)
                    ),
                    child: SizedBox(
                      height: 16,
                      width: 16,
                      child: Image.asset("assets/additional_icons/arrow_right_ios.png"),
                    ),
                  )
                ],
              ),
            ),
          ),
          const Gap(16),
          GestureDetector(
            onTap: () {

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