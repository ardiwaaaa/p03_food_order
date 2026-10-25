# P03 — Food Order Mini App

## Deskripsi Aplikasi

Food Order Mini App adalah aplikasi pemesanan makanan sederhana yang dibuat menggunakan Flutter. Aplikasi ini memiliki tiga layar, yaitu Menu, Detail Pesanan, dan Checkout. Pengguna dapat memilih menu makanan atau minuman, mengubah jumlah pesanan, melihat total harga, dan mengisi formulir pemesanan.

Daftar menu berasal dari data yang dipisahkan dalam file tersendiri. Widget `MenuCard` digunakan kembali untuk menampilkan berbagai menu. `StatefulWidget` dan `setState` digunakan untuk memperbarui jumlah pesanan dan total harga. Form checkout menggunakan validasi untuk menolak input yang kosong.

## Bug yang Ditemukan dan Cara Memperbaikinya

Saat menjalankan `flutter analyze`, saya menemukan error pada `widget_test.dart` karena pengujian masih memanggil kelas `MyApp`, sedangkan aplikasi yang dibuat menggunakan kelas `FoodOrderApp`. Saya menemukan penyebabnya melalui pesan error analyzer, kemudian memperbaiki pemanggilan widget pada file pengujian.

Saya juga menemukan warning bahwa properti `value` pada `DropdownButtonFormField` sudah deprecated. Saya mengikuti petunjuk analyzer dan menggantinya dengan `initialValue`. Setelah perubahan tersebut, `flutter analyze` berhasil dijalankan tanpa issue.

## Cara Menjalankan

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```
