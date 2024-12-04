import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/_index.dart' show AssignmentProvider, AssignmentModel;
import '../../constant/_index.dart' show Assets;
import '../../network/network_handler.dart';

// ignore: must_be_immutable
class AssignmentScreen extends StatelessWidget {
  AssignmentScreen({super.key});

  AssignmentProvider? assignmentProvider;

  @override
  Widget build(BuildContext context) {
    assignmentProvider ??= Provider.of(context, listen: false);
    final RequestCode isError = context.select(
      (AssignmentProvider p) => p.requestCode,
    );
    final int assignmentModelsLength = context.select(
      (AssignmentProvider p) => p.assignmentModels.length,
    );
    List<AssignmentModel> assignmentModels;
    String deadlineDay;

    return Scaffold(
        bottomNavigationBar: ElevatedButton(
            onPressed: () {
              assignmentProvider?.getAllSurveys$1(classID: "120001");
            },
            child: const Text('Request')),
        body: (isError == RequestCode.notConnect ||
                isError == RequestCode.timeout)
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                        isError == RequestCode.notConnect
                            ? Icons.wifi_tethering_error
                            : Icons.error_outline,
                        color: Colors.red),
                    Text(
                        isError == RequestCode.notConnect
                            ? "Mạng! Ai đã giấu nó đi?"
                            : "Lỗi! Tôi đã giấu nó đi!",
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold))
                  ],
                ),
              )
            : ListView.builder(
                itemCount: assignmentModelsLength,
                itemBuilder: (BuildContext context, int index) {
                  assignmentModels = assignmentProvider!.assignmentModels;
                  deadlineDay = assignmentModels[index].deadlineDay;

                  if (index != 0 &&
                      assignmentModels[index - 1].deadlineDay == deadlineDay) {
                    deadlineDay = '';
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      deadlineDay == ''
                          ? const SizedBox()
                          : _deadlineBox(deadlineDay),
                      _assignmentBox(context, assignmentModels[index]),
                    ],
                  );
                }));
  }

  static Container _deadlineBox(String dateline) {
    return Container(
        margin: const EdgeInsets.only(top: 12, bottom: 4, left: 16, right: 16),
        child: Text(dateline,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)));
  }

  static Container _assignmentBox(
    BuildContext context,
    AssignmentModel assignmentModel,
  ) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        child: ListTile(
            minTileHeight: 0,
            minLeadingWidth: 0,
            minVerticalPadding: 0,
            horizontalTitleGap: 10,
            titleAlignment: ListTileTitleAlignment.top,
            //
            contentPadding: const EdgeInsets.all(13),
            shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.black12),
                borderRadius: BorderRadius.all(Radius.circular(8))),
            //
            leading: const Column(children: [
              SizedBox(height: 4),
              ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child: Image(height: 30, width: 30, image: Assets.meme))
            ]),
            title: Text(assignmentModel.title,
                style: const TextStyle(fontSize: 15, height: 1.3),
                overflow: TextOverflow.ellipsis,
                maxLines: 1),
            subtitle:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 3),
              Text('Class: ${assignmentModel.classID}',
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1),
              Text(assignmentModel.description,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1),
              const SizedBox(height: 3)
            ])));
  }
}
