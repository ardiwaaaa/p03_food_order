import 'package:flutter/material.dart';

import '../data/cart_service.dart';
import '../data/menu_data.dart';
import '../widgets/menu_card.dart';
import 'cart_screen.dart';
import 'order_history_screen.dart';
import 'order_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String searchQuery = '';
  String selectedCategory = 'Semua';

  final List<String> categories = ['Semua', 'Makanan', 'Minuman'];

  @override
  Widget build(BuildContext context) {
    final filteredMenu = menuData.where((item) {
      final matchesSearch = item.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      final matchesCategory =
          selectedCategory == 'Semua' || item.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Order'),
        centerTitle: true,
        actions: [
          AnimatedBuilder(
            animation: CartService.instance,
            builder: (context, _) {
              final count = CartService.instance.totalItems;

              return IconButton(
                tooltip: 'Buka keranjang',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
                icon: Badge(
                  isLabelVisible: count > 0,
                  label: Text('$count'),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Riwayat pesanan',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrderHistoryScreen()),
              );
            },
            icon: const Icon(Icons.history),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Pilih Menu Favoritmu',
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari makanan atau minuman...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 42,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final category = categories[index];

                        return ChoiceChip(
                          label: Text(category),
                          selected: selectedCategory == category,
                          onSelected: (_) {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${filteredMenu.length} menu ditemukan',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        if (filteredMenu.isEmpty) {
                          return const Center(
                            child: Text('Menu tidak ditemukan.'),
                          );
                        }

                        // Layar lebar: tampilkan menu dalam bentuk grid.
                        if (constraints.maxWidth >= 700) {
                          final columnCount = constraints.maxWidth >= 1000
                              ? 3
                              : 2;

                          return GridView.builder(
                            padding: const EdgeInsets.only(bottom: 16),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: columnCount,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  mainAxisExtent: 190,
                                ),
                            itemCount: filteredMenu.length,
                            itemBuilder: (context, index) {
                              final item = filteredMenu[index];

                              return MenuCard(
                                item: item,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => OrderScreen(item: item),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }

                        // Layar kecil: tampilkan menu secara vertikal.
                        return ListView.builder(
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: filteredMenu.length,
                          itemBuilder: (context, index) {
                            final item = filteredMenu[index];

                            return MenuCard(
                              item: item,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => OrderScreen(item: item),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
