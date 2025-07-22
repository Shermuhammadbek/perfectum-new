import 'package:flutter/material.dart';

class HomeStories extends StatelessWidget {
  const HomeStories({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 16, right: 16,),
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (ctx, index) {
          return SizedBox(
            width: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xffF5F5F5),
                    borderRadius: BorderRadius.circular(24),
                    // border: index == 0 ? Border.all(
                    //   // color: Color(0xffE50101),
                    //   // width: 2
                    // ) : null
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.asset(
                    "assets/news_bg_images/${index + 1}.jpg",
                    fit: BoxFit.fill,
                  ),
                ),
                Text(
                  "E-sim теперь доступны",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 8);
        },
      ),
    );
  }
}