import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  String id;
  int summa;
  Timestamp createdOn;
  String employeeId;
  String employeeName;
  String employeePhoneNumber;
  bool isDollar;
  bool isExpense;
  String typeOfExpenseId;
  String typeOfExpenseName;
  String valyutaId;
  String valyutaName;
  String comment;

  ExpenseModel({
    required this.id,
    required this.summa,
    required this.createdOn,
    required this.employeeId,
    required this.employeeName,
    required this.employeePhoneNumber,
    required this.isDollar,
    required this.isExpense,
    required this.typeOfExpenseId,
    required this.typeOfExpenseName,
    required this.valyutaId,
    required this.valyutaName,
    required this.comment,
  });

  ExpenseModel.fromJson(Map<String, dynamic> json)
      : createdOn = json['createdOn'] as Timestamp,
        id = json['id'] as String,
        summa = json['summa'] as int,
        employeeId = json['employeeId'] as String,
        employeeName = json['employeeName'] as String,
        employeePhoneNumber = json['employeePhoneNumber'] as String,
        isDollar = json['isDollar'] as bool,
        isExpense = json['isExpense'] as bool,
        typeOfExpenseId = json['typeOfExpenseId'] as String,
        typeOfExpenseName = json['typeOfExpenseName'] as String,
        valyutaId = json['valyutaId'] as String,
        valyutaName = json['valyutaName'] as String,
        comment = json['comment'] as String;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'summa': summa,
      'createdOn': createdOn,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'employeePhoneNumber': employeePhoneNumber,
      'isDollar': isDollar,
      'isExpense': isExpense,
      'typeOfExpenseId': typeOfExpenseId,
      'typeOfExpenseName': typeOfExpenseName,
      'valyutaId': valyutaId,
      'valyutaName': valyutaName,
      'comment': comment,
    };
  }

  ExpenseModel copyWith({
    String? id,
    int? summa,
    Timestamp? createdOn,
    String? employeeId,
    String? employeeName,
    String? employeePhoneNumber,
    bool? isDollar,
    bool? isExpense,
    String? typeOfExpenseId,
    String? typeOfExpenseName,
    String? valyutaId,
    String? valyutaName,
    String? comment,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      summa: summa ?? this.summa,
      createdOn: createdOn ?? this.createdOn,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      employeePhoneNumber: employeePhoneNumber ?? this.employeePhoneNumber,
      isDollar: isDollar ?? this.isDollar,
      isExpense: isExpense ?? this.isExpense,
      typeOfExpenseId: typeOfExpenseId ?? this.typeOfExpenseId,
      typeOfExpenseName: typeOfExpenseName ?? this.typeOfExpenseName,
      valyutaId: valyutaId ?? this.valyutaId,
      valyutaName: valyutaName ?? this.valyutaName,
      comment: comment ?? this.comment,
    );
  }
}
