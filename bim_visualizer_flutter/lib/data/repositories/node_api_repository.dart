import 'package:bim_visualizer_flutter/data/dataproviders/node_api_provider.dart';
import 'package:bim_visualizer_flutter/data/models/bim_model.dart';
import 'package:dartz/dartz.dart';

abstract class NodeAPIRepositoryImpl {
  Future<Either<Exception, List<Bim>>> getAll();
}

class NodeAPIRepository implements NodeAPIRepositoryImpl {
  final NodeAPIProvider nodeAPI = NodeAPIProvider();

  @override
  Future<Either<Exception, List<Bim>>> getAll() async {
    try {
      List<dynamic> jsonList = await nodeAPI.getAll();
      List<Bim> data = jsonList.map((item) => Bim.fromJson(item)).toList();
      return Right(data);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}