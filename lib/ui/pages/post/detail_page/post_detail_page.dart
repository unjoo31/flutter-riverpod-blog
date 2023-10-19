import 'package:flutter/material.dart';
import 'package:flutter_blog/ui/pages/post/detail_page/widgets/post_detail_body.dart';

import '../../../../data/model/post.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;
  const PostDetailPage(this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PostDetailBody(post),
    );
  }
}
