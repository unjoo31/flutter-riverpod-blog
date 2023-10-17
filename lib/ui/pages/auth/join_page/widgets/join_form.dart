import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';
import 'package:flutter_blog/_core/utils/validator_util.dart';
import 'package:flutter_blog/data/dto/user_request.dart';
import 'package:flutter_blog/data/provider/session_provider.dart';
import 'package:flutter_blog/ui/widgets/custom_auth_text_form_field.dart';
import 'package:flutter_blog/ui/widgets/custom_elavated_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JoinForm extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  // 사용자가 입력한 값 받기
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  JoinForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext contextm, WidgetRef ref) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomAuthTextFormField(
            text: "Username",
            obscureText: false,
            funValidator: validateUsername(),
            controller: _username,
          ),
          const SizedBox(height: mediumGap),
          CustomAuthTextFormField(
            text: "Email",
            obscureText: false,
            funValidator: validateEmail(),
            controller: _email,
          ),
          const SizedBox(height: mediumGap),
          CustomAuthTextFormField(
            text: "Password",
            obscureText: true,
            funValidator: validatePassword(),
            controller: _password,
          ),
          const SizedBox(height: largeGap),
          CustomElevatedButton(
              text: "회원가입",
              funPageRoute: () {
                // 유효성 검사
                if (_formKey.currentState!.validate()) {
                  JoinReqDTO joinReqDTO = JoinReqDTO(
                    username: _username.text,
                    password: _password.text,
                    email: _email.text,
                  );
                  // 유효성 검사를 통과하면 provider를 호출함
                  ref.read(sessionProvider).join(joinReqDTO);
                }
              }),
        ],
      ),
    );
  }
}
