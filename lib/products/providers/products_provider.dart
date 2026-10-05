import 'package:riverpod/riverpod.dart';
import 'package:riverpos/_core/local_pagination_util.dart';
import 'package:riverpos/initialization/models/dependencies.dart';
import 'package:riverpos/products/data/products_repository.dart';
import 'package:riverpos/products/models/product.dart';

/// I could create this globally with no riverpod's provider (simple global variable)
final productsProvider = NotifierProvider<ProductsProvider, ProductsState>(ProductsProvider.new);

final productsRepositoryImpl = Provider<IProductsRepository>((ref) {
  final dependencies = ref.read(dependenciesProvider);
  return ProductsRepositoryImpl(apiClient: dependencies.apiClient);
});

sealed class ProductsState {
  const ProductsState();

  const factory ProductsState.initial() = Products$InitialState;

  const factory ProductsState.inProgress() = Products$InProgressState;

  const factory ProductsState.error({Object? error}) = Products$ErrorState;

  const factory ProductsState.completed({required List<Product> products, required int page, required bool hasMore}) =
      Products$CompletedState;
}

class Products$InitialState extends ProductsState {
  const Products$InitialState();
}

class Products$InProgressState extends ProductsState {
  const Products$InProgressState();
}

class Products$ErrorState extends ProductsState {
  const Products$ErrorState({this.error});

  final Object? error;
}

class Products$CompletedState extends ProductsState {
  const Products$CompletedState({required this.products, required this.page, required this.hasMore});

  final List<Product> products;
  final int page;
  final bool hasMore;
}

class ProductsProvider extends Notifier<ProductsState> {
  @override
  ProductsState build() => ProductsState.initial();

  void load() async {
    try {
      if (state is Products$InProgressState) return;

      state = ProductsState.inProgress();

      /// блять/бля/бла
      /// https://en.wikipedia.org/wiki/Coupling_(computer_programming)
      final productsRepository = ref.read(productsRepositoryImpl);

      final localPaginationUtil = ref.read(localPaginationUtilProvider);

      final products = await productsRepository.products(page: 1, perPage: 20);

      final page = localPaginationUtil.checkIsListHasMorePageInt(list: products, page: 1);

      final hasMore = localPaginationUtil.checkIsListHasMorePageBool(list: products, limitInPage: 20);

      state = ProductsState.completed(products: products, page: page, hasMore: hasMore);
    } catch (error) {
      state = ProductsState.error(error: error);
    }
  }

  void paginate() async {
    try {
      if (state is! Products$CompletedState) return;
      final completedState = state as Products$CompletedState;

      /// блять/бля/бла
      /// https://en.wikipedia.org/wiki/Coupling_(computer_programming)
      final productsRepository = ref.read(productsRepositoryImpl);

      final localPaginationUtil = ref.read(localPaginationUtilProvider);

      final products = await productsRepository.products(page: completedState.page, perPage: 20);

      final page = localPaginationUtil.checkIsListHasMorePageInt(list: products, page: completedState.page);

      final hasMore = localPaginationUtil.checkIsListHasMorePageBool(list: products, limitInPage: 20);

      state = ProductsState.completed(products: products, page: page, hasMore: hasMore);
    } catch (error) {
      state = ProductsState.error(error: error);
    }
  }
}
