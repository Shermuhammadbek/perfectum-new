import 'dart:developer';
import 'dart:io';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:perfectum_new/presentation/enterance/book_number/booking_bloc/booking_bloc.dart';
import 'package:perfectum_new/presentation/enterance/book_number/screens/payment_screen.dart';
import 'package:perfectum_new/presentation/enterance/book_number/widgets/booking_prosses.dart';
import 'package:perfectum_new/presentation/main_screens/home_screen/screens/offers_section/screens/offer_details_screen.dart';
import 'package:perfectum_new/presentation/main_widgets/app_appbar.dart';

class ContactInformationForm extends StatefulWidget {
  const ContactInformationForm({super.key});

  @override
  State<ContactInformationForm> createState() => _ContactInformationFormState();
}

class _ContactInformationFormState extends State<ContactInformationForm> {
  static const int _activeIndex = 5;
  
  // O'zbekiston operator kodlari
  static const List<String> _validPrefixes = ['90', '91', '93', '94', '95', '97', '98', '99', '33', '88', '50', '20'];
  
  // Email regex pattern
  static final RegExp _emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  static final RegExp _phoneRegex = RegExp(r'^[0-9]+$');

  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  // Validation state
  bool _isPhoneValid = false;
  bool _isEmailValid = false;
  
  String? _phoneError;
  String? _emailError;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController()..addListener(_validatePhone);
    _emailController = TextEditingController()..addListener(_validateEmail);
  }

  void _validatePhone() {
    final phone = _phoneController.text;
    
    setState(() {
      if (phone.isEmpty) {
        _isPhoneValid = false;
        _phoneError = "Номер телефона обязателен";
      } else if (phone.length != 9) {
        _isPhoneValid = false;
        _phoneError = "Номер должен содержать 9 цифр";
      } else if (!_phoneRegex.hasMatch(phone)) {
        _isPhoneValid = false;
        _phoneError = "Только цифры разрешены";
      } else if (!_isValidUzbekPhone(phone)) {
        _isPhoneValid = false;
        _phoneError = "Неверный формат номера";
      } else {
        _isPhoneValid = true;
        _phoneError = null;
      }
    });
  }

  void _validateEmail() {
    final email = _emailController.text;
    
    setState(() {
      if (email.isEmpty) {
        _isEmailValid = false;
        _emailError = "Email обязателен";
      } else if (!_emailRegex.hasMatch(email)) {
        _isEmailValid = false;
        _emailError = "Неверный формат email";
      } else {
        _isEmailValid = true;
        _emailError = null;
      }
    });
  }

  bool _isValidUzbekPhone(String phone) {
    if (phone.length == 9) {
      final prefix = phone.substring(0, 2);
      return _validPrefixes.contains(prefix);
    }
    return false;
  }

  bool get _canSubmit => _isPhoneValid && _isEmailValid;

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required bool isValid,
    required String? error,
    Widget? prefix,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
            border: null
          ),
          child: Row(
            children: [
              if (prefix != null) ...[
                prefix,
                const Gap(4),
              ],
              Expanded(
                child: Padding(
                  padding: prefix != null ? EdgeInsets.only(
                    bottom: Platform.isAndroid ? 0 : 2.5,
                  ) : EdgeInsets.zero,
                  child: TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    maxLength: maxLength,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                    ),
                    decoration: InputDecoration(
                      hintText: hint,
                      border: InputBorder.none,
                      counter: const SizedBox.shrink(),
                      hintStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.black45,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ),
              ),
              if (isValid)
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
              if (error != null)
                const Icon(Icons.error, color: Colors.red, size: 20),
            ],
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Text(
              error,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w400
              ),
            ),
          ),
      ],
    );
  }

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
          const BookingProsses(activeIndex: _activeIndex),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(
                top: 10, 
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                left: 16, 
                right: 16,
              ),
              children: [
                const Text(
                  "Контактная информация",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700
                  ),
                ),
                const Gap(8),
                const Text(
                  "Пожалуйста, введите ваш номер телефона и электронную почту для завершения регистрации.",
                  style: TextStyle(
                    color: Color(0xFF616161),
                    fontSize: 14,
                    fontWeight: FontWeight.w400
                  ),
                ),
                const Gap(24),
                
                // Phone input
                _buildInputField(
                  controller: _phoneController,
                  hint: "",
                  isValid: _isPhoneValid,
                  error: _phoneError,
                  keyboardType: TextInputType.phone,
                  maxLength: 9,
                  prefix: const Padding(
                    padding: EdgeInsets.only(top: 1.4),
                    child: Text(
                      "+998",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF757575),
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ),
                
                const Gap(12),
                
                // Email input
                _buildInputField(
                  controller: _emailController,
                  hint: "Электронная почта",
                  isValid: _isEmailValid,
                  error: _emailError,
                  keyboardType: TextInputType.emailAddress,
                ),
                const Gap(24),
              ],
            ),
          ),
          GestureDetector(
            onTap: _canSubmit ? () {

              log("${_phoneController.text} phone");
              log("${_emailController.text} email");

              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (_) => const PaymentScreen()
                ),
              );

              // context.read<BookingBloc>().add(BookingSetUserPhoneNumber(
              //   contactNumber: _phoneController.text,
              //   contactMail: _emailController.text
              // ));
            } : null,
            child: MyCustomButton(
              label: "Подтвердить",
              color: _canSubmit ? null : const Color(0xffe50101).withAlpha(60),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}