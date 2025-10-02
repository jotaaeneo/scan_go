import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/scan/presentation/scan_page.dart';
import '../features/cart/presentation/cart_page.dart';
import '../features/ticket/presentation/ticket_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/scan',
    routes: [
      GoRoute(
        path: '/scan',
        builder: (context, state) => const ScanPage(),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartPage(),
      ),
      GoRoute(
        path: '/ticket',
        builder: (context, state) => const TicketPage(),
      ),
    ],
  );
});
