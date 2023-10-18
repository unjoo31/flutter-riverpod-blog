import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/_core/constants/move.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/dto/user_request.dart';
import 'package:flutter_blog/data/model/user.dart';
import 'package:flutter_blog/data/repository/user_repository.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 창고 데이터
class SessionUser {
  User? user; // 로그인 여부에 따라서 데이터가 없을 수 있어서 null허용
  String? jwt; // 로그인 여부에 따라서 데이터가 없을 수 있어서 null허용
  bool isLogin; // 최초의 값을 false로 세팅하기
  SessionUser({this.user, this.jwt, this.isLogin = false});
}

// 2. 창고
class SessionStore extends SessionUser {
  // 1. 화면 context에 접근하는 법 (회원가입하면 로그인 페이지로 이동할건데 그떄 context가 없으면 이동할 수 없음)
  final mContext = navigatorKey.currentContext;

  Future<void> join(JoinReqDTO joinReqDTO) async {
    // 1. 통신 코드
    // 성공, 실패 둘다 상관없이 responseDTO를 받는다
    ResponseDTO responseDTO = await UserRepository().fetchJoin(joinReqDTO);

    // 2. 비지니스 로직
    if (responseDTO.code == 1) {
      Navigator.pushNamed(mContext!, Move.loginPage);
    } else {
      ScaffoldMessenger.of(mContext!)
          .showSnackBar(SnackBar(content: Text(responseDTO.msg)));
    }
  }

  Future<void> login(LoginReqDTO loginReqDTO) async {
    // 1. 통신 코드
    // 성공, 실패 둘다 상관없이 responseDTO를 받는다
    ResponseDTO responseDTO = await UserRepository().fetchLogin(loginReqDTO);

    // 2. 비지니스 로직
    if (responseDTO.code == 1) {
      // 1. 세션값 갱신 (로그인 했을 때 계속 사용할 것이기 때문)
      this.user = responseDTO.data as User; // map타입이면 안들어가짐(다운캐스팅해서 넣음)
      this.jwt = responseDTO.token;
      this.isLogin = true;
      // 2. 디바이스에 jwt 저장 (앱을 재 실행 했을 때 자동 로그인) - 컨트롤러에서 jwt를 비교해서 있으면 1을 던져주면 됨
      // await 안붙이면 저장안되고 화면 이동하게 됨
      await secureStorage.write(key: "jwt", value: responseDTO.token);
      // 3. 페이지 이동
      Navigator.pushNamed(mContext!, Move.postListPage);
    } else {
      ScaffoldMessenger.of(mContext!)
          .showSnackBar(SnackBar(content: Text(responseDTO.msg)));
    }
  }

  // jwt는 로그아웃할 때 서버측으로 요청할 필요 없음
  Future<void> logout() async {
    this.jwt = null; // jwt 날리기
    this.isLogin = false; // 로그인 상태 변경
    this.user = null; // user 날리기

    // io가 발생하기 때문에 await가 필요함
    await secureStorage.delete(key: "jwt");

    // context 들고와서 화면 접근하기
    Navigator.pushNamed(mContext!, Move.loginPage); // 화면 스택 쌓임
  }
}

// 3. 창고 관리자
final sessionProvider = Provider<SessionStore>((ref) {
  return SessionStore();
});
