import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/_core/utils/validator_util.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_blog/ui/widgets/custom_text_area.dart';
import 'package:flutter_blog/ui/widgets/custom_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../data/dto/post_request.dart';
import '../../../../../data/model/post.dart';
import '../../detail_page/post_detail_view_model.dart';

class PostUpdateForm extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _content = TextEditingController();

  final Post post;
  PostUpdateForm(this.post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          CustomTextFormField(
            controller: _title,
            initValue: "${post.title}",
            hint: "Title",
            funValidator: validateTitle(),
          ),
          const SizedBox(height: smallGap),
          CustomTextArea(
            controller: _content,
            initValue: "${post.content}",
            hint: "Content",
            funValidator: validateContent(),
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
            text: "글 수정하기",
            funPageRoute: () async {
              if (_formKey.currentState!.validate()) {
                PostUpdateReqDTO reqDTO = PostUpdateReqDTO(
                    title: _title.text, content: _content.text);
                await ref
                    .read(postDetailProvider.notifier)
                    .notifyUpdate(post.id, reqDTO);
              }
            },
          ),
        ],
      ),
    );
  }
}
