import 'package:flutter/foundation.dart';

import '../models/menu_item.dart';

class CartEntry {
  final MenuItem item;
  int quantity;

  CartEntry({required this.item, this.quantity = 1});

  int get subtotal => item.price * quantity;
}

class CartService extends ChangeNotifier {
  CartService._();

  static final CartService instance = CartService._();

  final Map<String, CartEntry> _items = {};

  List<CartEntry> get items => List.unmodifiable(_items.values);

  int get totalItems =>
      _items.values.fold(0, (total, entry) => total + entry.quantity);

  int get totalPrice =>
      _items.values.fold(0, (total, entry) => total + entry.subtotal);

  void addItem(MenuItem item, {int quantity = 1}) {
    if (quantity <= 0) return;

    final existing = _items[item.id];

    if (existing != null) {
      existing.quantity += quantity;
    } else {
      _items[item.id] = CartEntry(item: item, quantity: quantity);
    }

    notifyListeners();
  }

  void increaseQuantity(String itemId) {
    final entry = _items[itemId];
    if (entry == null) return;

    entry.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(String itemId) {
    final entry = _items[itemId];
    if (entry == null) return;

    if (entry.quantity > 1) {
      entry.quantity--;
    } else {
      _items.remove(itemId);
    }

    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.remove(itemId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
