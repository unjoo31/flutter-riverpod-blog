import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 창고 데이터
class PostDetailModel {
  Post post;

  PostDetailModel(this.post);
}

// 창고
class PostDetailViewModel extends StateNotifier<PostDetailModel?> {
  PostDetailViewModel(super._state, this.ref);
  Ref ref;

  // state값 갱신이 목적
  void init(Post post) {
    state = PostDetailModel(post);
  }
}

// 창고 관리자
final postDetailProvider =
    StateNotifierProvider<PostDetailViewModel, PostDetailModel?>((ref) {
  return PostDetailViewModel(null, ref);
});
