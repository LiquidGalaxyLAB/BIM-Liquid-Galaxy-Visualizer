import 'package:bim_visualizer_flutter/data/dataproviders/node_api_provider.dart';
import 'package:bim_visualizer_flutter/data/models/meta_model.dart';
import 'package:bim_visualizer_flutter/data/models/bim_model.dart';
import 'package:fast_csv/fast_csv.dart' as _fast_csv;
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'dart:io';

abstract class NodeAPIRepositoryImpl {
  Future<Either<Exception, List<Bim>>> getAll(http.Client client);
  Future<Either<Exception, String>> uploadModel(http.Client client, String name, File file);
  Future<Either<Exception, Bim>> updateMeta(http.Client client, Bim bim, File file);
}

class NodeAPIRepository implements NodeAPIRepositoryImpl {
  final NodeAPIProvider nodeAPI = NodeAPIProvider();

  @override
  Future<Either<Exception, List<Bim>>> getAll(http.Client client) async {
    try {
      List<dynamic> jsonList = await nodeAPI.getAll(client);
      List<Bim> data = jsonList.map((item) => Bim.fromJson(item)).toList();
      return Right(data);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, String>> uploadModel(http.Client client, String name, File file) async {
    try {
      Map<String, dynamic> response = await nodeAPI.uploadModel(client, name, file);
      return Right(response['key']);
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, Bim>> updateMeta(http.Client client, Bim bim, File file) async {
    try {
      final csvString = await file.readAsString();
      final data = _fast_csv.parse(csvString);
      final keys = data.first;

      final list = data.skip(1).map((e) => Map.fromIterables(keys, e)).toList();
      List<MetaModel> meta = list.map((item) => MetaModel.fromJson(item)).toList();

      final body = bim.toJson();
      body['meta'] = meta.map((e) => e.toJson()).toList();

      Map<String, dynamic> result = await nodeAPI.updateMeta(client, body);
      return Right(Bim.fromJson(result));
    } on Exception catch (err) {
      return Left(err);
    }
  }
}