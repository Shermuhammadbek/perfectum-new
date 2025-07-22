
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:perfectum_new/presentation/enterance/book_number/screens/select_number.dart';
import 'package:perfectum_new/presentation/enterance/book_number/widgets/booking_prosses.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/screens/map_screen.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/screens/offers_section/screens/offer_details_screen.dart';
import 'package:perfectum_new/presentation/main_widgets/app_appbar.dart';

class LookUpLocations extends StatefulWidget {
  const LookUpLocations({super.key});

  @override
  State<LookUpLocations> createState() => _LookUpLocationsState();
}

class _LookUpLocationsState extends State<LookUpLocations> {

  final MapController _mapController = MapController();

  int active = 0;
  bool isUserAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          MyAppBar(
            title: "Регистрация",
            trailing: Container(
              height: 26,
              padding: const EdgeInsets.only(right: 16),
              child: Image.asset("assets/settings_icons/info.png"),
            ),
          ),

          const Gap(8),

          const BookingProsses(activeIndex: 0,),

          Container(
            padding: const EdgeInsets.only(
              left: 16, right: 16, top: 10, bottom: 16
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Проверка Карта покрытия",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700
                  ),
                ),
                Gap(8),
                Text(
                  "На карте ниже показана зона покрытия сети Perfectum. Убедитесь, что ваш адрес входит в зону обслуживания, чтобы успешно подключить SIM-карту.",
                  style: TextStyle(
                    color: Color(0xff616161),
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            padding: const EdgeInsets.only(left: 16, right: 16),
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xfff5f5f5),
              borderRadius: BorderRadius.circular(16)
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 22,
                  child: Image.asset("assets/home_icons/search.png"),
                ),
                const Gap(12),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Введите адрес для поиска",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 16,
                        color: Colors.black45
                      ),
                    ),
                    style: TextStyle(
                      fontSize:16,
                    ),
                  ),
                )
              ],
            ),
          ),
          const Gap(16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                left: 16, right: 16,
              ),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.transparent
              ),
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  // Initial center position (London)
                  center: const LatLng(41.2995, 69.2401),
                  initialZoom: 14,
                  minZoom: 3.0,
                  // maxZoom: 18.0,
                  // Enable interactions
                  enableMultiFingerGestureRace: true,
                  // Callback when map is tapped
                  onTap: (tapPosition, point) {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return const MapScreen();
                    }));
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    maxZoom: 19,
                  ),
                ],
              ),
            ),
          ),
          const Gap(16),
          GestureDetector(
            onTap: () {
              setState(() {
                isUserAccepted = !isUserAccepted;
              });
            },
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isUserAccepted ? Colors.green : const Color(0xffe0e0e0),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.transparent
                    ),
                    height: 22, width: 22,
                    child: isUserAccepted 
                      ? const Icon(Icons.check_rounded, size: 18, color: Colors.green,)
                      : null,
                  ),
                  const Gap(8),
                  const Text(
                    "Я ознакомился с зоной покрытия 5G SA",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600
                    ),
                  )
                ],
              ),
            ),
          ),
          const Gap(12),
          GestureDetector(
            onTap: () {
              if(isUserAccepted) {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return const SelectNumber();
                }));
              }
            },
            child: MyCustomButton(
              label: "Далее", color: isUserAccepted 
                ? null : const Color(0xffe50101).withAlpha(100),
            ),
          )
        ],
      ),
    );
  }
}



