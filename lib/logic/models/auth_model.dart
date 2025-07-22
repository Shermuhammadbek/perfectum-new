enum UserType {guest, user,}

class AuthResponse {
  final String accessToken;
  final int expiresIn;
  final String refreshToken;
  final int sessionId;
  final UserType type;

  AuthResponse({
    required this.accessToken,
    required this.expiresIn,
    required this.refreshToken,
    required this.sessionId,
    required this.type,
  });

  // Convert from JSON
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'],
      expiresIn: json['expires_in'],
      refreshToken: json['refresh_token'],
      sessionId: json['session_id'],
      type: _userTypeFromString(json['type']),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'expires_in': expiresIn,
      'refresh_token': refreshToken,
      'session_id': sessionId,
      'type': _userTypeToString(type),
    };
  }


  static UserType _userTypeFromString(String? type) {
    switch (type) {
      case 'guest':
        return UserType.guest;
      default:
        return UserType.user;
    }
  }


  static String _userTypeToString(UserType type) {
    switch (type) {
      case UserType.guest:
        return 'guest';
      default:
        return 'user';
    }
  }
}


class OtpResponse {
  final OtpResponseData data;

  OtpResponse({required this.data});

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      data: OtpResponseData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
    'data': data.toJson(),
  };
}

class OtpResponseData {
  final bool isSuccessful;
  final String phoneNumber;

  OtpResponseData({
    required this.isSuccessful,
    required this.phoneNumber,
  });

  factory OtpResponseData.fromJson(Map<String, dynamic> json) {
    return OtpResponseData(
      isSuccessful: json['success'] ?? false,
      phoneNumber: json['msisdn']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'success': isSuccessful,
    'msisdn': phoneNumber,
  };
}