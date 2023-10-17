import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/provider/session_provider.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/model/post.dart';

// 1. 창고 데이터
class PostListModel {
  List<Post> posts;
  PostListModel(this.posts);
}

// 2. 창고
class PostListViewModel extends StateNotifier<PostListModel?> {
  PostListViewModel(super._state, this.ref); // _state는 null을 관리한다

  Ref ref;

  // viewmodel의 경우 꼭 notify를 붙여주기!
  Future<void> notifyInit() async {
    // jwt 가져오기
    SessoinUser sessoinUser = ref.read(sessionProvider);
    ResponseDTO responseDTO =
        await PostRepository().fetchPostList(sessoinUser.jwt!);
    state = PostListModel(responseDTO.data);
  }
}

// 3. 창고 관리자 (view 빌드되기 직전에 생성됨)
final postListProvider =
    StateNotifierProvider.autoDispose<PostListViewModel, PostListModel?>((ref) {
  return PostListViewModel(null, ref)..notifyInit();
});
