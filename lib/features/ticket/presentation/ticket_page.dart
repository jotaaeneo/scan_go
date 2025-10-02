import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TicketPage extends StatelessWidget {
  const TicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder: luego mostraremos QR y detalles del ticket real
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/cart'),
        ),
      ),
      body: const Center(
        child: Text('Aquí verás tu ticket y el QR de salida'),
      ),
    );
  }
}

