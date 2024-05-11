import 'dart:async';

import 'package:expenses_manager/model/chiqim_turi_model.dart';
import 'package:expenses_manager/model/employee_model.dart';
import 'package:expenses_manager/model/expense_model.dart';
import 'package:expenses_manager/model/kirim_turi_model.dart';
import 'package:expenses_manager/model/report_model.dart';
import 'package:stacked/stacked.dart';

import '../api/firestore_db_service.dart';

class MainViewModel extends BaseViewModel {
  final DatabaseService _databaseService = DatabaseService();
  var progressData = false;

  final StreamController<String> _errorStream = StreamController();

  Stream<String> get errorData {
    return _errorStream.stream;
  }

  StreamController<List<EmployeeModel>> _userListStream = StreamController();

  Stream<List<EmployeeModel>> get userListData {
    return _userListStream.stream;
  }

  StreamController<bool> _addedEmployeeStream = StreamController();

  Stream<bool> get addedEmployeeData {
    return _addedEmployeeStream.stream;
  }

  StreamController<bool> _updatedEmployeeStream = StreamController();

  Stream<bool> get updatedEmployeeData {
    return _updatedEmployeeStream.stream;
  }

  StreamController<bool> _deletedEmployeeStream = StreamController();

  Stream<bool> get deletedEmployeeData {
    return _deletedEmployeeStream.stream;
  }

  StreamController<EmployeeModel?> _loginEmployeeStream = StreamController();

  Stream<EmployeeModel?> get loginEmployeeData {
    return _loginEmployeeStream.stream;
  }
  StreamController<ExpenseModel?> _expensesStream = StreamController();

  Stream<ExpenseModel?> get expensesData {
    return _expensesStream.stream;
  }

  StreamController<bool> _addedExpenseStream = StreamController();

  Stream<bool> get addedExpenseData {
    return _addedExpenseStream.stream;
  }

  List<EmployeeModel> employees = [];
  List<ExpenseModel> expenses = [];
  List<ExpenseModel> chiqimlar = [];
  List<ExpenseModel> kirimlar = [];
  num totalSumma = 0;

  EmployeeModel? employee;

  void fetchEmployees() async {
    progressData = true;
    notifyListeners();
    final data = await _databaseService.getEmployeeList(_errorStream);
    if (data != null) {
      employees = data;
    }
    progressData = false;
    notifyListeners();
  }

  void updateEmployee(String id, EmployeeModel employee) async {
    progressData = true;
    notifyListeners();
    final data = await _databaseService.updateEmployee(id,employee,_errorStream);
    _updatedEmployeeStream.sink.add(data);
    progressData = false;
    notifyListeners();
  }

  void addEmployee(EmployeeModel employee) async {
    progressData = true;
    notifyListeners();
    final data = await _databaseService.addEmployee(employee,_errorStream);
    _addedEmployeeStream.sink.add(data);
    progressData = false;
    notifyListeners();
  }

  void deleteEmployee(String id) async {
    progressData = true;
    notifyListeners();
    final data = await _databaseService.deleteEmployee(id,_errorStream);
    _deletedEmployeeStream.sink.add(data);
    progressData = false;
    notifyListeners();
  }

  void loginEmployee(String name) async {
    progressData = true;
    notifyListeners();
    final data = await _databaseService.getEmployeeByName(name,_errorStream);
    if (data != null) {
      employee = data;
    }
    _loginEmployeeStream.sink.add(data);
    progressData = false;
    notifyListeners();
  }

  void getExpenses() async {
    progressData = true;
    notifyListeners();
    final data = await _databaseService.getExpenses(_errorStream);
    if (data != null) {
      expenses = data;
    }
    progressData = false;
    notifyListeners();
  }
  void getUserChiqimlar() async {
    progressData = true;
    notifyListeners();
    final data = await _databaseService.getUserChiqimlar(_errorStream);
    if (data != null) {
      chiqimlar = data;
    }
    progressData = false;
    notifyListeners();
  }
  void getUserKirimlar() async {
    progressData = true;
    notifyListeners();
    final data = await _databaseService.getUserKirimlar(_errorStream);
    if (data != null) {
      kirimlar = data;
      totalSumma = 0;
      data.forEach((element) {
        totalSumma += element.summa;
      });
    }
    progressData = false;
    notifyListeners();
  }
  void getManagerChiqimlar() async {
    progressData = true;
    notifyListeners();
    final data = await _databaseService.getUserChiqimlar(_errorStream);
    if (data != null) {
      chiqimlar = data;
    }
    progressData = false;
    notifyListeners();
  }
  void getManagerKirimlar() async {
    progressData = true;
    notifyListeners();
    final data = await _databaseService.getManagerKirimlar(_errorStream);
    if (data != null) {
      kirimlar = data;
    }
    progressData = false;
    notifyListeners();
  }

  void addExpense(ExpenseModel expense) async {
    progressData = true;
    notifyListeners();
    final data = await _databaseService.addExpense(expense,_errorStream);
    _addedExpenseStream.sink.add(data);
    progressData = false;
    notifyListeners();
  }

  /// report servics
  /////////////////////////////////////////////////////////////
  StreamController<DailyReportModel> _dailyReportStream = StreamController();

  Stream<DailyReportModel> get dailyReportData {
    return _dailyReportStream.stream;
  }

  DailyReportModel? dailyReport;

  void getDailyReports(DateTime date) async {
    progressData = true;
    notifyListeners();
    final data = await _databaseService.getDailyReports(date,_errorStream);
    if (data != null) {
      dailyReport = data;
      _dailyReportStream.sink.add(data);
    }
    progressData = false;
    notifyListeners();
  }

  void getMonthlyReports(DateTime date) async {
    progressData = true;
    notifyListeners();
    final data = await _databaseService.getMonthlyReports(date,_errorStream);
    if (data != null) {
      dailyReport = data;
      _dailyReportStream.sink.add(data);
    }
    progressData = false;
    notifyListeners();
  }

  void getYearlyReports(DateTime date) async {
    progressData = true;
    notifyListeners();
    final data = await _databaseService.getYearlyReports(date,_errorStream);
    if (data != null) {
      dailyReport = data;
      _dailyReportStream.sink.add(data);
    }
    progressData = false;
    notifyListeners();
  }

  /// kirim turi
  ///////////////////////////////////////////////////////////////

  StreamController<bool> _addedKirimStream = StreamController();

  Stream<bool> get addedKirimData {
    return _addedKirimStream.stream;
  }

  StreamController<bool> _updatedKirimStream = StreamController();

  Stream<bool> get updatedKirimData {
    return _updatedKirimStream.stream;
  }

  StreamController<bool> _deletedKirimStream = StreamController();

  Stream<bool> get deletedKirimData {
    return _deletedKirimStream.stream;
  }

  List<KirimTuriModel> kirimList = [];

  void getKirimTuri() async {
    progressData = true;
    notifyListeners();
    final data = await _databaseService.getKirimTurlari(_errorStream);
    if (data != null) {
      kirimList = data;
    }
    progressData = false;
    notifyListeners();
  }

  void updateKirimTuri(String id, KirimTuriModel kirimTuri) async {
    progressData = true;
    notifyListeners();
    final data = await _databaseService.updateKirimTuri(id,kirimTuri,_errorStream);
    _updatedKirimStream.sink.add(data);
    progressData = false;
    notifyListeners();
  }

  void addKirimTuri(KirimTuriModel kirimTuri) async {
    progressData = true;
    notifyListeners();
    final data = await _databaseService.addKirimTuri(kirimTuri,_errorStream);
    _addedKirimStream.sink.add(data);
    progressData = false;
    notifyListeners();
  }

  void deleteKirimTuri(String id) async {
    progressData = true;
    notifyListeners();
    final data = await _databaseService.deleteKirimTuri(id,_errorStream);
    _deletedKirimStream.sink.add(data);
    progressData = false;
    notifyListeners();
  }

  /// chiqim turi
  ///////////////////////////////////////////////////////////////

  StreamController<bool> _addedChiqimTuriStream = StreamController();

  Stream<bool> get addedChiqimTuriData {
    return _addedChiqimTuriStream.stream;
  }

  StreamController<bool> _updatedChiqimTuriStream = StreamController();

  Stream<bool> get updatedChiqimTuriData {
    return _updatedChiqimTuriStream.stream;
  }

  StreamController<bool> _deletedChiqimTuriStream = StreamController();

  Stream<bool> get deletedChiqimTuriData {
    return _deletedChiqimTuriStream.stream;
  }

  List<ChiqimTuriModel> chiqimTuriList = [];

  void getChiqimTurlariList() async {
    progressData = true;
    notifyListeners();
    final data = await _databaseService.getChiqimTurlari(_errorStream);
    if (data != null) {
      chiqimTuriList = data;
    }
    progressData = false;
    notifyListeners();
  }

  void updateChiqimTuri(String id, ChiqimTuriModel item) async {
    progressData = true;
    notifyListeners();
    final data = await _databaseService.updateChiqimTuri(id,item,_errorStream);
    _updatedChiqimTuriStream.sink.add(data);
    progressData = false;
    notifyListeners();
  }

  void addChiqimTuri(ChiqimTuriModel item) async {
    progressData = true;
    notifyListeners();
    final data = await _databaseService.addChiqimTuri(item,_errorStream);
    _addedChiqimTuriStream.sink.add(data);
    progressData = false;
    notifyListeners();
  }

  void deleteChiqimTuri(String id) async {
    progressData = true;
    notifyListeners();
    final data = await _databaseService.deleteChiqimTuri(id,_errorStream);
    _deletedChiqimTuriStream.sink.add(data);
    progressData = false;
    notifyListeners();
  }

}
