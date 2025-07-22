class MyApiKeys {
  static const main = "https://mob.perfectum.uz/api/mobile/v1";
  // static const mainBss = "https://mob.perfectum.uz/api/bss/v1";

  //! Guest Access  
  static const availableNumbers = "/msisdns";
  static const offers = "/product-catalog";

  //! Authentication
  static const getToken = "/auth/token";
  static const verifyOtp = "/auth/verify-otp";
  static const sendOtp = "/auth/send-otp";
  static const refreshToken = "/auth/refresh";
  static const logOut = "/auth/logout";
  
  //! Onboarding
  static const basketCreate = "/basket-init";
  static const basketsDiscard = "baskets-discard";
  static const checkSim = "/check-sim";
  static const checkDevice = "/check-device";
  static const basketAddIcc = "/basket-add-icc";
  static const basketAddDevice = "/basket-add-device";
  static const basketCustomerCreate = "/basket-customer-create";
  static const basketContactMedia = "/basket-contact-media";
  static const basketDetail = "/basket/details/";
  static const basketCommit = "/basket-close";

  //! user Accaunt
  static const userBalance = "/monetary-balance";
  static const paymentHistory = "/payment-history";
  static const chargeHistory = "/charge-history";
}