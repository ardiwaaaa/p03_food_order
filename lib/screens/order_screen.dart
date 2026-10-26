import 'package:flutter/material.dart';

import '../data/cart_service.dart';
import '../models/menu_item.dart';

class OrderScreen extends StatefulWidget {
  final MenuItem item;

  const OrderScreen({super.key, required this.item});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int quantity = 1;

  int get total => widget.item.price * quantity;

  String formatRupiah(int price) {
    final digits = price.toString();
    final result = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      result.write(digits[i]);

      final remaining = digits.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) {
        result.write('.');
      }
    }

    return 'Rp$result';
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        actions: [
          IconButton(
            tooltip: 'Buka keranjang',
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                item.emoji,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 90),
              ),
              const SizedBox(height: 16),
              Text(
                item.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(item.description, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              Text(
                'Harga satuan: ${formatRupiah(item.price)}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              const Text('Jumlah pesanan', textAlign: TextAlign.center),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: 'Kurangi jumlah',
                    onPressed: quantity > 1
                        ? () {
                            setState(() {
                              quantity--;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '$quantity',
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Tambah jumlah',
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Total: ${formatRupiah(total)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () {
                  CartService.instance.addItem(item, quantity: quantity);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '$quantity ${item.name} ditambahkan ke keranjang.',
                      ),
                      action: SnackBarAction(label: 'OK', onPressed: () {}),
                    ),
                  );

                  Navigator.pop(context);
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Tambah ke Keranjang'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kembali ke Menu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
