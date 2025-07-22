
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

void logOutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) {
      return const LogOutDialog();
    },
  );
}

class LogOutDialog extends StatefulWidget {
  const LogOutDialog({
    super.key,
  });

  @override
  State<LogOutDialog> createState() => _LogOutDialogState();
}

class _LogOutDialogState extends State<LogOutDialog> {
  final double start = 1.0;
  final double finish = 0.9;
  late List<double> scales;

  @override
  void initState() {
    scales = List.filled(2, start);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        height: 60,
        width: 60,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Color(0xffe50101).withAlpha(180),
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                blurRadius: 5,
                spreadRadius: 0.3,
                color: Color.fromARGB(255, 232, 232, 232),
                blurStyle: BlurStyle.outer,
              ),
            ]),
        child: Image.asset("assets/icons/alert.png"),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: double.maxFinite,
            height: 10,
          ),
          const Text(
            "Are you sure you want to exit?",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromARGB(255, 89, 89, 89),
                fontSize: 17,
                letterSpacing: 0.5),
          ),
          const Gap(25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(scales.length, (index) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      Navigator.of(context).pop();
                    }
                  },
                  onTapUp: (details) => setState(() => scales[index] = 1.0),
                  onTapDown: (details) => setState(() => scales[index] = 0.9),
                  onTapCancel: () => setState(() => scales[index] = 1.0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    alignment: Alignment.center,
                    child: Transform.scale(
                      scale: scales[index],
                      child: Container(
                        margin: EdgeInsets.only(
                            right: index == 0 ? 10 : 0,
                            left: index == 1 ? 10 : 0),
                        height: 40,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color.fromARGB(255, 237, 237, 237),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 5,
                                  spreadRadius: 0.3,
                                  color: Colors.grey,
                                  blurStyle: BlurStyle.outer),
                            ]),
                        alignment: Alignment.center,
                        child: Text(
                          index == 0 ? "Cancel" : "Yes",
                          style: const TextStyle(
                              fontSize: 15, letterSpacing: 0.8, color: Color(0xffe50101)),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}