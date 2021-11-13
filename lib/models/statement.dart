class Statment {
  String itemName;
  int quantity;
  double unitPrice;

  Statment({
    required this.itemName,
    required this.quantity,
    required this.unitPrice,
  });

  Map<String, Object?> toJSON() {
    return {
      "Item": itemName,
      "Quantity": quantity,
      "Price": unitPrice,
    };
  }

  static Statment fromMapObject(Map<String, Object?> billDataMap) {
    return Statment(
      itemName: billDataMap['Item'] as String,
      quantity: billDataMap['Quantity'] as int,
      unitPrice: billDataMap['Price'] as double,
    );
  }
}
