import '../domain/product.dart';

abstract class ProductRepository {
  Future<Product?> getByBarcode(String code);
}

//temporal codigos de ejemplo
class InMemoryProductRepository implements ProductRepository {
  final _data = <String, Product>{
    '7800987654321': Product(
      id: '1', barcode: '7800987654321', name: 'Leche entera 1L', priceCents: 1290,
    ),
    '7801234567890': Product(
      id: '2', barcode: '7801234567890', name: 'Pan de molde integral', priceCents: 1990,
    ),
    'QR-DEMO-001': Product(
      id: '3', barcode: 'QR-DEMO-001', name: 'Café molido 250g', priceCents: 2990,
    ),
  };

  @override
  Future<Product?> getByBarcode(String code) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _data[code];
  }
}