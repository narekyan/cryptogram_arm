import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../models/categoryModel.dart';

class CategoryListItemWidget extends StatelessWidget {
  const CategoryListItemWidget({
    required this.itemData,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final CategoryModel itemData;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    var rgb = itemData.redGreenBlue();
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Color.fromARGB(255, rgb.$1, rgb.$2, rgb.$3),
          borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(itemData.icon.categoryIcon(), color: Colors.white),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
              "${itemData.title}   ${itemData.founds}/${itemData.items.length}",
              style: const TextStyle(color: Colors.white)),
          if (itemData.hasNew) const Icon(Icons.fiber_new, color: Colors.yellow)
        ]),
        trailing: isSelected
            ? const Icon(Icons.check_circle_outline, color: Colors.white)
            : null,
        onTap: onTap,
      ),
    );
  }
}

extension DynamicIcon on String {
  IconData categoryIcon() {
    if (this == "menu_book") {
      return Icons.menu_book;
    }
    if (this == "mood") {
      return Icons.mood;
    }
    if (this == "live_tv") {
      return Icons.live_tv;
    }
    return Icons.square;
  }
}
