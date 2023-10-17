class JoinReqDTO {
  final String username;
  final String password;
  final String email;

  JoinReqDTO(
      {required this.username, required this.password, required this.email});

  // 응답받을 떄 말고 요청할떄 사용하기 떄문에 toJson
  Map<String, dynamic> toJson() =>
      {"username": username, "password": password, "email": email};
}

class LoginReqDTO {
  final String username;
  final String password;
  LoginReqDTO({required this.username, required this.password});
  Map<String, dynamic> toJson() => {"username": username, "password": password};
}
