import 'package:flutter/material.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/post_detail_page.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/post_detail_view_model.dart';
import 'package:flutter_blog/ui/pages/post/list_page/post_list_view_model.dart';
import 'package:flutter_blog/ui/pages/post/list_page/wiegets/post_list_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostListBody extends ConsumerWidget {
  const PostListBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PostListModel? model = ref.watch(postListProvider); // state == null
    List<Post> posts = [];

    if (model != null) {
      posts = model.posts;
    }

    return ListView.separated(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            // Detail 창고에 데이터 저장
            // 사용자의 화면변동사항이 있기 때문에 바로 init이 가능하다 (postDetailProvider 창고에 데이터를 저장함)
            ref.read(postDetailProvider.notifier).init(posts[index]);
            Navigator.push(
              // 게시글 상세보기의 경우 id가 필요하기 때문에 라우터 설계가 되지 않기 때문에 화면 이동시에 .push를 사용해서 넘어가야함
              context,
              MaterialPageRoute(
                builder: (_) =>
                    PostDetailPage(), //posts가 컬렉션으로 되어 있어서 그대로 넘기면 사용가능
              ),
            );
          },
          child: PostListItem(posts[index]),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }
}
