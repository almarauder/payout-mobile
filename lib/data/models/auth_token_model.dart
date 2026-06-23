class AuthTokenModel {
  final String access;
  final String refresh;

  AuthTokenModel({
    required this.access,
    required this.refresh,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    final accessToken = json['accessToken'];
    
    final refreshToken = json['refreshToken'] ?? json['refresh_token'] ?? '';
    if (accessToken == null) {
      throw Exception('Ошибка: в ответе нет accessToken. Ответ сервера: $json');
    }

    return AuthTokenModel(
      access: accessToken.toString(),
      refresh: refreshToken.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access': access,
      'refresh': refresh,
    };
  }
}