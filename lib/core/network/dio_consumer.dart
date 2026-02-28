// import 'package:dio/dio.dart';
//
// import '../cache_helper/local_storage.dart';
// import '../errors/exeptions.dart';
// import 'api_consumer.dart';
// import 'api_interceptor.dart';
// import 'end_points.dart';
//
// class DioConsumer extends ApiConsumer {
//   DioConsumer({required this.dio}) {
//     dio.options.baseUrl = EndPoints.baseUrl;
//
//     dio.interceptors.add(
//       ApiInterceptor(
//         getToken: () async =>
//             await LocalStorage.getData(key: 'token', isSecure: true) as String?,
//       ),
//     );
//
//     dio.interceptors.add(
//       LogInterceptor(
//         request: true,
//         requestBody: true,
//         responseBody: true,
//         requestHeader: true,
//         responseHeader: false,
//         error: true,
//       ),
//     );
//   }
//   final Dio dio;
//   @override
//   Future delete(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParams,
//     bool isFormData = false,
//   }) async {
//     try {
//       final response = await dio.delete(
//         path,
//         queryParameters: queryParams,
//         data: isFormData ? FormData.fromMap(data) : data,
//       );
//       return response.data;
//     } on DioException catch (e) {
//       handleDioExceptions(e);
//     }
//   }
//
//   @override
//   Future get(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParams,
//     bool isFormData = false,
//   }) async {
//     try {
//       final response = await dio.get(
//         path,
//         queryParameters: queryParams,
//         data: isFormData ? FormData.fromMap(data) : data,
//       );
//       return response.data;
//     } on DioException catch (e) {
//       handleDioExceptions(e);
//     }
//   }
//
//   @override
//   Future post(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParams,
//     bool isFormData = false,
//   }) async {
//     try {
//       final response = await dio.post(
//         path,
//         queryParameters: queryParams,
//         data: isFormData ? FormData.fromMap(data) : data,
//       );
//       return response.data;
//     } on DioException catch (e) {
//       handleDioExceptions(e);
//     }
//   }
//
//   @override
//   Future put(
//     String path, {
//     dynamic data,
//     Map<String, dynamic>? queryParams,
//     bool isFormData = false,
//   }) async {
//     try {
//       final response = await dio.put(
//         path,
//         queryParameters: queryParams,
//         data: isFormData ? FormData.fromMap(data) : data,
//       );
//       return response.data;
//     } on DioException catch (e) {
//       handleDioExceptions(e);
//     }
//   }
// }
