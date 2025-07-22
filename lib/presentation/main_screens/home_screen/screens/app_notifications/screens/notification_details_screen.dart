import 'package:flutter/material.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/screens/app_notifications/models/notification_model.dart';
import 'package:perfectum_new/presentation/main_widgets/app_appbar.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';


class NotificationDetailsScreen extends StatelessWidget {
  final MyNotificationModel notification;
  const NotificationDetailsScreen({
    super.key, required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const MyAppBar(
            title: "Уведомления",
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(left: 16, right: 16),
              physics: const BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast,
              ),
              children: [
                if(notification.image != null)
                Container(
                  width: double.infinity,
                  height: 200,
                  margin: const  EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.network(
                  notification.image!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      // Image has loaded successfully
                      return child;
                    }
                    // Show shimmer while loading
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
                      // Optional: Handle error state
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
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black45
                  ),
                ),
                const Gap(8),
                Text(
                  DateFormat('dd.MM.yyyy').format(notification.createdAt),
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