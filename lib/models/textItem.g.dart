// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'textItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextItem _$TextItemFromJson(Map<String, dynamic> json) => TextItem(
      json['text'] as String,
      json['author'] as String,
      category: json['category'] as int? ?? 0,
      id: json['id'] as String? ?? '',
      link: json['link'] as String? ?? "",
    );

Map<String, dynamic> _$TextItemToJson(TextItem instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'author': instance.author,
      'link': instance.link,
      'category': instance.category,
    };
