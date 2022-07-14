import 'package:bim_visualizer_flutter/data/models/meta_model.dart';
import 'package:equatable/equatable.dart';

class Bim extends Equatable {
  final String? key;
  final String? name;
  final bool? isDemo;
  final String? modelPath;
  final List<MetaModel>? meta;

  const Bim({
    this.key,
    this.name,
    this.isDemo,
    this.modelPath,
    this.meta
  });

  factory Bim.fromJson(Map<String, dynamic> json) {
    return Bim(
      key: json['key'] as String?,
      name: json['name'] as String?,
      isDemo: json['isDemo'] as bool?,
      modelPath: json['modelPath'] as String?,
      meta: (json['meta'] as List<dynamic>).map((item) => MetaModel.fromJson(item)).toList()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'name': name,
      'isDemo': isDemo,
      'modelPath': modelPath,
      'meta': meta
    };
  }

  @override
  List<Object?> get props => [key, name, isDemo, modelPath, meta];
}
