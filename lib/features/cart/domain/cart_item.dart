import '../../catalog/domain/product.dart';

class CartItem {
  final Product product;
  final int quantity;

  const CartItem({required this.product, this.quantity = 1});

  CartItem copyWith({int? quantity = 1}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);

  int get lineTotalCents => product.priceCents * quantity;
}