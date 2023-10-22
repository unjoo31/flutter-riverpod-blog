import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/data/model/post.dart';
import 'package:flutter_blog/ui/pages/post/update_page/post_update_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../list_page/post_list_view_model.dart';

class PostDetailButtons extends ConsumerWidget {
  final Post post;
  const PostDetailButtons(this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () async {
            await ref.read(postListProvider.notifier).notifyRemove(post.id);
          },
          icon: const Icon(CupertinoIcons.delete),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => PostUpdatePage(post)));
          },
          icon: const Icon(CupertinoIcons.pen),
        ),
      ],
    );
  }
}
