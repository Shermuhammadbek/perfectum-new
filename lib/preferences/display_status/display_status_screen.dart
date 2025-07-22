import 'package:flutter/material.dart';
import 'package:perfectum_new/preferences/display_status/status_enum.dart';
import 'package:perfectum_new/presentation/main_widgets/app_appbar.dart';
import 'package:svg_flutter/svg_flutter.dart';

class DisplayStatusScreen extends StatefulWidget {
  static const String routeName = '/displayStatus';
  final String? title;

  final DisplayStatusEnum statusEnum;

  const DisplayStatusScreen({
    super.key, required this.statusEnum,
    this.title
  });

  @override
  State<DisplayStatusScreen> createState() => _DisplayStatusScreenState();
}

class _DisplayStatusScreenState extends State<DisplayStatusScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
            ),
            if(widget.title != null) 
            MyAppBar(
              title: widget.title!
            ),
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              alignment: Alignment.center,
              child: timeoutContent(),
            ),
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              alignment: Alignment.bottomCenter,
              child: MyCustomBox(
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        )

          // widget.statusEnum == DisplayStatusEnum.loading
          // ? loadingContent()
          // : widget.statusEnum == DisplayStatusEnum.notFound
          // ? notFoundContent()
          // : widget.statusEnum == DisplayStatusEnum.error
          // ? errorContent()
          // : widget.statusEnum == DisplayStatusEnum.timeout
          // ? timeoutContent() 
          // : widget.statusEnum == DisplayStatusEnum.noInternet
          // ? noInternetContent()
          // : emptyContent(),
      ),
    );
  }


  Widget timeoutContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xfff5f5f5),
            borderRadius: BorderRadius.circular(20),
          ),
          height: 56, width: 56,
          padding: const EdgeInsets.all(16.0),
          child: SvgPicture.asset("assets/home_icons/clock.svg",),
        ),
        Container(
          margin: EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            "Страница пуста",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xff000000),
            ),
          ),
        ),
        Text(
          "Пожалуйста, проверьте подключение к интернету и повторите попытку позже.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xff000000),
          ),
        ),
      ],
    );
  }
}





class MyCustomBox extends StatelessWidget {
  final Function()? onTap;
  final Color? color;

  const MyCustomBox({
    super.key, this.onTap, this.color
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(
          left: 8, right: 8, bottom: 16, top: 16
        ),
        height: 51,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color ?? Color(0xfff5f5f5),
          borderRadius: BorderRadius.circular(18.0),
        ),
        alignment: Alignment.center,
        child: Text(
          "Назад",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xff000000),
          ),
        ),
      ),
    );
  }
}
