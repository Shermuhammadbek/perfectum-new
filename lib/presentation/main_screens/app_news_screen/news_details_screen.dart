import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:perfectum_new/presentation/main_screens/main_models/app_news_model.dart';
import 'package:perfectum_new/presentation/main_widgets/app_appbar.dart';
import 'package:shimmer/shimmer.dart';

class NewsDetailsScreen extends StatelessWidget {
  final AppNewsModel news;
  final int newsIndex;
  const NewsDetailsScreen({
    super.key, required this.news,
    required this.newsIndex
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const MyAppBar(
            title: "Новость",
          ),
          const Gap(8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast,
              ),
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  margin: const  EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.asset(
                    "assets/news_bg_images/${newsIndex + 1}.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(8),
                Text(
                  news.description,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black45
                  ),
                ),
                const Gap(8),
                Text(
                  DateFormat('dd.MM.yyyy').format(news.createdAt),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black45
                  ),
                ), 
              ],
            ),
          ),
        ],
      ),
    );
  }
}