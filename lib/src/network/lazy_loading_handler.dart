import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'network_handler.dart';

class LazyLoadingModel {
  final int recordID;

  LazyLoadingModel({required this.recordID});
}

class LazyLoadingHandler<T extends LazyLoadingModel> extends NetworkHandler {
  List<T> get listModel => []; // OVERRIDE!!!
  int get getLMLength => listModel.length;

  void refreshOnList() => debugPrint("OVERRIDE!!!"); // OVERRIDE!!!
  void updateOnList() => debugPrint("OVERRIDE!!!"); // OVERRIDE!!!

  void insertToList(T model) {
    int index = lowerBound(listModel, model,
        compare: (model1, model2) => model2.recordID - model1.recordID);

    if (index < listModel.length &&
        listModel[index].recordID == model.recordID) {
      listModel[index] = model;
    } else {
      listModel.insert(index, model);
    }
  }
}
