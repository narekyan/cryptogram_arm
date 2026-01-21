// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categoryModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      json['index'] as int,
      json['title'] as String,
      json['icon'] as String,
      json['color'] as String,
      (json['items'] as List<dynamic>)
          .map((e) => TextItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      founds: json['founds'] as int? ?? 0,
          hasNew: json['hasNew'] as bool? ?? false,
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'index': instance.index,
      'title': instance.title,
      'icon': instance.icon,
      'color': instance.color,
      'items': instance.items,
      'founds': instance.founds,
          'hasNew': instance.hasNew
    };
