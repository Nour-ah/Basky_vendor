import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/restaurant_catalog_cubit.dart';
import '../cubit/restaurant_catalog_state.dart';
import '../cubit/restaurant_details_cubit.dart';
import '../cubit/restaurant_details_state.dart';
import '../models/menu_category_model.dart';
import '../models/menu_item_model.dart';
import '../models/restaurant_details_model.dart';
import '../widgets/menu_item_card.dart';
import '../widgets/restaurant_categories_tabs.dart';
import '../widgets/restaurant_cover_widget.dart';
import '../widgets/restaurant_info_card.dart';
import 'add_food_page.dart';

class BranchDetailsPage extends StatefulWidget {
  final int branchId;

  const BranchDetailsPage({super.key, required this.branchId});

  @override
  State<BranchDetailsPage> createState() => _BranchDetailsPageState();
}

class _BranchDetailsPageState extends State<BranchDetailsPage> {
  late final RestaurantCatalogCubit _catalogCubit;
  late final RestaurantDetailsCubit _detailsCubit;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _catalogCubit = sl<RestaurantCatalogCubit>()..initCatalog();
    _detailsCubit = sl<RestaurantDetailsCubit>()..fetchDetails(widget.branchId);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _catalogCubit.close();
    _detailsCubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _catalogCubit.loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _catalogCubit),
        BlocProvider.value(value: _detailsCubit),
      ],
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
          builder: (context, detailsState) {
            if (detailsState is RestaurantDetailsLoading ||
                detailsState is RestaurantDetailsInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (detailsState is RestaurantDetailsError) {
              return Center(child: Text(detailsState.message));
            }
            if (detailsState is RestaurantDetailsEmpty) {
              return Center(child: Text(LocaleKeys.noProductsFound.tr()));
            }
            if (detailsState is! RestaurantDetailsLoaded) {
              return const SizedBox.shrink();
            }

            final details = RestaurantDetailsModel.fromBranch(
              detailsState.branch,
            );

            return Stack(
              children: [
                RestaurantCoverWidget(
                  coverImageUrl: details.coverImageUrl,
                  onBackPressed: () {
                    Navigator.pop(context);
                  },
                ),
                RefreshIndicator(
                  onRefresh: () async {
                    await Future.wait([
                      _detailsCubit.fetchDetails(widget.branchId),
                      _catalogCubit.initCatalog(),
                    ]);
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 220),
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          padding: const EdgeInsets.fromLTRB(
                            16.0,
                            20.0,
                            16.0,
                            16.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RestaurantInfoCard(details: details),
                              const SizedBox(height: 24),
                              BlocConsumer<
                                RestaurantCatalogCubit,
                                RestaurantCatalogState
                              >(
                                listener: (context, state) {
                                  if (state is CatalogDeleteError) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(state.message),
                                        backgroundColor: AppColors.promoRed,
                                      ),
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  if (state is CatalogLoading ||
                                      state is CatalogInitial) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  List<MenuCategoryModel> catModels = [];
                                  if (state is CatalogLoaded) {
                                    catModels = [
                                      MenuCategoryModel(
                                        name: '+',
                                        isAddButton: true,
                                      ),
                                      ...state.categories.map(
                                        (e) => MenuCategoryModel(name: e.name),
                                      ),
                                    ];
                                  } else if (state is CatalogEmpty) {
                                    catModels = [
                                      MenuCategoryModel(
                                        name: '+',
                                        isAddButton: true,
                                      ),
                                      ...state.categories.map(
                                        (e) => MenuCategoryModel(name: e.name),
                                      ),
                                    ];
                                  }

                                  return Column(
                                    children: [
                                      if (catModels.isNotEmpty)
                                        RestaurantCategoriesTabs(
                                          categories: catModels,
                                          selectedCategory:
                                              state is CatalogLoaded &&
                                                  state.selectedCategoryId !=
                                                      null
                                              // ✅ firstWhereOrNull: avoids orElse
                                              // type mismatch between List<CategoryEntity>
                                              // (declared) and List<CategoryModel> (runtime).
                                              ? state.categories
                                                        .firstWhereOrNull(
                                                          (c) =>
                                                              c.id ==
                                                              state
                                                                  .selectedCategoryId,
                                                        )
                                                        ?.name ??
                                                    LocaleKeys.all.tr()
                                              : LocaleKeys.all.tr(),
                                          onCategorySelected: (categoryName) async {
                                            if (categoryName == '+') {
                                              final didChange =
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const AddFoodPage(),
                                                    ),
                                                  );
                                              if (didChange == true) {
                                                _catalogCubit.initCatalog();
                                              }
                                            } else {
                                              // ✅ firstWhereOrNull eliminates the orElse
                                              // callback that caused the runtime type crash:
                                              // '() => CategoryEntity' is not a subtype
                                              // of '() => CategoryModel'.
                                              final cat = state is CatalogLoaded
                                                  ? state.categories
                                                        .firstWhereOrNull(
                                                          (c) =>
                                                              c.name ==
                                                              categoryName,
                                                        )
                                                  : null;
                                              _catalogCubit.filterProducts(
                                                categoryId: cat?.id,
                                              );
                                            }
                                          },
                                        ),
                                      const SizedBox(height: 24),
                                      if (state is CatalogEmpty)
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(32.0),
                                            child: Text(
                                              LocaleKeys.noProductsFound.tr(),
                                            ),
                                          ),
                                        ),
                                      if (state is CatalogLoaded)
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemCount:
                                              state.products.length +
                                              (state.hasReachedMax ? 0 : 1),
                                          itemBuilder: (context, index) {
                                            if (index >=
                                                state.products.length) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                            final product =
                                                state.products[index];
                                            return MenuItemCard(
                                              item: MenuItemModel(
                                                name: product.name,
                                                categoryName:
                                                    product.categoryName,
                                                price: product.price,
                                                imageUrl:
                                                    product.imageUrl ?? '',
                                              ),
                                              onEdit: () async {
                                                final didChange =
                                                    await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AddFoodPage(
                                                              productId:
                                                                  product.id,
                                                              initialName:
                                                                  product.name,
                                                              initialPrice:
                                                                  product.price,
                                                            ),
                                                      ),
                                                    );
                                                if (didChange == true) {
                                                  _catalogCubit.initCatalog();
                                                }
                                              },
                                              onDelete: () => _catalogCubit
                                                  .deleteProduct(product.id),
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
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final didChange = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddFoodPage()),
            );
            if (didChange == true) _catalogCubit.initCatalog();
          },
          backgroundColor: AppColors.primary,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: AppColors.white),
        ),
      ),
    );
  }
}
