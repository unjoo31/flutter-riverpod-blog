import 'package:flutter/material.dart';
import 'package:flutter_blog/ui/pages/post/update_page/widgets/post_update_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../data/model/post.dart';

class PostUpdateBody extends ConsumerWidget {
  final Post post;
  const PostUpdateBody(this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PostUpdateForm(post),
    );
  }
}
