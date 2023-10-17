import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/model/user.dart';

import '../dto/user_request.dart';

// v - p - r
// 통신과 파싱만 함(비지니스 로직 안함)
class UserRepository {
  Future<ResponseDTO> fetchJoin(JoinReqDTO requestDTO) async {
    // dio를 사용할때는 꼭 try-catch사용하기
    try {
      final response = await dio.post("/join", data: requestDTO.toJson());
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      responseDTO.data = User.fromJson(responseDTO.data);
      return responseDTO;
    } catch (e) {
      // 200이 아니면 catch로 감
      return ResponseDTO(-1, "중복되는 유저명입니다", null);
    }
  }

  Future<ResponseDTO> fetchLogin(LoginReqDTO requestDTO) async {
    // dio를 사용할때는 꼭 try-catch사용하기
    try {
      // 토큰은 response의 헤더에 있음
      final response = await dio.post("/login", data: requestDTO.toJson());
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      // 유저에 값을 저장함
      responseDTO.data = User.fromJson(responseDTO.data);
      // 토큰 옮겨주기
      final jwt =
          response.headers["Authorization"]; // 원래 final -> List<String> 타입임
      if (jwt != null) {
        responseDTO.token = jwt.first; // jwt.first : jwt의 [0]번지의 값을 가져옴
      }
      return responseDTO;
    } catch (e) {
      // 200이 아니면 catch로 감
      return ResponseDTO(-1, "유저네임 혹은 비밀번호가 틀렸습니다.", null);
    }
  }
}
