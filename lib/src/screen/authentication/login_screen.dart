import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../custom_widgets.dart';
import '../../constant/_index.dart' show ScreenConfigs;
import '../../constant/_index.dart' as constant;
import '../../provider/_index.dart' as provider;

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();

    final authProvider =
        Provider.of<provider.AuthProvider>(context, listen: true);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FormBuilder(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Assets.hustLogo,
                    const SizedBox(height: 30),
                    createFormBuilderTextField(
                      name: "email",
                      initialValue: "hoten@hust.edu.vn",
                      labelText: "Email",
                      // validator: FormBuilderValidators.email(),
                    ),
                    const SizedBox(height: ScreenConfigs.formFieldSpacing),
                    createFormBuilderTextField(
                      name: "password",
                      initialValue: "123456",
                      labelText: "Mật khẩu",
                      obscureText: true,
                      // validator: FormBuilderValidators.compose([
                      //   FormBuilderValidators.required(),
                      //   FormBuilderValidators.password(minLength: 6),
                      // ]),
                    ),
                    const SizedBox(height: ScreenConfigs.formFieldSpacing),
                    createButton(
                      onPressed: () async => {
                        formKey.currentState?.saveAndValidate(),
                        if (await authProvider
                            .login(formKey.currentState?.value))
                          {
                            if (context.mounted)
                              {
                                // ignore: use_build_context_synchronously
                                context.go(constant.RoutePath.home.absolute)
                              }
                          }
                      },
                      child: const Text("Đăng nhập"),
                    ),
                    Text(authProvider.errorMessage ?? ' '),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Chưa có tài khoản?"),
                        createUnderlineTextButton(
                          onPressed: () => context.replace('/register'),
                          text: "Đăng ký.",
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
