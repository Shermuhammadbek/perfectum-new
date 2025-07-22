import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:perfectum_new/logic/models/offer_model.dart';
import 'package:perfectum_new/logic/providers/home_bloc/home_page_bloc.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/screens/offers_section/screens/offer_details_screen.dart';
import 'package:perfectum_new/source/extentions/string_extentions.dart';
import 'package:shimmer/shimmer.dart';

class AllTariffs extends StatefulWidget {
  final bool fromRegister;
  const AllTariffs({
    super.key,
    this.fromRegister = false,
  });

  @override
  State<AllTariffs> createState() => _AllTariffsState();
}

class _AllTariffsState extends State<AllTariffs> {
  int selectedIndex = 0;
  late HomePageBloc homeBloc;
  List<ProductOffering> offers = [];

  @override
  void initState() {
    homeBloc = context.read<HomePageBloc>();
    homeBloc.add(HomeLoadOffers());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageBloc, HomePageState>(
      builder: (context, state) {
        if(state is HomeOffersLoading) { 
          return const TariffListShimmer();
        }
        if(state is HomeOffersLoaded) {
          List<ProductOffering> filteredOdders = [];
          for (var i = 0; i < state.offers.length; i++) {
            if(state.offers[i].isPlan && state.offers[i].isWirelessBroadband) {
              filteredOdders.add(state.offers[i]);
            }
          }
          offers = filteredOdders;
        }
        return ListView(
          padding: const EdgeInsets.only(top: 10, bottom: 30),
          children: [
            SizedBox(
              height: 41,
              child: ListView.separated(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                itemCount: 2,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: selectedIndex == index
                          ? Border.all(color: const Color(0xffE50101))
                            : null,
                        borderRadius: BorderRadius.circular(16),
                        color: selectedIndex != index
                          ? const Color(0xfff5f5f5)
                            : null,
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                      ),
                      child: Text(
                        index == 0 ? "Asl 5G Oylik" : "Asl 5G Yillik",
                        style: TextStyle(
                          color: selectedIndex == index
                            ? const Color(0xffE50101)
                              : const Color(0xff757575),
                          fontWeight: selectedIndex == index 
                            ? FontWeight.w700 : null,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Gap(12);
                },
              ),
            ),
            const Gap(16),
            ...List.generate(offers.isNotEmpty ? 2 : offers.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TariffBox(
                  fromRegister: widget.fromRegister,
                  offer: offers[index],
                ),
              );
            })
          ],
        );
      },
    );
  }
}

class TariffBox extends StatefulWidget {
  final bool fromRegister;
  final ProductOffering offer;
  const TariffBox({
    super.key, required this.fromRegister,
    required this.offer,
  });

  @override
  State<TariffBox> createState() => _TariffBoxState();
}

class _TariffBoxState extends State<TariffBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (ctx) {
          return OfferDetailsScreen(
            fromRegister: widget.fromRegister,
            offer: widget.offer,
          );
        }));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffE0e0e0)),
          borderRadius: BorderRadius.circular(24),
        ),
        margin: const EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.offer.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const Gap(16),
            Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                      color: Color(0xfff5f5f5), shape: BoxShape.circle),
                  child: Image.asset("assets/home_icons/internet.png"),
                ),
                const Gap(12),
                const Text(
                  "Unlimited",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                )
              ],
            ),
            const Gap(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Ежемесячная оплата",
                  style: TextStyle(fontSize: 14, color: Color(0xff616161)),
                ),
                Text(
                  "${widget.offer.prices.first.amount.toString().formatPrice()} UZS",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




class TariffListShimmer extends StatelessWidget {
  const TariffListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView(
        padding: const EdgeInsets.only(top: 10),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 41,
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 16, right: 16),
              itemCount: 3,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (ctx, index) {
                return Container(
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                );
              },
              separatorBuilder: (context, index) => const Gap(12),
            ),
          ),
          const Gap(16),
          ...List.generate(2, (index) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: _ShimmerTariffBox(),
            );
          }),
        ],
      ),
    );
  }
}


// Individual tariff box shimmer
class _ShimmerTariffBox extends StatelessWidget {
  const _ShimmerTariffBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffE0e0e0)),
        borderRadius: BorderRadius.circular(24),
      ),
      margin: const EdgeInsets.only(left: 16, right: 16),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title shimmer
          Container(
            height: 20,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const Gap(16),
          // Icon and data row
          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const Gap(12),
              Container(
                height: 18,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const Gap(16),
          // Bottom row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 16,
                width: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                height: 16,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}