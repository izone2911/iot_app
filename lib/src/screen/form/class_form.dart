import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:quanlyhoctap/src/screen/custom_widgets.dart';

import '../../constant/_index.dart';

class ClassForm extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;

  const ClassForm({required this.formKey, super.key});

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: Column(
        children: [
          createFormBuilderTextField(
            name: 'class_id',
            labelText: 'Mã lớp*',
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.maxLength(
                6,
                errorText: 'Mã lớp không được dài quá 6 ký tự',
              ),
            ]),
          ),
          const SizedBox(height: ScreenConfigs.formFieldSpacing),
          createFormBuilderTextField(
            name: 'attached_code',
            labelText: 'Mã lớp kèm',
            validator: (string) {
              if (string == null || string.length <= 6) return null;
              return 'Mã lớp không được dài quá 6 ký tự';
            },
          ),
          const SizedBox(height: ScreenConfigs.formFieldSpacing),
          createFormBuilderTextField(
            name: 'class_name',
            labelText: 'Tên lớp*',
            validator: FormBuilderValidators.required(),
          ),
          const SizedBox(height: ScreenConfigs.formFieldSpacing),
          createFormBuilderDropdown(
            name: 'class_type',
            labelText: 'Loại lớp*',
            validator: FormBuilderValidators.required(),
            items: const [
              DropdownMenuItem(
                value: 'LT',
                child: Text('Lý thuyết'),
              ),
              DropdownMenuItem(
                value: 'BT',
                child: Text('Bài tập'),
              ),
              DropdownMenuItem(
                value: 'LT+BT',
                child: Text('Lý thuyết + Bài tập'),
              ),
            ],
          ),
          const SizedBox(height: ScreenConfigs.formFieldSpacing),
          Row(
            children: [
              Expanded(
                child: createFormBuilderDatePicker(
                  name: 'start_date',
                  labelText: 'Ngày bắt đầu*',
                  validator: FormBuilderValidators.required(),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: createFormBuilderDatePicker(
                  name: 'end_date',
                  labelText: 'Ngày kết thúc*',
                  validator: FormBuilderValidators.required(),
                ),
              ),
            ],
          ),
          const SizedBox(height: ScreenConfigs.formFieldSpacing),
          createFormBuilderTextField(
            name: 'max_student_amount',
            labelText: 'Số lượng sinh viên tối đa*',
            validator: FormBuilderValidators.required(),
          ),
        ],
      ),
    );
  }
}
