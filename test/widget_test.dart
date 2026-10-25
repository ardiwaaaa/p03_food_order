import 'package:flutter_test/flutter_test.dart';
import 'package:p03_food_order/main.dart';

void main() {
  testWidgets('Aplikasi Food Order tampil', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodOrderApp());

    expect(find.text('Food Order'), findsOneWidget);
    expect(find.text('Pilih Menu Favoritmu'), findsOneWidget);
  });
}
