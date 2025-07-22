import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:perfectum_new/logic/providers/main_bloc/main_bloc.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/screens/app_notifications/screens/notification_screen.dart';
import 'package:perfectum_new/source/extentions/string_extentions.dart';
import 'package:perfectum_new/source/material/my_blocs.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16, top: 10),
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: Container( 
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Добро пожаловать",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff1A1A1A),
                      ),
                    ),
                    Gap(4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          formatPhoneNumber(context.read<MainBloc>().userNumber),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff000000),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xff757575),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (ctx) {
                    return NotificationScreen();
                  }),
                );
              },
              child: Container(
                height: 48, width: 48,
                decoration: BoxDecoration(
                  color: Color(0xffF5F5F5),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(13),
                child: Image.asset("assets/home_icons/notification.png",),
              ),
            ),

          ],
        ),
      ),
    );
  }
}