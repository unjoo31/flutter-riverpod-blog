import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/data/dto/post_request.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:logger/logger.dart';

// V -> P(전역프로바이더, 뷰모델) -> R
class PostRepository {
  Future<ResponseDTO> fetchPostList(String jwt) async {
    try {
      // 1. 통신
      final response = await dio.get("/post",
          options: Options(headers: {"Authorization": "${jwt}"}));

      // 2. ResponseDTO 파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      Logger().d("fetchPostList 실행됨 : ${response.data.toString()}");
      Logger().d("fetchPostList : ${responseDTO.data}");
      // 3. ResponseDTO의 data 파싱
      List<dynamic> mapList = responseDTO.data as List<dynamic>;
      List<Post> postList = mapList.map((e) => Post.fromJson(e)).toList();

      // 4. 파싱된 데이터를 다시 공통 DTO로 덮어씌우기
      responseDTO.data = postList;

      return responseDTO;
    } catch (e) {
      return ResponseDTO(-1, "게시글 목록 불러오기 실패", null);
    }
  }

  // deletePost, updetePost, savePost
  // fetchPost, fetchPostList
  Future<ResponseDTO> savePost(String jwt, PostSaveReqDTO dto) async {
    try {
      // 1. 통신
      final response = await dio.post("/post",
          data: dto.toJson(),
          options: Options(headers: {"Authorization": "${jwt}"}));

      Logger().d(response.data);

      // 2. ResponseDTO 파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      Logger().d(responseDTO.data);

      // 3. ResponseDTO의 data 파싱
      Post post = Post.fromJson(responseDTO.data);

      // 4. 파싱된 데이터를 다시 공통 DTO로 덮어씌우기
      responseDTO.data = post;

      return responseDTO;
    } catch (e) {
      return ResponseDTO(-1, "게시글 작성 실패", null);
    }
  }

  Future<ResponseDTO> fetchPost(String jwt, int id) async {
    try {
      // 통신
      Response response = await dio.get("/post/$id",
          options: Options(headers: {"Authorization": "$jwt"}));

      // 응답 받은 데이터 파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      responseDTO.data = Post.fromJson(responseDTO.data);

      return responseDTO;
    } catch (e) {
      return ResponseDTO(-1, "게시글 한건 불러오기 실패", null);
    }
  }

  Future<ResponseDTO> deletePost(String jwt, int id) async {
    try {
      // 통신
      Response response = await dio.delete("/post/$id",
          options: Options(headers: {"Authorization": "$jwt"}));

      // 응답 받은 데이터 파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      responseDTO.data = Post.fromJson(responseDTO.data);
      Logger().d(responseDTO.code);
      return responseDTO;
    } catch (e) {
      Logger().d("통신 실패");
      return ResponseDTO(-1, "게시글 삭제 실패", null);
    }
  }

  Future<ResponseDTO> updatePost(
      String jwt, int id, PostUpdateReqDTO reqDTO) async {
    PostUpdateReqDTO requestDTO =
        PostUpdateReqDTO(title: reqDTO.title, content: reqDTO.content);
    try {
      // 통신
      Response response = await dio.put(
        "/post/$id",
        options: Options(headers: {"Authorization": "$jwt"}),
        data: requestDTO.toJson(),
      );

      // 응답 받은 데이터 파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      responseDTO.data = Post.fromJson(responseDTO.data);
      Logger().d(responseDTO.code);
      return responseDTO;
    } catch (e) {
      Logger().d("통신 실패");
      return ResponseDTO(-1, "게시글 수정 실패", null);
    }
  }
}
