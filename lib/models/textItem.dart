import 'package:json_annotation/json_annotation.dart';

part 'textItem.g.dart';

@JsonSerializable()
class TextItem {
  static const String firebaseName = 'textitem';

  late String id;
  late String text;
  final String author;
  final String link;
  final int category;

  TextItem(this.text, this.author, {this.category = 0, this.id = '', this.link = ""});

  factory TextItem.fromJson(Map<String, dynamic> json) => _$TextItemFromJson(json);
  Map<String, dynamic> toJson() => _$TextItemToJson(this);
}
