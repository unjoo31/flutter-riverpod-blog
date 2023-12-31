import 'package:flutter/material.dart';
import 'package:flutter_blog/data/dto/post_request.dart';
import 'package:flutter_blog/data/dto/response_dto.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/repository/post_repository.dart';
import 'package:flutter_blog/data/store/session_store.dart';
import 'package:flutter_blog/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 창고 데이터
class PostListModel {
  List<Post> posts;
  PostListModel(this.posts);
}

// 2. 창고
class PostListViewModel extends StateNotifier<PostListModel?> {
  PostListViewModel(super._state, this.ref);

  final mContext = navigatorKey.currentContext;
  Ref ref;

  Future<void> notifyInit() async {
    // jwt 가져오기
    SessionStore sessionStore = ref.read(sessionProvider);

    ResponseDTO responseDTO =
        await PostRepository().fetchPostList(sessionStore.jwt!);
    state = PostListModel(responseDTO.data);
  }

  Future<void> notifyAdd(PostSaveReqDTO dto) async {
    SessionStore sessionStore = ref.read(sessionProvider);

    ResponseDTO responseDTO =
        await PostRepository().savePost(sessionStore.jwt!, dto);

    if (responseDTO.code == 1) {
      // 1. 작성된 게시글 데이터 가져오기
      Post newPost = responseDTO.data as Post; // dynamic(Post) -> 다운캐스팅
      // 2. 기존 상태에 데이터 추가 [전개연산자]
      List<Post> newPosts = [newPost, ...state!.posts];
      // 3. 뷰모델(창고) 데이터 갱신이 완료 -> watch 구독자는 rebuild됨.
      state = PostListModel(newPosts);
      // 4. 글쓰기 화면 pop
      Navigator.pop(mContext!);
    } else {
      ScaffoldMessenger.of(mContext!).showSnackBar(
          SnackBar(content: Text("게시물 작성 실패 : ${responseDTO.msg}")));
    }
  }

  Future<void> notifyRemove(int id) async {
    SessionStore sessionStore = ref.read(sessionProvider);
    ResponseDTO responseDTO =
        await PostRepository().deletePost(sessionStore.jwt!, id);

    if (responseDTO.code == 1) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
          SnackBar(content: Text("게시물 삭제 실패 : ${responseDTO.msg}")));
    } else {
      List<Post> posts = state!.posts;
      List<Post> newPosts = posts.where((e) => e.id != id).toList();
      state = PostListModel(newPosts);
      Navigator.pop(mContext!);
    }
  }

  Future<void> notifyUpdate(Post post) async {
    List<Post> posts = state!.posts;
    List<Post> newPosts = posts.map((e) => e.id == post.id ? post : e).toList();
    state = PostListModel(newPosts);
  }
}

// 3. 창고 관리자 (View 빌드되기 직전에 생성됨)
final postListProvider =
    StateNotifierProvider.autoDispose<PostListViewModel, PostListModel?>((ref) {
  return PostListViewModel(null, ref)..notifyInit();
});
