class MyIdToken {
  final String scope;
  final int expiresIn;
  final String tokenType;
  final String accessToken;
  final String refreshToken;

  MyIdToken({
    required this.scope, required this.expiresIn, required this.tokenType, 
    required this.accessToken, required this.refreshToken
  });

  factory MyIdToken.toObject(Map<String, dynamic> map) {
    return MyIdToken(
      scope: map['scope'] as String,
      expiresIn: map['expires_in'] as int,
      tokenType: map['token_type'] as String,
      accessToken: map['access_token'] as String,
      refreshToken: map['refresh_token'] as String,
    );
  }
}