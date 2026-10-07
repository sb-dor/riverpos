import 'package:riverpod/legacy.dart';
import 'package:riverpos/_core/local_pagination_util.dart';
import 'package:riverpos/initialization/models/dependencies.dart';
import 'package:riverpos/products/data/products_repository.dart';
import 'package:riverpos/products/models/product.dart';

final productsProvider = StateNotifierProvider<ProductsProvider, ProductsState>((_) {
  return ProductsProvider(
    productsRepository: ProductsRepositoryImpl(apiClient: dependencies.apiClient),
    localPaginationUtil: localPaginationUtil,
  );
});

sealed class ProductsState {
  const ProductsState();

  const factory ProductsState.initial() = Products$InitialState;

  const factory ProductsState.inProgress() = Products$InProgressState;

  const factory ProductsState.error({Object? error}) = Products$ErrorState;

  const factory ProductsState.completed({
    required List<Product> products,
    required int page,
    required bool hasMore,
  }) = Products$CompletedState;
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
  const Products$CompletedState({
    required this.products,
    required this.page,
    required this.hasMore,
  });

  final List<Product> products;
  final int page;
  final bool hasMore;
}

class ProductsProvider extends StateNotifier<ProductsState> {
  ProductsProvider({
    required this._productsRepository,
    required this._localPaginationUtil,
    ProductsState? state,
  }) : super(state ?? ProductsState.initial());

  final IProductsRepository _productsRepository;
  final LocalPaginationUtil _localPaginationUtil;

  void load() async {
    try {
      if (state is Products$InProgressState) return;

      state = ProductsState.inProgress();

      final products = await _productsRepository.products(page: 1, perPage: 20);

      final page = _localPaginationUtil.checkIsListHasMorePageInt(list: products, page: 1);

      final hasMore = _localPaginationUtil.checkIsListHasMorePageBool(
        list: products,
        limitInPage: 20,
      );

      state = ProductsState.completed(products: products, page: page, hasMore: hasMore);
    } catch (error) {
      state = ProductsState.error(error: error);
    }
  }

  void paginate() async {
    try {
      if (state is! Products$CompletedState) return;
      final completedState = state as Products$CompletedState;
      if (!completedState.hasMore) return;

      final products = await _productsRepository.products(page: completedState.page, perPage: 20);

      final page = _localPaginationUtil.checkIsListHasMorePageInt(
        list: products,
        page: completedState.page,
      );

      final hasMore = _localPaginationUtil.checkIsListHasMorePageBool(
        list: products,
        limitInPage: 20,
      );

      final currentProducts = List.of(completedState.products)..addAll(products);

      state = ProductsState.completed(products: currentProducts, page: page, hasMore: hasMore);
    } catch (error) {
      state = ProductsState.error(error: error);
    }
  }
}
