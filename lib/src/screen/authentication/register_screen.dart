import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';

import '../custom_widgets.dart';
import '../../constant/_index.dart' show ScreenConfigs;

class RegisterScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final List<String> roleOptions = ["Sinh viên", "Giảng viên"];

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Assets.hustLogo,
                    const SizedBox(height: 30),
                    const SizedBox(height: ScreenConfigs.formFieldSpacing),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: createFormBuilderTextField(
                                  name: "Họ",
                                  labelText: "Họ",
                                  validator: FormBuilderValidators.required())),
                          const SizedBox(width: ScreenConfigs.formFieldSpacing),
                          Expanded(
                              child: createFormBuilderTextField(
                                  name: "Tên",
                                  labelText: "Tên",
                                  validator: FormBuilderValidators.required())),
                        ]),
                    const SizedBox(height: ScreenConfigs.formFieldSpacing),
                    createFormBuilderTextField(
                      name: "email",
                      labelText: "Email",
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                        (value) {
                          if (!value!.contains("hust.edu.vn")) {
                            return "must hust email";
                          }
                          return null;
                        }
                      ]),
                    ),
                    const SizedBox(height: ScreenConfigs.formFieldSpacing),
                    createFormBuilderTextField(
                      name: "password",
                      labelText: "Mật khẩu",
                      obscureText: true,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.password(minLength: 6),
                      ]),
                    ),
                    const SizedBox(height: ScreenConfigs.formFieldSpacing),
                    createFormBuilderDropdown(
                      name: "role",
                      labelText: "Vai trò",
                      validator: FormBuilderValidators.required(),
                      items: roleOptions
                          .map((role) => DropdownMenuItem(
                                value: role,
                                child: Text(role),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: ScreenConfigs.formFieldSpacing),
                    createButton(
                      onPressed: () {
                        _formKey.currentState?.validate();
                        debugPrint(
                            _formKey.currentState?.instantValue.toString());
                      },
                      child: const Text("Đăng ký"),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Đã có tài khoản?"),
                        createUnderlineTextButton(
                          onPressed: () {
                            context.replace('/login');
                          },
                          text: "Đăng nhập.",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Assets.oneLoveOneFuture,
          ],
        ),
      ),
    );
  }
}
