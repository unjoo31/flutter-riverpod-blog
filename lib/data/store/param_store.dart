import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 창고 데이터
class RequestParam {
  int? postDetailId;
  //int? commentId;

  RequestParam({this.postDetailId});
}

// 2. 창고 (비지니스 로직)
class ParamStore extends RequestParam {
  final mContext = navigatorKey.currentContext;
  // // id 추가
  // void addPostDetailID(int postId) {
  //   this.postDetailId = postId;
  // }
  //
  // // 한번 사용하고 초기화
  // void reset() {
  //   postDetailId = null;
  //   //commentId = null;
  // }
}

// 3. 창고 관리자
final paramProvider = Provider<ParamStore>((ref) {
  return ParamStore();
});
