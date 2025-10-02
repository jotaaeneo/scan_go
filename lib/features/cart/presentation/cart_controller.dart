
import 'package:flutter_riverpod/legacy.dart';
import 'package:state_notifier/state_notifier.dart';
import '../../catalog/domain/product.dart';
import '../domain/cart_item.dart';
class CartState {
  final List<CartItem> items;
  const CartState(this.items);

  int get subtotalCents =>
      items.fold(0, (acc, it) => acc + it.lineTotalCents);

  String get currency => items.isEmpty ? 'CLP' : items.first.product.currency;
}

class CartController extends StateNotifier<CartState> {
  CartController() : super(const CartState([]));

  void add(Product p) {
    final idx = state.items.indexWhere((e) => e.product.id == p.id);
    if (idx >= 0) {
      final updated = [...state.items];
      final current = updated[idx];
      updated[idx] = current.copyWith(quantity: current.quantity + 1);
      state = CartState(updated);
    } else {
      state = CartState([...state.items, CartItem(product: p, quantity: 1)]);
    }
  }

  void removeOne(Product p) {
    final idx = state.items.indexWhere((e) => e.product.id == p.id);
    if (idx < 0) return;
    final updated = [...state.items];
    final current = updated[idx];
    final newQty = current.quantity - 1;
    if (newQty <= 0) {
      updated.removeAt(idx);
    } else {
      updated[idx] = current.copyWith(quantity: newQty);
    }
    state = CartState(updated);
  }

  void clear() => state = const CartState([]);
}

final cartControllerProvider =
    StateNotifierProvider<CartController, CartState>((ref) {
  return CartController();
});
