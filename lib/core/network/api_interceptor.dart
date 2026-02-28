// import 'package:dio/dio.dart';
//
// class ApiInterceptor extends Interceptor {
//   final Future<String?> Function() getToken;
//
//   ApiInterceptor({required this.getToken});
//
//   @override
//   void onRequest(
//     RequestOptions options,
//     RequestInterceptorHandler handler,
//   ) async {
//     options.headers['Content-Type'] = 'application/json';
//     options.headers['Accept'] = 'application/json';
//
//     final token = await getToken();
//     if (token != null && token.isNotEmpty) {
//       options.headers['Authorization'] = 'Bearer $token';
//     }
//
//     super.onRequest(options, handler);
//   }
// }
