import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';

import '../model/post.dart';

// v - p - r
// 통신과 파싱만 함(비지니스 로직 안함)
class PostRepository {
  Future<ResponseDTO> fetchPostList(String jwt) async {
    // provider에는 ref를 접근할 수 있기 때문에 jwt를 전달받아서 사용하기
    // dio를 사용할때는 꼭 try-catch사용하기
    try {
      // 1. 통신
      // 헤더에 토큰이 있기 떄문에 헤더를 만들어야함
      final response = await dio.get("/post",
          options: Options(headers: {"Authorization": "${jwt}"}));

      // 2. ResponseDTO 파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);

      // 3. ResponseDTO의 data 파싱
      List<dynamic> mapList = responseDTO.data as List<dynamic>;
      List<Post> postList = mapList.map((e) => Post.fromJson(e)).toList();

      // 4. 파싱된 데이터를 다시 공통 DTO로 덮어 씌우기
      responseDTO.data = postList;

      return responseDTO;
    } catch (e) {
      // 200이 아니면 catch로 감
      return ResponseDTO(-1, "중복되는 유저명입니다", null);
    }
  }
}
