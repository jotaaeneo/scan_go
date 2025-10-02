class Product {
  final String id;
  final String barcode;
  final String name;
  final int priceCents;
  final String currency;

  const Product({
    required this.id,
    required this.barcode,
    required this.name,
    required this.priceCents,
    this.currency = 'CLP',
  });
}