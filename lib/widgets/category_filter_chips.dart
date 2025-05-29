import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../providers/food_provider.dart';

class CategoryFilterChips extends StatelessWidget {
  final VoidCallback? onFilterChanged;

  const CategoryFilterChips({super.key, this.onFilterChanged});

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodProvider>(
      builder: (context, foodProvider, child) {
        return SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildCategoryChip(
                context,
                FoodCategory.urgent,
                foodProvider.selectedCategories.isEmpty,
                foodProvider,
                true,
              ),
              SizedBox(width: 8),
              ...FoodCategory.values
                  .where((category) => category != FoodCategory.urgent)
                  .map(
                    (category) => Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: _buildCategoryChip(
                        context,
                        category,
                        foodProvider.selectedCategories.contains(category),
                        foodProvider,
                        false,
                      ),
                    ),
                  )
                  ,
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    FoodCategory category,
    bool isSelected,
    FoodProvider foodProvider,
    bool isAllOrUrgentChip,
  ) {
    String chipText =
        isAllOrUrgentChip
            ? "전체"
            : category.displayName.replaceAll(category.emoji, '').trim();
    String chipEmoji = isAllOrUrgentChip ? "전체" : category.emoji;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(chipEmoji, style: TextStyle(fontSize: 16)),
          SizedBox(width: 4),
          Text(
            chipText,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (isAllOrUrgentChip) {
          foodProvider.toggleAllCategories();
        } else {
          foodProvider.toggleCategory(category);
        }
        onFilterChanged?.call();
      },
      backgroundColor: Colors.grey[100],
      selectedColor: Color(0xFF4CAF50),
      checkmarkColor: Colors.white,
      elevation: isSelected ? 2 : 0,
      pressElevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Color(0xFF4CAF50) : Colors.grey[300]!,
          width: 1,
        ),
      ),
    );
  }
}
