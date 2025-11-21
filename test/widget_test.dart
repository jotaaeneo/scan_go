// Test básico para la aplicación Scan&Go
//
// Este test verifica que la aplicación se construya correctamente
// y muestre los elementos principales de la interfaz.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scan_go/app/app.dart';

void main() {
  testWidgets('La app se construye y muestra el título', (
    WidgetTester tester,
  ) async {
    // Construir la app envuelta en ProviderScope
    await tester.pumpWidget(const ProviderScope(child: ScanGoApp()));

    // Esperar a que se complete la construcción inicial
    await tester.pumpAndSettle();

    // Verificar que el título 'Scan&Go' aparece en la app
    expect(find.text('Scan&Go'), findsWidgets);
  });

  testWidgets('La página de escaneo muestra los iconos de acción', (
    WidgetTester tester,
  ) async {
    // Construir la app
    await tester.pumpWidget(const ProviderScope(child: ScanGoApp()));

    await tester.pumpAndSettle();

    // Verificar que existen los iconos principales en el AppBar
    expect(find.byIcon(Icons.shopping_cart_outlined), findsWidgets);
    expect(find.byIcon(Icons.flash_on_outlined), findsWidgets);
    expect(find.byIcon(Icons.cameraswitch), findsWidgets);
  });

  testWidgets('Muestra el texto de ayuda para escanear', (
    WidgetTester tester,
  ) async {
    // Construir la app
    await tester.pumpWidget(const ProviderScope(child: ScanGoApp()));

    await tester.pumpAndSettle();

    // Verificar que el hint de escaneo está presente
    expect(
      find.text('Apunta al código de barras o QR del producto'),
      findsWidgets,
    );
  });
}
