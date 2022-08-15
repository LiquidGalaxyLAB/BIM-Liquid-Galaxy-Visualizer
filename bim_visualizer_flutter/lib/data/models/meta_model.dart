import 'package:equatable/equatable.dart';

class MetaModel extends Equatable {
  final dynamic elementID;
  final String? family;
  final String? type;
  final dynamic length;
  final String? baseLevel;
  //final dynamic? baseOffset;
  final String? topLevel;
  final dynamic topOffset;

  const MetaModel({
    this.elementID,
    this.family,
    this.type,
    this.length,
    this.baseLevel,
    //this.baseOffset,
    this.topLevel,
    this.topOffset,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      elementID: json['elementID'] as dynamic,
      family: json['family'] as String?,
      type: json['type'] as String?,
      length: json['length'] as dynamic,
      baseLevel: json['baseLevel'] as String?,
      //baseOffset: json['baseOffset'] as int,
      topLevel: json['topLevel'] as String?,
      topOffset: json['topOffset'] as dynamic
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'elementID': elementID,
      'family': family,
      'type': type,
      'length': length,
      'baseLevel': baseLevel,
      //'baseOffset': baseOffset,
      'topLevel': topLevel,
      'topOffset': topOffset,
    };
  }

  @override
  List<Object?> get props => [elementID, family, type, length, baseLevel, topLevel, topOffset];
}