import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/validation_errors_model.dart';
import '../../../../core/network/api_constants.dart';
import '../../domain/entities/add_product_params.dart';
import '../models/category_model.dart';
import '../models/product_details_model.dart';
import '../models/product_summary_model.dart';
import '../models/product_variant_model.dart';
import '../models/vendor_branch_model.dart';

abstract class RestaurantRemoteDataSource {
  Future<List<VendorBranchModel>> getBranches();

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
  Future<List<CategoryModel>> getCategories() async {
    debugPrint('🔵 RestaurantRemoteDataSource: Sending GET ${ApiConstants.vendorCategories}');
    try {
      final response = await dio.get(ApiConstants.vendorCategories);
      debugPrint('✅ RestaurantRemoteDataSource: Success fetching categories');
      final List<dynamic> data = response.data['data'] ?? [];
      return data.map((json) => CategoryModel.fromJson(json)).toList();
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
        if (categoryId != null) 'category_id': categoryId,
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

  Future<void> _submitProductData(String path, AddProductParams params, {required bool isUpdate, CancelToken? cancelToken}) async {
    try {
      final Map<String, dynamic> data = {
        'name': params.name,
        'description': params.description,
        'price': params.price,
        'discount_price': params.price - (params.price * (params.discountPercentage / 100)), // mapped to discount_price
        'category_id': params.categoryId,
        'max_order_quantity': params.maxOrderQuantity,
        'status': params.status.toApiString(),
        if (params.subcategoryId != null) 'subcategory_id': params.subcategoryId,
      };

      // Workaround for PHP/Laravel not supporting PUT with FormData: Add _method field.
      if (isUpdate) {
        data['_method'] = 'PUT';
      }

      if (params.image != null) {
        // Prepare MultipartFile
        data['image'] = await MultipartFile.fromFile(
          params.image!.path,
          filename: params.image!.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(data);

      await dio.post(
        path,
        data: formData,
        cancelToken: cancelToken,
        options: Options(
          sendTimeout: const Duration(minutes: 2), // Generous timeout for uploads
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
