import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:perfectum_new/presentation/main_widgets/app_appbar.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const MyAppBar(title: "Карта покрытия"),
          const Gap(16),
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
                left: 16, right: 16, bottom: 40,
              ),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
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
                    print('Tapped at: ${point.latitude}, ${point.longitude}');
                  },
                ),
                children: [
                  // Tile layer (map tiles)
                  TileLayer(
                    urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    maxZoom: 19,
                  ),
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}
