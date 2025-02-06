class TransactionModel {
  final dynamic id;
  final dynamic status;
  final dynamic address;
  final dynamic totalPrice;
  final dynamic shippingPrice;
  final dynamic created_at;

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
