import 'package:riverpos/_core/api_client.dart';
import 'package:riverpos/products/models/product.dart';

abstract interface class IProductsRepository {
  Future<List<Product>> products({required int page, required int perPage});
}

class ProductsRepositoryImpl implements IProductsRepository {
  ProductsRepositoryImpl({required this._apiClient});

  final IApiClient _apiClient;
  final String _products = '/product';

  @override
  Future<List<Product>> products({required int page, required int perPage}) async {
    final response = await _apiClient.get(
      _products,
      queryParameters: {'page': page.toString(), 'per_page': perPage.toString()},
    );

    if (response['status'] == true) {
      final dProducts = response['data'] as List<Object?>? ?? <Object>[];
      return dProducts.map((json) => Product.fromJson(json as Map<String, Object?>)).toList();
    }

    throw Exception("Couldn't get products due to a server error: $response");
  }
}
