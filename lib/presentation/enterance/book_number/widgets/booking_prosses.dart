
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';

class BookingProsses extends StatefulWidget {
  final int activeIndex;
  const BookingProsses({
    super.key, required this.activeIndex
  });

  @override
  State<BookingProsses> createState() => _BookingProssesState();
}

class _BookingProssesState extends State<BookingProsses> {

  late final int activeIndex;

  @override
  void initState() {
    activeIndex = widget.activeIndex ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: EasyStepper(
        activeStep: activeIndex,
        lineStyle: LineStyle(
          lineLength: 15,
          lineType: LineType.normal,
          lineThickness: 1,
          lineSpace: 3,
          unreachedLineColor: Colors.grey.shade300,
          lineWidth: 5,
          unreachedLineType: LineType.dashed,
          finishedLineColor: const Color(0xffe50101),
          activeLineColor: const Color(0xffe0e0e0),
          defaultLineColor: const Color(0xffe0e0e0),
        ),
        disableScroll: true,
        borderThickness: 2,
        activeStepTextColor: Colors.black87,
        finishedStepTextColor: Colors.black87,
        internalPadding: 3,
        showLoadingAnimation: false,
        stepRadius: 18,
        showTitle: false,
        titlesAreLargerThanSteps: false,
        alignment: Alignment.center,
      
        finishedStepBackgroundColor: const Color(0xffE50101).withAlpha(26),
        activeStepBorderColor: const Color(0xffe50101),
        activeStepBorderType: BorderType.normal,
        defaultStepBorderType: BorderType.normal,
        showStepBorder: true,
      
        steps: List.generate(7, (index) {
          return EasyStep(
            customStep: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Opacity(
                opacity: 1,
                child: activeIndex > index 
                  ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      "assets/booking_icons/check.png",
                      width: 12,
                    ),
                  ) 
                  : activeIndex == index 
                  ? Text(
                    "${index + 1}",
                    style: const TextStyle(
                      color: Color(0xffe50101),
                      fontSize: 14, fontWeight: FontWeight.w600
                    ),
                  )
                  : Text(
                    "${index + 1}",
                    style: const TextStyle(
                      color: Color(0xff757575),
                      fontSize: 14, fontWeight: FontWeight.w600
                    ),
                  ) ,
              ),
            ),
          );
        }),
      ),
    );
  }
}