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
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/restaurant_catalog_cubit.dart';
import '../cubit/restaurant_catalog_state.dart';
import '../models/menu_category_model.dart';
import '../models/menu_item_model.dart';

class MyRestaurantPage extends StatefulWidget {
  const MyRestaurantPage({super.key});

  @override
  State<MyRestaurantPage> createState() => _MyRestaurantPageState();
}

class _MyRestaurantPageState extends State<MyRestaurantPage> {
  late final RestaurantCatalogCubit _cubit;
  final ScrollController _scrollController = ScrollController();
  
  final RestaurantDetailsModel _restaurantDetails = RestaurantDetailsModel(
    name: 'Burger King',
    isOpen: true,
    address: '1453 W Manchester Ave Los Angeles CA',
    rating: 4.8,
    deliveryTime: '60 min',
    deliveryFee: '30 EGP',
    logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/Burger_King_2020.svg/1200px-Burger_King_2020.svg.png',
    coverImageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?q=80&w=1000&auto=format&fit=crop',
  );

  @override
  void initState() {
    super.initState();
    _cubit = sl<RestaurantCatalogCubit>()..initCatalog();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _cubit.loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Stack(
          children: [
            RestaurantCoverWidget(coverImageUrl: _restaurantDetails.coverImageUrl, onBackPressed: () => Navigator.pop(context)),
            RefreshIndicator(
              onRefresh: () => _cubit.initCatalog(),
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 220),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
                      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RestaurantInfoCard(details: _restaurantDetails),
                          const SizedBox(height: 24),
                          
                          BlocConsumer<RestaurantCatalogCubit, RestaurantCatalogState>(
                            listener: (context, state) {
                              if (state is CatalogDeleteError) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: AppColors.promoRed));
                              }
                            },
                            builder: (context, state) {
                              if (state is CatalogLoading || state is CatalogInitial) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              List<MenuCategoryModel> catModels = [];
                              if (state is CatalogLoaded) {
                                catModels = [MenuCategoryModel(name: '+', isAddButton: true)] + state.categories.map((e) => MenuCategoryModel(name: e.name)).toList();
                              } else if (state is CatalogEmpty) {
                                catModels = [MenuCategoryModel(name: '+', isAddButton: true)] + state.categories.map((e) => MenuCategoryModel(name: e.name)).toList();
                              }

                              return Column(
                                children: [
                                  if (catModels.isNotEmpty)
                                    RestaurantCategoriesTabs(
                                      categories: catModels,
                                      selectedCategory: state is CatalogLoaded && state.selectedCategoryId != null 
                                          ? state.categories.firstWhere((c) => c.id == state.selectedCategoryId).name 
                                          : AppStrings.all.tr(),
                                      onCategorySelected: (categoryName) async {
                                        if (categoryName == '+') {
                                          final didChange = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFoodPage()));
                                          if (didChange == true) _cubit.initCatalog();
                                        } else {
                                          final cat = state is CatalogLoaded ? state.categories.firstWhere((c) => c.name == categoryName, orElse: () => state.categories.first) : null;
                                          _cubit.filterProducts(categoryId: cat?.id);
                                        }
                                      },
                                    ),
                                  const SizedBox(height: 24),
                                  
                                  if (state is CatalogEmpty) 
                                    const Center(child: Padding(padding: EdgeInsets.all(32.0), child: Text('No products found.'))),
                                    
                                  if (state is CatalogLoaded)
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: state.products.length + (state.hasReachedMax ? 0 : 1),
                                      itemBuilder: (context, index) {
                                        if (index >= state.products.length) return const Center(child: CircularProgressIndicator());
                                        final product = state.products[index];
                                        return MenuItemCard(
                                          item: MenuItemModel(
                                            name: product.name,
                                            categoryName: product.categoryName,
                                            price: product.price,
                                            imageUrl: product.imageUrl ?? '',
                                          ),
                                          onEdit: () {}, // would map to edit mode
                                          onDelete: () => _cubit.deleteProduct(product.id),
                                        );
                                      },
                                    ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final didChange = await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFoodPage()));
            if (didChange == true) _cubit.initCatalog();
          },
          backgroundColor: AppColors.primary,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: AppColors.white),
        ),
      ),
    );
  }
}
