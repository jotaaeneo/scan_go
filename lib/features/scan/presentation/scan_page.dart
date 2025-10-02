import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:scan_go/services/provider.dart';
import '../../catalog/domain/product.dart';
import '../../cart/presentation/cart_controller.dart';

class ScanPage extends HookConsumerWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useMemoized(() => MobileScannerController(
          detectionSpeed: DetectionSpeed.normal,
          facing: CameraFacing.back,
          torchEnabled: false,
        ));
    final isBusy = useState(false);
    final lastCode = useState<String?>(null);
    Timer? debounceTimer = useMemoized(() => null, const []);

    Future<void> _handleBarcode(String rawValue) async {
      // Debounce básico para evitar múltiples lecturas de un mismo código.
      if (isBusy.value || rawValue == lastCode.value) return;
      isBusy.value = true;
      lastCode.value = rawValue;

      final repo = ref.read(productRepositoryProvider);
      final product = await repo.getByBarcode(rawValue);

      if (!context.mounted) return;

      if (product != null) {
        await _showProductSheet(context, ref, product);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Producto no encontrado: $rawValue')),
        );
      }

      // Pequeña pausa + limpiar bloqueo/debounce
      debounceTimer?.cancel();
      debounceTimer = Timer(const Duration(milliseconds: 600), () {
        isBusy.value = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan&Go'),
        actions: [
          IconButton(
            onPressed: () => context.go('/cart'),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
          IconButton(
            onPressed: () => controller.toggleTorch(),
            icon: const Icon(Icons.flash_on_outlined),
          ),
          IconButton(
            onPressed: () => controller.switchCamera(),
            icon: const Icon(Icons.cameraswitch),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: controller,
              onDetect: (capture) {
                final barcodes = capture.barcodes;
                if (barcodes.isEmpty) return;
                final code = barcodes.first.rawValue;
                if (code != null) {
                  _handleBarcode(code);
                }
              },
            ),
          ),
          const _ScanHint(),
        ],
      ),
    );
  }

  Future<void> _showProductSheet(
      BuildContext context, WidgetRef ref, Product product) async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(product.name,
                style: Theme.of(ctx).textTheme.titleLarge,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(_money(product.priceCents, product.currency),
                style: Theme.of(ctx).textTheme.titleMedium),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                ref.read(cartControllerProvider.notifier).add(product);
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Añadido al carrito')),
                );
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Agregar al carrito'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
    );
  }

  String _money(int cents, String currency) {
    // simple: 1290 -> $1.290 CLP (se mejora con intl en el siguiente paso)
    final whole = (cents / 100).toStringAsFixed(0);
    final withDots = whole.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    return '\$$withDots $currency';
  }
}

class _ScanHint extends StatelessWidget {
  const _ScanHint();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: const Text(
          'Apunta al código de barras o QR del producto',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
