import '../data/order_history_service.dart';

import 'package:flutter/material.dart';

import '../data/cart_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  String orderType = 'Delivery';

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
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _confirmOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final cart = CartService.instance;

    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Keranjang masih kosong.')));
      return;
    }

    final name = _nameController.text.trim();
    final address = _addressController.text.trim();
    final total = cart.totalPrice;
    final itemSummary = cart.items
        .map(
          (entry) =>
              '${entry.item.name} x${entry.quantity} '
              '(${formatRupiah(entry.subtotal)})',
        )
        .join('\n');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Pesanan'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Nama: $name'),
                const SizedBox(height: 8),
                Text('Jenis pesanan: $orderType'),
                if (orderType == 'Delivery') ...[
                  const SizedBox(height: 8),
                  Text('Alamat: $address'),
                ],
                const Divider(height: 24),
                const Text(
                  'Daftar pesanan:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(itemSummary),
                const Divider(height: 24),
                Text(
                  'Total: ${formatRupiah(total)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Periksa Lagi'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Konfirmasi'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    OrderHistoryService.instance.addOrder(
      OrderHistoryEntry(
        id: 'ORD-${DateTime.now().microsecondsSinceEpoch}',
        customerName: name,
        orderType: orderType,
        address: orderType == 'Delivery' ? address : '',
        items: cart.items
            .map(
              (entry) =>
                  OrderHistoryItem(item: entry.item, quantity: entry.quantity),
            )
            .toList(),
        totalPrice: total,
        orderDate: DateTime.now(),
      ),
    );

    cart.clear();

    Navigator.of(context).popUntil((route) => route.isFirst);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pesanan berhasil dikonfirmasi!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartService.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: AnimatedBuilder(
        animation: cart,
        builder: (context, _) {
          final items = cart.items;

          if (items.isEmpty) {
            return const Center(child: Text('Keranjang masih kosong.'));
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Data Pemesan',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama pemesan',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama pemesan wajib diisi.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: orderType,
                  decoration: const InputDecoration(
                    labelText: 'Jenis pesanan',
                    prefixIcon: Icon(Icons.restaurant_outlined),
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Delivery',
                      child: Text('Delivery (Antar)'),
                    ),
                    DropdownMenuItem(
                      value: 'Take Away',
                      child: Text('Take Away (Bawa Pulang)'),
                    ),
                    DropdownMenuItem(
                      value: 'Dine In',
                      child: Text('Dine In (Makan di Tempat)'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      orderType = value;
                    });
                  },
                ),
                if (orderType == 'Delivery') ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Alamat pengantaran',
                      prefixIcon: Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    minLines: 2,
                    maxLines: 3,
                    validator: (value) {
                      if (orderType == 'Delivery' &&
                          (value == null || value.trim().isEmpty)) {
                        return 'Alamat pengantaran wajib diisi.';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 24),
                Text(
                  'Ringkasan Pesanan',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ...items.map(
                  (entry) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Text(
                      entry.item.emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                    title: Text(entry.item.name),
                    subtitle: Text(
                      '${entry.quantity} x '
                      '${formatRupiah(entry.item.price)}',
                    ),
                    trailing: Text(formatRupiah(entry.subtotal)),
                  ),
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Pembayaran',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      formatRupiah(cart.totalPrice),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _confirmOrder,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Konfirmasi Pesanan'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
