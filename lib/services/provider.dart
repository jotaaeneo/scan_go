import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/catalog/data/product_repository.dart';

final productRepositoryProvider = Provider((ref) {
  return InMemoryProductRepository();
});