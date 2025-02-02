class TransactionModel {
  final String type;
  final DateTime date;
  final double amount;
  final String category;
  final String account;
  final String description;

  TransactionModel({
    required this.type,
    required this.date,
    required this.amount,
    required this.category,
    required this.account,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'date': date.toIso8601String(),
        'amount': amount,
        'category': category,
        'account': account,
        'description': description,
      };

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      type: json['type'],
      date: DateTime.parse(json['date']),
      amount: (json['amount'] as num).toDouble(),
      category: json['category'],
      account: json['account'],
      description: json['description'],
    );
  }
}
