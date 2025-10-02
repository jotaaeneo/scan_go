import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../presentation/cart_controller.dart';

class CartPage extends HookConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartControllerProvider);
    final controller = ref.read(cartControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/scan'),
        ),
        actions: [
          if (cart.items.isNotEmpty)
            IconButton(
              tooltip: 'Vaciar',
              onPressed: controller.clear,
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? const _EmptyCart()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              itemBuilder: (_, i) {
                final it = cart.items[i];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Mini foto/placeholder
                    Container(
                      width: 56,
                      height: 56,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).dividerColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.shopping_bag_outlined),
                    ),
                    const SizedBox(width: 12),
                    // Info del producto
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(it.product.name,
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text(
                            '${_money(it.product.priceCents, it.product.currency)} c/u',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Controles de cantidad
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton.filledTonal(
                          tooltip: 'Quitar 1',
                          onPressed: () => controller.removeOne(it.product),
                          icon: const Icon(Icons.remove),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '${it.quantity}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        IconButton.filledTonal(
                          tooltip: 'Agregar 1',
                          onPressed: () => controller.add(it.product),
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    // Total de la línea
                    Text(
                      _money(it.lineTotalCents, it.product.currency),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                );
              },
              separatorBuilder: (_, __) => const Divider(height: 20),
              itemCount: cart.items.length,
            ),
      // Barra inferior con total y CTA pagar
      bottomNavigationBar: _CartBottomBar(
        enabled: cart.items.isNotEmpty,
        totalText: _money(cart.subtotalCents, cart.currency),
        onPay: () => context.go('/ticket'),
      ),
    );
  }

  static String _money(int cents, String currency) {
    // Simple: 1290 -> $1.290 CLP (afinaremos con `intl` luego)
    final whole = (cents / 100).toStringAsFixed(0);
    final withDots = whole.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '\$$withDots $currency';
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.remove_shopping_cart_outlined, size: 72),
            const SizedBox(height: 12),
            Text('Tu carrito está vacío',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Escanea productos y ajusta la cantidad con los botones + / –.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CartBottomBar extends StatelessWidget {
  final bool enabled;
  final String totalText;
  final VoidCallback onPay;

  const _CartBottomBar({
    required this.enabled,
    required this.totalText,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: const [BoxShadow(blurRadius: 6, spreadRadius: 0, offset: Offset(0, -2))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Total: $totalText',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            FilledButton(
              onPressed: enabled ? onPay : null,
              child: const Text('Pagar'),
            ),
          ],
        ),
      ),
    );
  }
}
