import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/post_detail_view_model.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_buttons.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_content.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_profile.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_title.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDetailBody extends ConsumerWidget {
  const PostDetailBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 창고에 접근
    // TODO 3 : read, watch 여부 체크
    // PostDetailModel? pdm = ref.read(postDetailProvider); // 상태에 접근
    // PostDetailModel? pdm2 = ref.watch(postDetailProvider); // 상태에 접근
    // ref.watch(postDetailProvider); // 창고에 접근

    PostDetailModel? model = ref.watch(postDetailProvider);
    if (model == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      Post post = model.post;
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // PostDetailTitle("${post.title}"),
            PostDetailTitle("${post.title}"),
            const SizedBox(height: largeGap),
            PostDetailProfile(),
            PostDetailButtons(post),
            const Divider(),
            const SizedBox(height: largeGap),
            PostDetailContent("${post.content}"),
          ],
        ),
      );
    }
    // PostDetailModel? pdm2 = ref.watch(postDetailProvider); // 상태에 접근
    // ref.read(postDetailProvider.notifier);  // 창고에 접근
  }
}
