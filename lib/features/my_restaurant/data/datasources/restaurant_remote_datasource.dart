import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/validation_errors_model.dart';
import '../../../../core/network/api_constants.dart';
import '../../domain/entities/add_product_params.dart';
import '../../domain/entities/product_status.dart';
import '../models/branch_details_response_model.dart';
import '../models/category_model.dart';
import '../models/product_details_model.dart';
import '../models/product_summary_model.dart';
import '../models/product_variant_model.dart';
import '../models/vendor_branch_model.dart';

abstract class RestaurantRemoteDataSource {
  Future<List<VendorBranchModel>> getBranches();

  Future<BranchDetailsResponseModel> getBranchDetails(int branchId, {int page = 1});

  Future<List<CategoryModel>> getCategories();

  Future<List<ProductVariantModel>> getVariants();
  
  Future<List<ProductSummaryModel>> getProducts({
    int? categoryId,
    String? searchQuery,
    int page = 1,
    int limit = 15,
  });

  Future<ProductDetailsModel> getProductDetails(int productId);

  Future<void> addProduct(AddProductParams params, {CancelToken? cancelToken});
  
  Future<void> updateProduct(int productId, AddProductParams params, {CancelToken? cancelToken});

  Future<void> deleteProduct(int productId);

  Future<void> toggleProductActive(int productId);

  Future<bool> toggleStatus();
}

class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  final Dio dio;

  RestaurantRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<VendorBranchModel>> getBranches() async {
    debugPrint(
      '🔵 RestaurantRemoteDataSource: Sending GET ${ApiConstants.vendorBranches}',
    );
    try {
      final response = await dio.get(ApiConstants.vendorBranches);
      debugPrint('✅ RestaurantRemoteDataSource: Success fetching branches');
      final List<dynamic> data = response.data['data'] ?? [];
      return data
          .map((json) => VendorBranchModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ RestaurantRemoteDataSource: Error $e');
      throw const ParsingException();
    }
    throw const ServerException();
  }

  @override
  Future<BranchDetailsResponseModel> getBranchDetails(int branchId, {int page = 1}) async {
    debugPrint('🔵 RestaurantRemoteDataSource: Sending GET ${ApiConstants.vendorBranches}/$branchId');
    try {
      final response = await dio.get(
        '${ApiConstants.vendorBranches}/$branchId',
        queryParameters: {'page': page},
      );
      debugPrint('✅ RestaurantRemoteDataSource: Success fetching branch details');
      return BranchDetailsResponseModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ RestaurantRemoteDataSource: Error $e');
      throw const ParsingException();
    }
    throw const ServerException();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    debugPrint('🔵 RestaurantRemoteDataSource: Sending GET ${ApiConstants.vendorCategories}');
    try {
      final response = await dio.get(ApiConstants.vendorCategories);
      debugPrint('✅ RestaurantRemoteDataSource: Success fetching categories');
      return _parseCategoriesResponse(response.data['data']);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ RestaurantRemoteDataSource: Error $e');
      throw const ParsingException();
    }
    throw const ServerException();
  }

  @override
  Future<List<ProductVariantModel>> getVariants() async {
    debugPrint('🔵 RestaurantRemoteDataSource: GET ${ApiConstants.vendorVariants}');
    try {
      final response = await dio.get(ApiConstants.vendorVariants);
      final data = response.data['data'] as List<dynamic>? ?? [];
      return data
          .whereType<Map<String, dynamic>>()
          .map(ProductVariantModel.fromJson)
          .toList();
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      throw const ParsingException();
    }
    throw const ServerException();
  }

  @override
  Future<List<ProductSummaryModel>> getProducts({
    int? categoryId,
    String? searchQuery,
    int page = 1,
    int limit = 15,
  }) async {
    debugPrint('🔵 RestaurantRemoteDataSource: Sending GET ${ApiConstants.vendorProducts}');
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        'category_id': categoryId,
        if (searchQuery != null && searchQuery.isNotEmpty) 'search': searchQuery,
      };

      final response = await dio.get(
        ApiConstants.vendorProducts,
        queryParameters: queryParams,
      );

      debugPrint('✅ RestaurantRemoteDataSource: Success fetching products');
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => ProductSummaryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ RestaurantRemoteDataSource: Error $e');
      throw const ParsingException();
    }
    throw const ServerException();
  }

  @override
  Future<ProductDetailsModel> getProductDetails(int productId) async {
    debugPrint('🔵 RestaurantRemoteDataSource: Sending GET ${ApiConstants.vendorProducts}/$productId');
    try {
      final response = await dio.get('${ApiConstants.vendorProducts}/$productId');
      debugPrint('✅ RestaurantRemoteDataSource: Success fetching product details');
      return ProductDetailsModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ RestaurantRemoteDataSource: Error $e');
      throw const ParsingException();
    }
    throw const ServerException();
  }

  @override
  Future<void> addProduct(AddProductParams params, {CancelToken? cancelToken}) async {
    debugPrint('🔵 RestaurantRemoteDataSource: Sending POST ${ApiConstants.vendorProducts} (Multipart)');
    await _submitProductData(ApiConstants.vendorProducts, params, isUpdate: false, cancelToken: cancelToken);
  }

  @override
  Future<void> updateProduct(int productId, AddProductParams params, {CancelToken? cancelToken}) async {
    debugPrint('🔵 RestaurantRemoteDataSource: Sending POST ${ApiConstants.vendorProducts}/$productId (Multipart Update)');
    await _submitProductData('${ApiConstants.vendorProducts}/$productId', params, isUpdate: true, cancelToken: cancelToken);
  }

  @override
  Future<void> deleteProduct(int productId) async {
    debugPrint('🔵 RestaurantRemoteDataSource: Sending DELETE ${ApiConstants.vendorProducts}/$productId');
    try {
      await dio.delete('${ApiConstants.vendorProducts}/$productId');
      debugPrint('✅ RestaurantRemoteDataSource: Success deleting product');
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ RestaurantRemoteDataSource: Error $e');
      throw const ParsingException();
    }
  }

  @override
  Future<void> toggleProductActive(int productId) async {
    debugPrint('🔵 RestaurantRemoteDataSource: POST toggle-active $productId');
    try {
      await dio.post('${ApiConstants.vendorProducts}/$productId/toggle-active');
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<bool> toggleStatus() async {
    debugPrint('🔵 RestaurantRemoteDataSource: Sending POST ${ApiConstants.toggleBranchStatus}');
    try {
      final response = await dio.post(ApiConstants.toggleBranchStatus);
      debugPrint('✅ RestaurantRemoteDataSource: Success toggling branch status');
      final data = response.data;
      if (data != null && data['data'] != null) {
        final branchData = data['data'];
        if (branchData['is_open'] != null) {
          return branchData['is_open'] == true ||
              branchData['is_open'] == 1 ||
              branchData['is_open'] == '1';
        }
      }
      return true;
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    } catch (e) {
      debugPrint('❌ RestaurantRemoteDataSource: Error toggling branch status $e');
      throw const ParsingException();
    }
  }

  Future<void> _submitProductData(String path, AddProductParams params, {required bool isUpdate, CancelToken? cancelToken}) async {
    try {
      final Map<String, dynamic> data = {
        // ✅ type: only 'simple' or 'variable' — serialized via enum.name
        'type': params.productType.toApiString(),
        'name[en]': params.nameEn,
        'name[ar]': params.nameAr,
        'description[en]': params.descriptionEn,
        'description[ar]': params.descriptionAr,
        'sku': params.sku ?? '',
        'slug': params.slug ?? '',
        'price': params.price,
        // ✅ API expects 'discount' + 'discount_type', NOT 'discount_price'
        'discount': params.discountPercentage,
        'discount_type': params.discountType,
        // ✅ API uses is_active/is_featured/is_new/is_bookable as '1'/'0'
        'is_active': params.status == ProductStatus.active ? '1' : '0',
        'is_featured': params.isFeatured ? '1' : '0',
        'is_new': params.isNew ? '1' : '0',
        'is_bookable': params.isBookable ? '1' : '0',
        // ✅ API expects 'categories[0]' array-key format, NOT 'category_id'
        'categories[0]': params.categoryId,
      };

      if (params.variations != null && params.variations!.isNotEmpty) {
        for (var i = 0; i < params.variations!.length; i++) {
          final variation = params.variations![i];
          data['variations[$i][name][en]'] = variation.nameEn;
          data['variations[$i][name][ar]'] = variation.nameAr;
          data['variations[$i][sku]'] = variation.sku;
          data['variations[$i][price]'] = variation.price;
          for (var j = 0; j < variation.values.length; j++) {
            final value = variation.values[j];
            data['variations[$i][values][$j][variant_id]'] = value.variantId;
            data['variations[$i][values][$j][option_id]'] = value.optionId;
          }
        }
      } else if (params.variantIds != null && params.variantIds!.isNotEmpty) {
        for (int i = 0; i < params.variantIds!.length; i++) {
          data['variants[$i]'] = params.variantIds![i];
        }
      }

      // Workaround for PHP/Laravel not supporting PUT with multipart/form-data:
      // Add _method field so Laravel routes it correctly.
      if (isUpdate) {
        data['_method'] = 'PUT';
      }

      if (params.image != null) {
        // ✅ API key is 'thumbnail', not 'image'
        data['thumbnail'] = await MultipartFile.fromFile(
          params.image!.path,
          filename: params.image!.path.split('/').last,
        );
      }

      if (params.images != null && params.images!.isNotEmpty) {
        for (int i = 0; i < params.images!.length; i++) {
          data['images[$i]'] = await MultipartFile.fromFile(
            params.images![i].path,
            filename: params.images![i].path.split('/').last,
          );
        }
      }

      final formData = FormData.fromMap(data);

      debugPrint('🔵 RestaurantRemoteDataSource: FormData fields → ${data.keys.toList()}');

      await dio.post(
        path,
        data: formData,
        cancelToken: cancelToken,
        options: Options(
          contentType: 'multipart/form-data',
          sendTimeout: const Duration(minutes: 2),
          receiveTimeout: const Duration(minutes: 2),
        ),
      );

      debugPrint('✅ RestaurantRemoteDataSource: Success submitting product');
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        debugPrint('⚠️ RestaurantRemoteDataSource: Request canceled');
        throw const NetworkException(message: 'Upload canceled by user');
      }
      _handleDioException(e);
    } catch (e) {
      debugPrint('❌ RestaurantRemoteDataSource: Error submitting product $e');
      throw const ParsingException();
    }
  }

  List<CategoryModel> _parseCategoriesResponse(dynamic data) {
    final List<CategoryModel> categories = [];

    void walkTree(List<dynamic> nodes) {
      for (final node in nodes) {
        if (node is! Map<String, dynamic>) continue;
        categories.add(CategoryModel.fromJson(node));
        final children = node['children'];
        if (children is List && children.isNotEmpty) {
          walkTree(children);
        }
      }
    }

    if (data is Map<String, dynamic> && data['tree'] is List) {
      walkTree(data['tree'] as List);
    } else if (data is List) {
      for (final item in data) {
        if (item is Map<String, dynamic>) {
          categories.add(CategoryModel.fromJson(item));
        }
      }
    }

    return categories;
  }

  void _handleDioException(DioException e) {
    debugPrint('❌ RestaurantRemoteDataSource: DioException ${e.type} (Code: ${e.response?.statusCode})');
    if (e.response?.statusCode == 422) {
      // Parse validation errors
      final validationModel = ValidationErrorsModel.fromJson(e.response?.data['errors'] ?? {});
      debugPrint('❌ RestaurantRemoteDataSource: Validation Error: ${validationModel.errors}');
      throw ValidationException(errors: validationModel.errors);
    } else if (e.response?.statusCode == 401) {
      throw const UnauthorizedException();
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw const NetworkException();
    }
    throw ServerException(message: e.message ?? 'Server Error');
  }
}
