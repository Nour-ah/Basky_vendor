import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_strings.dart';
import '../models/menu_category_model.dart';
import '../models/menu_item_model.dart';
import '../models/restaurant_details_model.dart';
import '../widgets/menu_item_card.dart';
import '../widgets/restaurant_categories_tabs.dart';
import '../widgets/restaurant_cover_widget.dart';
import '../widgets/restaurant_info_card.dart';
import 'add_food_page.dart';

class MyRestaurantPage extends StatefulWidget {
  const MyRestaurantPage({super.key});

  @override
  State<MyRestaurantPage> createState() => _MyRestaurantPageState();
}

class _MyRestaurantPageState extends State<MyRestaurantPage> {
  String _selectedCategory = AppStrings.deals;

  // Dummy Data
  final RestaurantDetailsModel _restaurantDetails = RestaurantDetailsModel(
    name: 'Burger King',
    isOpen: true,
    address: '1453 W Manchester Ave Los Angeles CA',
    rating: 4.8,
    deliveryTime: '60 min',
    deliveryFee: '30 EGP',
    logoUrl:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/Burger_King_2020.svg/1200px-Burger_King_2020.svg.png',
    coverImageUrl:
        'https://images.unsplash.com/photo-1550547660-d9450f859349?q=80&w=1000&auto=format&fit=crop',
  );

  @override
  Widget build(BuildContext context) {
    // Only init inside build context
    if (_selectedCategory.isEmpty || _selectedCategory == AppStrings.deals) {
      _selectedCategory = AppStrings.deals.tr();
    }

    final List<MenuCategoryModel> categories = [
      MenuCategoryModel(name: AppStrings.addWithPlus.tr(), isAddButton: true),
      MenuCategoryModel(name: AppStrings.deals.tr()),
      MenuCategoryModel(name: AppStrings.burgers.tr()),
      MenuCategoryModel(name: AppStrings.chicken.tr()),
      MenuCategoryModel(name: AppStrings.sandwich.tr()),
    ];

    final List<MenuItemModel> _menuItems = [
      MenuItemModel(
        name: 'Combo Spicy Tender',
        categoryName: 'Burger combo',
        price: 10.15,
        imageUrl:
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=1000&auto=format&fit=crop',
      ),
      MenuItemModel(
        name: 'Combo Spicy Tender',
        categoryName: 'Burger combo',
        price: 10.15,
        imageUrl:
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=1000&auto=format&fit=crop',
      ),
      MenuItemModel(
        name: 'Combo Spicy Tender',
        categoryName: 'Burger combo',
        price: 10.15,
        imageUrl:
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=1000&auto=format&fit=crop',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          RestaurantCoverWidget(
            coverImageUrl: _restaurantDetails.coverImageUrl,
            onBackPressed: () => Navigator.pop(context),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 220,
                ), // Height enough to overlap the cover
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RestaurantInfoCard(details: _restaurantDetails),
                      const SizedBox(height: 24),
                      RestaurantCategoriesTabs(
                        categories: categories, // Using local variable
                        selectedCategory: _selectedCategory,
                        onCategorySelected: (category) {
                          if (!category.startsWith('+')) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddFoodPage(),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: _menuItems.length,
                        itemBuilder: (context, index) {
                          return MenuItemCard(
                            item: _menuItems[index],
                            onEdit: () {},
                            onDelete: () {},
                          );
                        },
                      ),
                      const SizedBox(height: 80), // Padding for FAB
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddFoodPage()),
          );
        },
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
