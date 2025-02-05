class TransactionModel {
  final int id;
  final String status;
  final String address;
  final int totalPrice;
  final int shippingPrice;
  final int created_at;

  TransactionModel({
    required this.id,
    required this.status,
    required this.address,
    required this.totalPrice,
    required this.shippingPrice,
    required this.created_at
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      status: json['status'],
      address: json['address'],
      totalPrice: json['total_price'],
      shippingPrice: json['shipping_price'],
      created_at: json['created_at']
    );
  }

  static List<TransactionModel> fromJsonList(List<dynamic> list) {
    return list.map((item) => TransactionModel.fromJson(item)).toList();
  }
}
