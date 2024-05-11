import 'expense_model.dart'; // Assuming ExpenseModel is defined in a separate file

class DailyReportModel {
  final String date;
  final double sum;
  final double dollar;
  final List<ExpenseModel> item;
  final double jamiKirimDollar;
  final double jamiKirimSum;
  final double jamiChiqimDollar;
  final double jamiChiqimSum;

  DailyReportModel({
    required this.date,
    required this.sum,
    required this.dollar,
    required this.item,
    required this.jamiKirimDollar,
    required this.jamiKirimSum,
    required this.jamiChiqimDollar,
    required this.jamiChiqimSum,
  });

  DailyReportModel.fromJson(Map<String, dynamic> json)
      : date = json['date'] as String,
        sum = json['sum'] as double,
        dollar = json['dollar'] as double,
        jamiKirimDollar = json['jamiKirimDollar'] as double,
        jamiKirimSum = json['jamiKirimSum'] as double,
        jamiChiqimDollar = json['jamiChiqimDollar'] as double,
        jamiChiqimSum = json['jamiChiqimSum'] as double,
        item = (json['item'] as List<dynamic>)
            .map((e) => ExpenseModel.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
    'date': date,
    'sum': sum,
    'dollar': dollar,
    'jamiKirimDollar': jamiKirimDollar,
    'jamiKirimSum': jamiKirimSum,
    'jamiChiqimDollar': jamiChiqimDollar,
    'jamiChiqimSum': jamiChiqimSum,
    'item': item.map((e) => e.toJson()).toList(),
  };

  DailyReportModel copyWith({
    String? date,
    double? sum,
    double? dollar,
    List<ExpenseModel>? item,
    double? jamiKirimDollar,
    double? jamiKirimSum,
    double? jamiChiqimDollar,
    double? jamiChiqimSum,
  }) {
    return DailyReportModel(
      date: date ?? this.date,
      sum: sum ?? this.sum,
      dollar: dollar ?? this.dollar,
      item: item ?? this.item,
      jamiKirimDollar: jamiKirimDollar ?? this.jamiKirimDollar,
      jamiKirimSum: jamiKirimSum ?? this.jamiKirimSum,
      jamiChiqimDollar: jamiChiqimDollar ?? this.jamiChiqimDollar,
      jamiChiqimSum: jamiChiqimSum ?? this.jamiChiqimSum,
    );
  }
}
