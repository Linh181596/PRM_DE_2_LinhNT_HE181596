class Expense {
  final int? id;
  final String name;
  final double cost;
  final String type;
  final String date;

  Expense({
    this.id,
    required this.name,
    required this.cost,
    required this.type,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': name,
      'amount': cost,
      'category': type,
      'date': date,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      name: (map['name'] ?? map['title'] ?? '') as String,
      cost: ((map['cost'] ?? map['amount'] ?? 0) as num).toDouble(),
      type: (map['type'] ?? map['category'] ?? '') as String,
      date: (map['date'] ?? '') as String,
    );
  }

  Expense copyWith({
    int? id,
    String? name,
    double? cost,
    String? type,
    String? date,
  }) {
    return Expense(
      id: id ?? this.id,
      name: name ?? this.name,
      cost: cost ?? this.cost,
      type: type ?? this.type,
      date: date ?? this.date,
    );
  }
}
