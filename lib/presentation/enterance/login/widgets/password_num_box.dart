
import 'dart:developer';

import '../login_bloc/login_bloc.dart';
import 'package:flutter/material.dart';

class PasswordNumBox extends StatefulWidget {
  const PasswordNumBox({
    super.key,
  });

  @override
  State<PasswordNumBox> createState() => _PasswordNumBoxState();
}

class _PasswordNumBoxState extends State<PasswordNumBox> {
  late List<int> numbers;
  late List<double> scales;
  late final LogInBloc bloc;

  @override
  void initState() {
    bloc = context.read<LogInBloc>();
    numbers = bloc.numbers;
    scales = List.filled(numbers.length, 1.0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      flex: 12,
      child: Container(
        alignment: Alignment.center,
        width: 310,
        child: Wrap(
          alignment: WrapAlignment.end,
          direction: Axis.horizontal,
          spacing: 30,
          runSpacing: 15,
          children: List.generate(numbers.length, (index) {
            return (index != numbers.length - 1 && index != numbers.length - 3)
              ? GestureDetector(
                  onTapUp: (details) => setState(() => scales[index] = 1.0),
                  onTapDown: (details) =>
                      setState(() => scales[index] = 0.9),
                  onTapCancel: () => setState(() => scales[index] = 1.0),
                  onTap: () {
                    bloc.add(LoginPasswordTyping(index: index));
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Transform.scale(
                      scale: scales[index],
                      child: Container(
                        height: 73,
                        width: 73,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color(0xfff5f5f5),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "${numbers[index]}",
                          style: TextStyle(color: scheme.onSurface, fontSize: 36),
                        ),
                      ),
                    ),
                  ),
                )
              : GestureDetector(
                onTap: () {
                  bloc.add(LoginPasswordTyping(index: index));
                },
                onLongPress: () {
                  if(index == numbers.length - 3){
                    log("longPress");
                  }
                },
                child: Container(
                  height: 73, width: 73,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.transparent
                  ),
                  child: (index != numbers.length - 1)
                    ? SizedBox(
                    width: 40,
                    height: 40,
                    child: context.watch<LogInBloc>().devicePasswordEnum == DevicePasswordEnum.enterExistingPassword ? Image.asset(
                      "assets/icons/fingerprint.png",
                    ) : null
                  ) : SizedBox(
                    width: 36,
                    height: 36,
                    child: Image.asset(
                      "assets/additional_icons/delete.png",
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}