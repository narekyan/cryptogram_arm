
import 'textItem.dart';
import 'package:json_annotation/json_annotation.dart';

part 'categoryModel.g.dart';



@JsonSerializable()
class CategoryModel {
  static const String firebaseName = 'category';

  static CategoryModel dummy(title) => CategoryModel(0, title, "", "0,0,0", []);

  final int index;
  final String title;
  final String icon;
  final String color;
  late List<TextItem> items;
  int founds;
  bool hasNew = false;

  CategoryModel(
    this.index,
    this.title,
    this.icon,
    this.color,
    this.items, {
    this.founds = 0,
        this.hasNew = false,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  (int, int, int) redGreenBlue() {
    var rgb = color.split(",").map((e) => int.parse(e));
    return (rgb.elementAt(0), rgb.elementAt(1), rgb.elementAt(2));
  }
}
