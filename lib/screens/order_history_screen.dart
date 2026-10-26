import 'package:flutter/material.dart';

import '../data/order_history_service.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

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

  String formatDate(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year} '
        '${twoDigits(date.hour)}:${twoDigits(date.minute)}';
  }

  void showOrderDetails(BuildContext context, OrderHistoryEntry order) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Pesanan ${order.id}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Pemesan: ${order.customerName}'),
                const SizedBox(height: 6),
                Text('Jenis: ${order.orderType}'),
                if (order.address.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text('Alamat: ${order.address}'),
                ],
                const SizedBox(height: 6),
                Text('Waktu: ${formatDate(order.orderDate)}'),
                const Divider(height: 24),
                const Text(
                  'Daftar menu',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...order.items.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.item.emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${entry.item.name} x${entry.quantity}\n'
                            '${formatRupiah(entry.subtotal)}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 24),
                Text(
                  'Total: ${formatRupiah(order.totalPrice)}',
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
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final history = OrderHistoryService.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Pesanan')),
      body: AnimatedBuilder(
        animation: history,
        builder: (context, _) {
          final orders = history.orders;

          if (orders.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 72,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Belum ada riwayat pesanan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Pesanan yang dikonfirmasi akan muncul di sini.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: const CircleAvatar(child: Icon(Icons.receipt_long)),
                  title: Text(
                    'Pesanan ${order.id}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${order.customerName}\n'
                      '${order.totalItems} item • ${order.orderType}\n'
                      '${formatDate(order.orderDate)}',
                    ),
                  ),
                  isThreeLine: true,
                  trailing: Text(
                    formatRupiah(order.totalPrice),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () => showOrderDetails(context, order),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
