import 'package:flutter/material.dart';

import '../provider/_index.dart' show GlobalProvider;
import '../constant/_index.dart' show Paths;
import '../network/network_handler.dart';

class AssignmentModel {
  final String id, title, description, fileUrl;
  final String deadlineDay, deadlineHour, lecturerID, classID;

  AssignmentModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.lecturerID,
      required this.deadlineDay,
      required this.deadlineHour,
      required this.fileUrl,
      required this.classID});
}

class AssignmentProvider extends NetworkHandler with ChangeNotifier {
  final List<AssignmentModel> assignmentModels = [];

  AssignmentModel _convert$1(dynamic json) => AssignmentModel(
      id: json['id'].toString(),
      title: json['title'] as String,
      description: json['description'] as String,
      lecturerID: json['lecturer_id'].toString(),
      deadlineDay: json['deadline'].substring(0, 10),
      deadlineHour: json['deadline'].substring(11),
      fileUrl: json['file_url'] as String,
      classID: json['class_id'].toString());

  void getAllSurveys$1({required String classID}) async {
    assignmentModels.clear();
    notifyListeners();

    String token;
    if ((token = GlobalProvider.token) != '') {
      final data = <String, String>{"token": token, "class_id": classID};

      networkRequest(
          requestOptions: NetworkHandler.requestOptions.copyWith(
            path: Paths.getAllSurveys,
            data: data,
          ),
          handleResponse: (response) {
            final assignments = response.data['data'] ?? [];

            for (var assignment in assignments) {
              assignmentModels.add(_convert$1(assignment));
            }
          },
          afterHandleResponse: () => notifyListeners());
    }
  }
}
