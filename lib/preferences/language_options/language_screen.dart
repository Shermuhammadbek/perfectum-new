import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:perfectum_new/presentation/main_widgets/app_appbar.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {

  // ignore: non_constant_identifier_names
  List<Map<String, dynamic>> lang_options = [
    {"label" : "Русский",},
    {"label" : "O’zbek",}
  ];

  int selected_index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const MyAppBar(title: "Язык"),
          const Gap(8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
              itemCount: lang_options.length,
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selected_index = index;
                    });
                  },
                  child: Container(
                    height: 56,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: selected_index == index ? Border.all(
                        color: const Color(0xffe50101),
                        strokeAlign: BorderSide.strokeAlignInside
                      ) : null,
                      borderRadius: BorderRadius.circular(16),
                      color: selected_index == index ? null : const Color(0xfff5f5f5),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          lang_options[index]["label"],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        Container(
                          height: 16, width: 16,
                          decoration: BoxDecoration(
                            border: selected_index == index ? Border.all(
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
              },
              separatorBuilder: (ctx, index){
                return const Gap(12);
              }, 
            ),
          )
        ],
      ),
    );
  }
}