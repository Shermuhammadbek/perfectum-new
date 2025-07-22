
import 'package:flutter/material.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/screens/user_balance_bg_options_screen.dart';

class UserBalanceBox extends StatelessWidget {
  const UserBalanceBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16,),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.asset(
              "assets/home_icons/balance_bg1.png", fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                      return const UserBalanceBgOptionsScreen();
                    }));
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),  
                      color: const Color.fromARGB(80, 255, 255, 255),
                    ),
                    child: SizedBox(
                      width: 16,
                      child: Image.asset("assets/home_icons/edit.png",),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.only(left: 4),
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ваш баланс",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xffFFFFFF),
                              ),
                            ),
                            //! Balance amount
                            UserBalance()
                          ],
                        ),
                        Container(
                          height: 52, width: 52,
                          decoration: const BoxDecoration(
                            color: Color(0xffF5F5F5),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: 20,
                            child: Image.asset(
                              "assets/home_icons/add.png",
                              fit: BoxFit.cover,
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}







class UserBalance extends StatefulWidget {
  const UserBalance({super.key});

  @override
  State<UserBalance> createState() => _UserBalanceState();
}

class _UserBalanceState extends State<UserBalance>
    with TickerProviderStateMixin {
  bool isVisible = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
    
    if (isVisible) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Animated balance text
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: isVisible
              ? SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      "100 000 UZS",
                      key: const ValueKey('balance'),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xffFFFFFF),
                      ),
                    ),
                  ),
                )
              : Text(
                  "********",
                  key: const ValueKey('hidden'),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xffFFFFFF),
                    letterSpacing: 4,
                  ),
                ),
        ),
        const SizedBox(width: 8),
        
        GestureDetector(
          onTap: _toggleVisibility,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            transform: Matrix4.identity()..scale(isVisible ? 1.0 : 0.9),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return RotationTransition(
                  turns: Tween(begin: 0.1, end: 0.0).animate(animation),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              child: Image.asset(
                isVisible 
                    ? "assets/home_icons/eye_on.png" 
                    : "assets/home_icons/eye_off.png",
                key: ValueKey(isVisible),
                width: 24,
                height: 24,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}