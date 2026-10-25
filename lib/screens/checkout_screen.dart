import 'package:flutter/material.dart';

import '../models/menu_item.dart';

class CheckoutScreen extends StatefulWidget {
  final MenuItem item;
  final int quantity;

  const CheckoutScreen({super.key, required this.item, required this.quantity});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  String? _orderType;

  int get total => widget.item.price * widget.quantity;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submitOrder() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Pesanan Berhasil!'),
        content: Text(
          'Nama: ${_nameController.text.trim()}\n'
          'Alamat: ${_addressController.text.trim()}\n'
          'Jenis: $_orderType\n'
          'Menu: ${widget.item.name}\n'
          'Jumlah: ${widget.quantity}\n'
          'Total: Rp$total',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text('Kembali ke Menu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Data Pemesan',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama pelanggan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama pelanggan wajib diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Alamat pengantaran',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Alamat wajib diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _orderType,
                decoration: const InputDecoration(
                  labelText: 'Jenis pesanan',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Delivery', child: Text('Delivery')),
                  DropdownMenuItem(
                    value: 'Take Away',
                    child: Text('Take Away'),
                  ),
                  DropdownMenuItem(value: 'Dine In', child: Text('Dine In')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih jenis pesanan.';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _orderType = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Menu: ${widget.item.name}'),
                      Text('Jumlah: ${widget.quantity}'),
                      const Divider(),
                      Text(
                        'Total: Rp$total',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submitOrder,
                child: const Text('Konfirmasi Pesanan'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kembali ke Pesanan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
