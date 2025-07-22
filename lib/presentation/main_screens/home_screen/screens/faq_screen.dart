import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:perfectum_new/presentation/main_widgets/app_appbar.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {

  List<bool> _expandedItems = [];

  List<Map<String,dynamic>> faqData = [
    {
      "id": "1",
      "question": "Как я могу устранить проблемы с подключением в моем приложении для телекоммуникаций?",
      "answer": "Для устранения проблем с подключением попробуйте следующие шаги: проверьте стабильность интернет-соединения, перезапустите приложение, очистите кэш приложения, обновите приложение до последней версии. Если проблема сохраняется, обратитесь в службу технической поддержки."
    },
    {
      "id": "2", 
      "question": "На какие функции мне следует обратить внимание в приложении для телекоммуникаций?",
      "answer": "Для большинства из нас жизнь без смартфона и интернета сегодня почти немыслима. Важнейшие функции включают: управление тарифными планами, мониторинг расходов, пополнение баланса, настройки безопасности, техническую поддержку онлайн."
    },
    {
      "id": "3",
      "question": "Каковы преимущества использования приложения для телекоммуникаций для управления моим аккаунтом?",
      "answer": "Мобильные приложения телекоммуникационных компаний предоставляют удобный доступ к управлению аккаунтом 24/7, мгновенные уведомления о тарифах и акциях, быстрое пополнение баланса, детальную статистику использования услуг, персонализированные предложения и экономию времени."
    }
  ];

  @override
  void initState() {
    super.initState();
    _expandedItems = List.generate(faqData.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {

    

    return Scaffold(
      body: Column(
        children: [
          const MyAppBar(
            title: "FAQ",
          ),
          const Gap(8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
              itemCount: faqData.length,
              itemBuilder: (ctx, index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xffe0e0e0),
                    ),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  padding: const EdgeInsets.only(top: 16, left: 16, bottom: 16, right: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              faqData[index]["question"],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _expandedItems = List.generate(faqData.length, (i) {
                                  return index == i ? _expandedItems[index] : false;
                                });
                                _expandedItems[index] = !_expandedItems[index];
                              });
                            },
                            child: Container(
                              height: 34,
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.transparent
                              ),
                              child: Image.asset(
                                _expandedItems[index] ? "assets/home_icons/arrow_up.png" 
                                  : "assets/home_icons/arrow_down.png",
                              ),
                            ),
                          )
                        ],
                      ),
                      const Gap(12),
                      if(_expandedItems[index])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          faqData[index]["answer"],
                          style: const TextStyle(
                            color: Color(0xff757575)
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }, 
              separatorBuilder: (ctx, index) {
                return const Gap(12);
              }, 
            ),
          )
        ],
      ),
    );
  }
}




