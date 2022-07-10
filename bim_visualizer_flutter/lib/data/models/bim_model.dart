import 'package:equatable/equatable.dart';

class Bim extends Equatable {
  final String? key;
  final String? name;
  final bool? isDemo;
  final String? modelPath;
  final Map<String, dynamic>? meta;

  const Bim({
    this.key,
    this.name,
    this.isDemo,
    this.modelPath,
    this.meta
  });

  factory Bim.fromJson(Map<String, dynamic> json) {
    return Bim(
      key: json['key'],
      name: json['name'],
      isDemo: json['isDemo'],
      modelPath: json['modelPath'],
      meta: json['meta']
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
