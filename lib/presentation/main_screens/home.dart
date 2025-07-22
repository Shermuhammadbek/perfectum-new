import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:perfectum_new/logic/providers/main_bloc/main_bloc.dart';

class Home extends StatefulWidget {
  static const String routeName = "/home";
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late MainBloc bloc;

  @override
  void initState() {
    bloc = context.read<MainBloc>();
    bloc.currentPageIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget currentScreen = bloc.mainPages[bloc.currentPageIndex];

    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        if (state is MainPageChanged) {
          currentScreen = state.page;
        }
        return Scaffold(
          body: currentScreen,
          resizeToAvoidBottomInset: false,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: const MyNavigationBar(),
        );
      },
    );
  }
}




class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  @override
  State<MyNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<MyNavigationBar> {
  late MainBloc bloc;
  int selectedIndex = 0;

  @override
  void initState() {
    bloc = context.read<MainBloc>();
    selectedIndex = bloc.currentPageIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        if (state is MainPageChanged) {
          selectedIndex = state.index;
        }
        return Container(
          decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 24,
              blurStyle: BlurStyle.outer,
              color: Color.fromARGB(20, 0, 0, 0),
              spreadRadius: 0,
            ),
          ]),
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
          child: SafeArea(
            child: Row(
              children: List.generate(data.length, (index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      bloc.add(ChangeMainPage(index: index));
                    },
                    child: Container(
                      height: 64,
                      decoration: const BoxDecoration(
                        color: Colors.transparent
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            selectedIndex == index ? data.values.toList()[index]["icon_s"] : data.values.toList()[index]["icon"],
                            width: 26,  height: 26,
                            fit: BoxFit.cover,
                          ),
                          const Gap(4),
                          Text(
                            data.keys.toList()[index],
                            style: TextStyle(
                              fontWeight: selectedIndex == index ? FontWeight.bold : FontWeight.w500,
                              letterSpacing: 0.5,
                              fontSize: 11
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          )
        );
      },
    );
  }
}

const String _iconRoute = "assets/navigation_icons";

Map<String, Map<String, dynamic>> data = {
  "Главная": {
    "icon_s" : "$_iconRoute/home_s.png",
    "icon" : "$_iconRoute/home.png",
  },
  "Транзакции": {
    "icon_s" : "$_iconRoute/payment_s.png",
    "icon" : "$_iconRoute/payment.png",
  },
  "Новости": {
    "icon_s" : "$_iconRoute/media_s.png",
    "icon" : "$_iconRoute/media.png",
  },
  "Настройки": {
    "icon_s" : "$_iconRoute/settings_s.png",
    "icon" : "$_iconRoute/settings.png",
  }
};

// home /
/// bosh menyu,
/// media,
/// moliya,
/// profil

/// Главный
/// Медиа
/// Финансы
/// Профиль