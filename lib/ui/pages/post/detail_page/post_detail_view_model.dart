import 'package:flutter/material.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/data/store/param_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../../data/dto/post_request.dart';
import '../../../../data/dto/response_dto.dart';
import '../../../../data/repository/post_repository.dart';
import '../../../../data/store/session_store.dart';
import '../../../../main.dart';
import '../list_page/post_list_view_model.dart';

// 창고 데이터
class PostDetailModel {
  Post post;

  PostDetailModel(this.post);
}

// 창고
class PostDetailViewModel extends StateNotifier<PostDetailModel?> {
  final mContext = navigatorKey.currentContext;
  PostDetailViewModel(super._state, this.ref);
  Ref ref;

  Future<void> notifyInit(int id) async {
    Logger().d("notifyInit");
    SessionUser sessionUser = ref.read(sessionProvider);
    ResponseDTO responseDTO =
        await PostRepository().fetchPost(sessionUser.jwt!, id);
    state = PostDetailModel(responseDTO.data);
  }

  Future<void> notifyUpdate(int postId, PostUpdateReqDTO reqDTO) async {
    Logger().d("notifyUpdate");
    SessionUser sessionUser = ref.read(sessionProvider);
    ResponseDTO responseDTO =
        await PostRepository().updatePost(sessionUser.jwt!, postId, reqDTO);
    if (responseDTO.code != 1) {
      ScaffoldMessenger.of(mContext!).showSnackBar(
          SnackBar(content: Text("게시물 수정 실패 : ${responseDTO.msg}")));
    } else {
      await ref.read(postListProvider.notifier).notifyUpdate(responseDTO.data);
      state = PostDetailModel(responseDTO.data);
      Navigator.pop(mContext!);
    }
  }
}

// 창고 관리자
// 창고 관리자한테 데이터를 전달하는 방법
// family : 직접 파라미터의 값을 전달 받을 수 있음 (int : 타입필요)(postId : 값)
// final postDetailProvider =
//     StateNotifierProvider.family<PostDetailViewModel, PostDetailModel?, int>(
//         (ref, postId) {
//   return PostDetailViewModel(null, ref)..notifyInit(postId);
// });

// Provider의 결합
final postDetailProvider =
    StateNotifierProvider.autoDispose<PostDetailViewModel, PostDetailModel?>(
        (ref) {
  int postId = ref.read(paramProvider).postDetailId!;

  return PostDetailViewModel(null, ref)..notifyInit(postId);
});
