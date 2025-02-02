
import 'package:intl/intl.dart';

class Helper {
// Fungsi untuk mengonversi angka ke format Rupiah
  String formatRupiah(int number) {
    final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatCurrency.format(number);
  }
}