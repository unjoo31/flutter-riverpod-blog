import 'package:dio/dio.dart';
import 'package:flutter_blog/_core/constants/http.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:logger/logger.dart';

void main() async {
  await fetch();
}

Future<void> fetch() async {
  Response<dynamic> response = await dio.get("/post");

  Logger().d(response);
  Logger().d(response.data);

  ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
  Logger().d("fetchBookList : ${responseDTO.code}");
}
