class ElectricityBill {

  int? id;
  String consumerNumber;
  String consumerName;
  String billMonth;
  int unitsConsumed;
  double billAmount;
  String dueDate;
  bool paid;

  ElectricityBill({
    this.id,
    required this.consumerNumber,
    required this.consumerName,
    required this.billMonth,
    required this.unitsConsumed,
    required this.billAmount,
    required this.dueDate,
    this.paid = false,
  });

  // Convert object into a Map
  Map<String, dynamic> toMap() {

    return {
      'id': id,
      'consumerNumber': consumerNumber,
      'consumerName': consumerName,
      'billMonth': billMonth,
      'unitsConsumed': unitsConsumed,
      'billAmount': billAmount,
      'dueDate': dueDate,
      'paid': paid ? 1 : 0,
    };

  }

  factory ElectricityBill.fromMap(Map<String, dynamic> map) {

    return ElectricityBill(
      id: map['id'],
      consumerNumber: map['consumerNumber'],
      consumerName: map['consumerName'],
      billMonth: map['billMonth'],
      unitsConsumed: map['unitsConsumed'],
      billAmount: map['billAmount'],
      dueDate: map['dueDate'],
      paid: map['paid'] == 1,
    );

  }

}