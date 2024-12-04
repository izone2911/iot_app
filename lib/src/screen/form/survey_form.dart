import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:quanlyhoctap/src/screen/custom_widgets.dart';

import '../../constant/_index.dart';

class SurveyForm extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;

  const SurveyForm({required this.formKey, super.key});

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: Column(
        children: [
          createFormBuilderTextField(
            name: 'title',
            labelText: 'Tiêu đề*',
            validator: FormBuilderValidators.required(),
          ),
          const SizedBox(height: ScreenConfigs.formFieldSpacing),
          createFormBuilderTextField(
            name: 'description',
            labelText: 'Mô tả',
            minLine: 3,
            maxLine: 10,
          ),
          const SizedBox(height: ScreenConfigs.formFieldSpacing),
          createFormBuilderDateTimePicker(
            name: 'deadline',
            labelText: 'Thời điểm kết thúc*',
            validator: FormBuilderValidators.required(),
          ),
          const SizedBox(height: ScreenConfigs.formFieldSpacing),
          createFormBuilderFilePicker(
            name: 'file',
            labelText: 'Thêm file',
            maxFiles: 1,
          ),
          createButton(
            onPressed: () {
              formKey.currentState!.validate();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
