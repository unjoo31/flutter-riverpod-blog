import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/data/dto/post_request.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:logger/logger.dart';

void main() async {
  await deletePost_test();
}

Future<void> fetch() async {
  Response<dynamic> response = await dio.get("/post");

  Logger().d(response);
  Logger().d(response.data);

  ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
  Logger().d("fetchBookList : ${responseDTO.code}");
}

Future<void> deletePost_test() async {
// JWT 토큰은 만료될 수 있기 때문에, PostMan으로 요청한 뒤 Authorization 응답 헤더값을 사용하세요.
  String jwt =
      'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJjb3PthqDtgbAiLCJpZCI6MSwiZXh wIjoxNjg5ODgxMDU2fQ.Vd0SepViCFoVaEv_Zv73AI1M2Z87t0TZSO--FYYUJqqffWS4rgti_2ebcnJtmhCdJQLdaR BLhoqvbuVDqu8iZA';
  int id = 1;
  try {
// 통신
    Response response = await dio.delete("/post/$id",
        options: Options(headers: {"Authorization": "$jwt"}));
// 응답 받은 데이터 파싱
    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
    Logger().d(responseDTO.code);
    Logger().d(responseDTO.msg);
  } catch (e) {
    Logger().d("통신 실패");
  }
}

Future<void> updatePost_test() async {
// JWT 토큰은 만료될 수 있기 때문에, PostMan으로 요청한 뒤 Authorization 응답 헤더값을 사용하세요.
  String jwt =
      'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJjb3PthqDtgbAiLCJpZCI6MSwiZXh wIjoxNjg5ODgwNzEzfQ.wRMLsbl1lBjFjNmUPDo5MWtAZ4ukzVDQy1B5A-qhwk54vSycgy3EhzvXgb4WtZImxV_Yc wddLDS5iFPBZuk2iA'; // 삭제하기 테스트시에 1번을 삭제했기 때문에 2번 내용을 수정해줍니다.
  int id = 2;
  PostUpdateReqDTO requestDTO =
      PostUpdateReqDTO(title: "수정제목", content: "수정내용");
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
    Logger().d(responseDTO.msg);
  } catch (e) {
    Logger().d("통신 실패");
  }
}
