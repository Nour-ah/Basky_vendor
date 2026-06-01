import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/translations/locale_keys.g.dart';
import '../cubit/branches_cubit.dart';
import '../cubit/branches_state.dart';
import '../cubit/restaurant_catalog_cubit.dart';
import '../cubit/restaurant_catalog_state.dart';
import '../models/menu_category_model.dart';
import '../models/menu_item_model.dart';
import '../widgets/menu_item_card.dart';
import '../widgets/restaurant_categories_tabs.dart';
import 'add_food_page.dart';
import 'branch_details_page.dart';

class MyProductsPage extends StatefulWidget {
  const MyProductsPage({super.key});

  @override
  State<MyProductsPage> createState() => _MyProductsPageState();
}

class _MyProductsPageState extends State<MyProductsPage> {
  late final RestaurantCatalogCubit _catalogCubit;
  late final BranchesCubit _branchesCubit;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _catalogCubit = sl<RestaurantCatalogCubit>()..initCatalog();
    _branchesCubit = sl<BranchesCubit>()..fetchBranches();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _catalogCubit.close();
    _branchesCubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _catalogCubit.loadMoreProducts();
    }
  }

  Future<void> _openAddProduct() async {
    final didChange = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const AddFoodPage()),
    );
    if (didChange == true && mounted) {
      await _catalogCubit.initCatalog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _catalogCubit),
        BlocProvider.value(value: _branchesCubit),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            LocaleKeys.myProducts.tr(),
            style: AppTextStyle.heading18Bold,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _openAddProduct,
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add, color: AppColors.white),
          label: Text(
            LocaleKeys.addFood.tr(),
            style: AppTextStyle.fontWhite14Regular.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              _catalogCubit.initCatalog(),
              _branchesCubit.fetchBranches(),
            ]);
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Text(
                    LocaleKeys.myProductsSubtitle.tr(),
                    style: AppTextStyle.fontGrey14Regular,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _BranchesByProductSection()),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    LocaleKeys.allProducts.tr(),
                    style: AppTextStyle.fontBlack16Bold,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              BlocConsumer<RestaurantCatalogCubit, RestaurantCatalogState>(
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
                  if (state is CatalogLoading || state is CatalogInitial) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state is CatalogNetworkError ||
                      state is CatalogGenericError ||
                      state is CatalogUnauthorizedError) {
                    final message = state is CatalogNetworkError
                        ? state.message
                        : state is CatalogUnauthorizedError
                        ? state.message
                        : (state as CatalogGenericError).message;
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          message,
                          style: AppTextStyle.fontRed14Bold,
                        ),
                      ),
                    );
                  }

                  List<MenuCategoryModel> catModels = [];
                  if (state is CatalogLoaded || state is CatalogEmpty) {
                    final categories = state is CatalogLoaded
                        ? state.categories
                        : (state as CatalogEmpty).categories;
                    catModels = [
                      MenuCategoryModel(name: '+', isAddButton: true),
                      ...categories.map((e) => MenuCategoryModel(name: e.name)),
                    ];
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        if (catModels.isNotEmpty)
                          RestaurantCategoriesTabs(
                            categories: catModels,
                            selectedCategory: state is CatalogLoaded &&
                                    state.selectedCategoryId != null
                                ? state.categories
                                          .firstWhereOrNull(
                                            (c) =>
                                                c.id == state.selectedCategoryId,
                                          )
                                          ?.name ??
                                      LocaleKeys.all.tr()
                                : LocaleKeys.all.tr(),
                            onCategorySelected: (categoryName) async {
                              if (categoryName == '+') {
                                await _openAddProduct();
                                return;
                              }
                              final cat = state is CatalogLoaded
                                  ? state.categories.firstWhereOrNull(
                                      (c) => c.name == categoryName,
                                    )
                                  : null;
                              await _catalogCubit.filterProducts(
                                categoryId: cat?.id,
                              );
                            },
                          ),
                        const SizedBox(height: 16),
                        if (state is CatalogEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 48),
                            child: Center(
                              child: Text(LocaleKeys.noProductsFound.tr()),
                            ),
                          ),
                        if (state is CatalogLoaded) ...[
                          ...state.products.map(
                            (product) => MenuItemCard(
                              item: MenuItemModel(
                                name: product.name,
                                categoryName: product.categoryName,
                                price: product.price,
                                imageUrl: product.imageUrl ?? '',
                              ),
                              onEdit: () async {
                                final didChange = await Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddFoodPage(
                                      productId: product.id,
                                      initialName: product.name,
                                      initialPrice: product.price,
                                    ),
                                  ),
                                );
                                if (didChange == true) {
                                  await _catalogCubit.initCatalog();
                                }
                              },
                              onDelete: () =>
                                  _catalogCubit.deleteProduct(product.id),
                            ),
                          ),
                          if (!state.hasReachedMax)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        ],
                        const SizedBox(height: 88),
                      ]),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BranchesByProductSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BranchesCubit, BranchesState>(
      builder: (context, state) {
        if (state is BranchesLoading || state is BranchesInitial) {
          return const SizedBox(
            height: 52,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
        if (state is! BranchesLoaded || state.branches.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                LocaleKeys.manageProductsByBranch.tr(),
                style: AppTextStyle.fontBlack14Bold,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.branches.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final branch = state.branches[index];
                  return ActionChip(
                    avatar: const Icon(
                      Icons.store_outlined,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    label: Text(
                      branch.name,
                      style: AppTextStyle.fontPrimary12Regular,
                    ),
                    backgroundColor: AppColors.white,
                    side: const BorderSide(color: AppColors.primary),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BranchDetailsPage(branchId: branch.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
