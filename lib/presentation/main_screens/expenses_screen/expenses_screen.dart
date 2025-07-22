import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Text(
                'Поступление и расходы',
                style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w700
                ),
              ),
            ),
          ),
          const Gap(8),
          Expanded(
            child: ListView.separated(
              itemCount: 10,
              padding: const EdgeInsets.all(16),
              itemBuilder: (ctx, index) {
                return const ExpenseBox();
              },
              separatorBuilder: (ctx, index) {
                return const Gap(12);
              },
            ),
          )
        ],
      ),
    );
  }
}



class ExpenseBox extends StatelessWidget {
  const ExpenseBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xffe0e0e0),
        ),
        borderRadius: BorderRadius.circular(24)
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "PayMe",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14
                ),
              ),
              const Gap(8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xfff5f5f5),
                  borderRadius: BorderRadius.circular(7)
                ),
                child: Text(
                  DateFormat('dd.MM.yyyy').format(DateTime.now()),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12
                  ),
                ),
              )
            ],
          ),
          Text(
            "+ 100 000 UZS",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.green
            ),
          )
        ],
      ),
    );
  }
}
