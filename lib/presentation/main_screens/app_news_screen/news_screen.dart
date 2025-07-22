import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:perfectum_new/presentation/main_screens/app_news_screen/news_details_screen.dart';
import 'package:perfectum_new/presentation/main_screens/main_models/app_news_model.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {

  List<AppNewsModel> appNews = [];

  @override
  void initState() {
    appNews = List.generate(exampleNewsList.length, (index) {
      return AppNewsModel.fromMap(exampleNewsList[index]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Text(
                'Новости',
                style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w700
                ),
              ),
            ),
          ),
          const Gap(8),
          Expanded(
            child: ListView.separated(
              itemCount: appNews.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (ctx, index) {
                return AppNewsBox(newsIndex: index, news: appNews[index],);
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



class AppNewsBox extends StatelessWidget {
  final int newsIndex;
  final AppNewsModel news;
  const AppNewsBox({
    super.key, required this.newsIndex,
    required this.news,
  }); 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (ctx) {
          return NewsDetailsScreen(
            news: news, newsIndex: newsIndex
          );
        }));
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent
        ),
        height: 100,
        width: double.infinity,
        child: Row(
          children: [
            Container(
              width: 125, height: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16))
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.asset(
                "assets/news_bg_images/${newsIndex + 1}.jpg",
                fit: BoxFit.cover,
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    maxLines: 3,
                    overflow: TextOverflow.fade,
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(
                    DateFormat('dd.MM.yyyy').format(news.createdAt),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}



final List<Map<String, dynamic>> exampleNewsList = [
  {
    "created_at": "2025-07-01T09:00:00Z",
    "image": "https://example.com/news_voip1.jpg",
    "title": "Perfectum запускает новый тариф с безлимитными голосовыми звонками через интернет",
    "description": "Интернет-провайдер Perfectum представил новый тарифный план, который включает безлимитные голосовые звонки по технологии VoIP. Этот тариф позволяет абонентам совершать звонки по всей стране и за границу без дополнительных расходов, используя только интернет-соединение. Особенно удобно для пользователей в отдалённых регионах."
  },
  {
    "created_at": "2025-07-02T12:30:00Z",
    "image": "https://example.com/news_voip2.jpg",
    "title": "Perfectum дарит бесплатные минуты на международные интернет-звонки до конца месяца",
    "description": "Компания Perfectum объявила акцию: всем новым и текущим абонентам предоставляется 100 бесплатных минут для международных VoIP-звонков. Воспользоваться предложением можно через мобильное приложение Perfectum. Акция действует до 31 июля 2025 года включительно."
  },
  {
    "created_at": "2025-07-03T08:45:00Z",
    "image": "https://example.com/news_voip3.jpg",
    "title": "Perfectum запускает улучшенный VoIP-сервис с высоким качеством звука и безопасностью",
    "description": "Провайдер Perfectum внедрил обновлённый VoIP-сервис, обеспечивающий HD-качество звука и полное шифрование звонков. Теперь все вызовы защищены от перехвата, что повышает уровень безопасности и конфиденциальности пользователей. Новая функция доступна во всех актуальных тарифах без дополнительной оплаты."
  },
  {
    "created_at": "2025-07-01T09:00:00Z",
    "image": "https://example.com/news_voip1.jpg",
    "title": "Perfectum запускает новый тариф с безлимитными голосовыми звонками через интернет",
    "description": "Интернет-провайдер Perfectum представил новый тарифный план, который включает безлимитные голосовые звонки по технологии VoIP. Этот тариф позволяет абонентам совершать звонки по всей стране и за границу без дополнительных расходов, используя только интернет-соединение. Особенно удобно для пользователей в отдалённых регионах."
  },
  {
    "created_at": "2025-07-02T12:30:00Z",
    "image": "https://example.com/news_voip2.jpg",
    "title": "Perfectum дарит бесплатные минуты на международные интернет-звонки до конца месяца",
    "description": "Компания Perfectum объявила акцию: всем новым и текущим абонентам предоставляется 100 бесплатных минут для международных VoIP-звонков. Воспользоваться предложением можно через мобильное приложение Perfectum. Акция действует до 31 июля 2025 года включительно."
  },
  {
    "created_at": "2025-07-03T08:45:00Z",
    "image": "https://example.com/news_voip3.jpg",
    "title": "Perfectum запускает улучшенный VoIP-сервис с высоким качеством звука и безопасностью",
    "description": "Провайдер Perfectum внедрил обновлённый VoIP-сервис, обеспечивающий HD-качество звука и полное шифрование звонков. Теперь все вызовы защищены от перехвата, что повышает уровень безопасности и конфиденциальности пользователей. Новая функция доступна во всех актуальных тарифах без дополнительной оплаты."
  },
];

