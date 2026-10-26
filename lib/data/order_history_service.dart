import 'package:flutter/foundation.dart';

import '../models/menu_item.dart';

class OrderHistoryItem {
  final MenuItem item;
  final int quantity;

  const OrderHistoryItem({required this.item, required this.quantity});

  int get subtotal => item.price * quantity;
}

class OrderHistoryEntry {
  final String id;
  final String customerName;
  final String orderType;
  final String address;
  final List<OrderHistoryItem> items;
  final int totalPrice;
  final DateTime orderDate;

  OrderHistoryEntry({
    required this.id,
    required this.customerName,
    required this.orderType,
    required this.address,
    required List<OrderHistoryItem> items,
    required this.totalPrice,
    required this.orderDate,
  }) : items = List.unmodifiable(items);

  int get totalItems => items.fold(0, (total, item) => total + item.quantity);
}

class OrderHistoryService extends ChangeNotifier {
  OrderHistoryService._();

  static final OrderHistoryService instance = OrderHistoryService._();

  final List<OrderHistoryEntry> _orders = [];

  List<OrderHistoryEntry> get orders => List.unmodifiable(_orders.reversed);

  void addOrder(OrderHistoryEntry order) {
    _orders.add(order);
    notifyListeners();
  }

  void clearHistory() {
    _orders.clear();
    notifyListeners();
  }
}
