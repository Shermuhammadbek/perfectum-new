import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/screens/app_notifications/models/notification_model.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/screens/app_notifications/screens/notification_details_screen.dart';
import 'package:perfectum_new/presentation/main_widgets/app_appbar.dart';
import 'package:shimmer/shimmer.dart';

class NotificationScreen extends StatefulWidget {
  static const String routeName = "NotificationScreen";
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  List<MyNotificationModel> notifications = [];

  @override
  void initState() {

    //! generate notifications
    notifications = List.generate(
      notificationExample.length, (index) {
        return MyNotificationModel.fromMap(notificationExample[index]);
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MyAppBar(
            title: "Уведомления",
          ),
          Expanded(
            child: notifications.isEmpty ? Container(
              padding: EdgeInsets.only(
                left: 16, right: 16, top: 6, bottom: 16,
              ),
              alignment: Alignment(0, -0.1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xffF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Image.asset(
                      "assets/additional_icons/empty.png",
                      width: 26,
                      height: 26,
                    ),
                  ),
                  Gap(16),
                  Text(
                    "Нет уведомлений",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Gap(8),
                  Container(
                    padding: EdgeInsets.only(
                      left: 25.5
                    ),
                    child: Text(
                      "Мы регулярно присылаем вам полезную информацию.",
                      textAlign: TextAlign.center, 
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  )
                ],
              ),
            ) :
            ListView.separated(
              padding: EdgeInsets.only(
                left: 16, right: 16, top: 6, bottom: 16,
              ),
              itemCount: notifications.length,
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return NotificationDetailsScreen(notification: notifications[index]);
                    }));
                  },
                  child: NotificationBox(
                    notification: notifications[index],
                  ),
                );
              },
              physics: BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast,
              ),
              separatorBuilder: (ctx, index) {
                return Gap(16);
              }, 
            ),
          ),
        ],
      ),
    );
  }
}


class NotificationBox extends StatelessWidget {
  final MyNotificationModel notification;
  const NotificationBox({
    super.key, required this.notification
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,  
      decoration: BoxDecoration(
        color: notification.isRead ? Color(0xfff5f5f5) : Color(0xffFEF2F2),
        borderRadius: BorderRadius.circular(24)
      ),
      constraints: BoxConstraints(
        minHeight: 80,
        maxHeight: 380,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(notification.image != null)
          SizedBox(
            width: double.infinity,
            height: 180,
            child: Image.network(
              notification.image!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Shimmer.fromColors(
                  baseColor: Colors.red[50]!,
                  highlightColor: Colors.grey[200]!,
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 180,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.error,
                    color: Colors.grey,
                    size: 50,
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  maxLines: 2, 
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gap(8),
                Text(
                  notification.subtitle,
                  overflow: TextOverflow.fade,
                  maxLines: 2, 
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black45
                  ),
                ),
                Gap(8),
                Text(
                  DateFormat('dd.MM.yyyy').format(notification.createdAt),
                  style: TextStyle(
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




const List<Map<String, dynamic>> notificationExample = [
  {
    "image": "https://marleypeifer.com/wp-content/plugins/elementor/assets/images/placeholder.png",
    "title": "📦 Great News! Your Package Has Been Shipped Successfully",
    "subtitle": "We're thrilled to let you know that your order is on the way! Track its journey and get ready to enjoy your purchase soon.",
    "created_at": "2025-06-27T10:30:00Z",
    "is_read": false
  },
  {
    "image": null,
    "title": "👋 Welcome to Our Super Amazing Shopping App – Let’s Get Started!",
    "subtitle": "Thanks for joining! Dive into a world of exciting products, personalized recommendations, and exclusive member-only deals that you won't want to miss.",
    "created_at": "2025-06-25T08:45:00Z",
    "is_read": false
  },
  {
    "image": "https://marleypeifer.com/wp-content/plugins/elementor/assets/images/placeholder.png",
    "title": "🔥 Don’t Miss Out – Our Hot Summer Deals Are Now Live!",
    "subtitle": "Shop now and save big on top categories like electronics, fashion, and home essentials. Hurry, these scorching deals won’t last long!",
    "created_at": "2025-06-26T14:00:00Z",
    "is_read": true
  },
  {
    "image": null,
    "title": "👋 Hello There – We’re Happy to See You!",
    "subtitle": "It's always nice to say hi. Keep exploring and let us know if you need anything. We're just a tap away!",
    "created_at": "2025-06-24T09:00:00Z",
    "is_read": true
  },
  {
    "image": "https://marleypeifer.com/wp-content/plugins/elementor/assets/images/placeholder.png",
    "title": "🛠️ System Update Available – Get the Latest Features",
    "subtitle": "An improved app version is ready for you! Update now for enhanced performance, bug fixes, and new features to improve your shopping experience.",
    "created_at": "2025-06-23T12:15:00Z",
    "is_read": false
  },
];
