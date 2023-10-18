import 'package:flutter/material.dart';
import 'package:flutter_blog/ui/pages/post/list_page/post_list_view_model.dart';
import 'package:flutter_blog/ui/pages/post/list_page/wiegets/post_list_body.dart';
import 'package:flutter_blog/ui/widgets/custom_navigator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class PostListPage extends ConsumerWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final refreshKey = GlobalKey<RefreshIndicatorState>();

  PostListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      key: scaffoldKey,
      drawer: CustomNavigation(scaffoldKey),
      appBar: AppBar(
        title: const Text("Blog"),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        strokeWidth: 3.0,
        backgroundColor: Colors.purple,
        color: Colors.grey,
        onRefresh: () async {
          Logger().d("리플레시됨");
          // 리플래시 될 때 provider를 호출해서 추가되는 게시글 리빌드 되게 함
          ref.read(postListProvider.notifier).notifyInit();
        },
        child: PostListBody(),
      ),
    );
  }
}
