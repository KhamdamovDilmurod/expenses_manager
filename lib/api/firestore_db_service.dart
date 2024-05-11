import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_manager/model/chiqim_turi_model.dart';
import 'package:expenses_manager/model/employee_model.dart';
import 'package:expenses_manager/model/expense_model.dart';
import 'package:expenses_manager/model/kirim_turi_model.dart';
import 'package:expenses_manager/model/report_model.dart';
import 'package:expenses_manager/model/valyuta_model.dart';

import '../model/todo.dart';
import '../utils/pref_utils.dart';

const String TODO_COLLECTON_REF = "todos";
const String EMPLOYEES_COLLECTON_REF = "employees";
const String EXPENSES_COLLECTON_REF = "kirimChiqim";
const String KIRIM_TYPE_COLLECTON_REF = "kirim_turi";
const String CHIQIM_TYPE_COLLECTION = "chiqim_turi";
const String VALYUTA_TYPE_COLLECTION = "valyuta";

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _todosRef;
  late final CollectionReference _employeesRef;
  late final CollectionReference _expensesRef;

  DatabaseService() {
    _todosRef = _firestore.collection(TODO_COLLECTON_REF).withConverter<Todo>(
        fromFirestore: (snapshots, _) => Todo.fromJson(
              snapshots.data()!,
            ),
        toFirestore: (todo, _) => todo.toJson());

    ///expenses references
    _expensesRef = _firestore.collection(EXPENSES_COLLECTON_REF).withConverter<ExpenseModel>(
        fromFirestore: (snapshots, _) => ExpenseModel.fromJson(
              snapshots.data()!,
            ),
        toFirestore: (todo, _) => todo.toJson());

    /// employee's references
    _employeesRef = _firestore.collection(EMPLOYEES_COLLECTON_REF).withConverter<EmployeeModel>(
        fromFirestore: (snapshots, _) => EmployeeModel.fromJson(
              snapshots.data()!,
            ),
        toFirestore: (employee, _) => employee.toJson());
  }

  Stream<QuerySnapshot> getTodos() {
    return _todosRef.orderBy("createdOn", descending: true).snapshots();
  }

  void addTodo(Todo todo) async {
    _todosRef.add(todo);
  }

  void updateTodo(String todoId, Todo todo) {
    _todosRef.doc(todoId).update(todo.toJson());
  }

  void deleteTodo(String todoId) {
    _todosRef.doc(todoId).delete();
  }

  // employees
  Future<bool> addEmployee(EmployeeModel employee, StreamController<String> errorStream) async {
    try {
      // Get a reference to the 'employees' collection
      CollectionReference employees = FirebaseFirestore.instance.collection(EMPLOYEES_COLLECTON_REF);

      // Add the employee data to Firestore
      await employees.add({
        'name': employee.name,
        'password': employee.password,
        'phoneNumber': employee.phoneNumber,
        'isManager': employee.isManager,
        'createdOn': employee.createdOn,
      });

      print('Employee added successfully!');

      return true;
    } catch (e) {
      errorStream.sink.add("$e");
      print('Error adding employee: $e');
      return false;
      // Handle the error as needed
    }
  }

  Future<bool> updateEmployee(String employeeId, EmployeeModel updatedEmployee, StreamController<String> errorStream) async {
    try {
      // Get a reference to the 'employees' collection
      CollectionReference employees = FirebaseFirestore.instance.collection(EMPLOYEES_COLLECTON_REF);

      // Update the employee data in Firestore
      await employees.doc(employeeId).update({
        'name': updatedEmployee.name,
        'password': updatedEmployee.password,
        'phoneNumber': updatedEmployee.phoneNumber,
        'isManager': updatedEmployee.isManager,
        'createdOn': updatedEmployee.createdOn,
      });
      print('Employee updated successfully!');
      return true;
    } catch (e) {
      errorStream.sink.add("$e");
      print('Error updating employee: $e');
      return false;
      // Handle the error as needed
    }
  }

  Future<bool> deleteEmployee(String employeeId, StreamController<String> errorStream) async {
    try {
      // Get a reference to the 'employees' collection
      CollectionReference employees = FirebaseFirestore.instance.collection(EMPLOYEES_COLLECTON_REF);

      // Delete the employee document from Firestore
      await employees.doc(employeeId).delete();
      print('Employee deleted successfully!');
      return true;
    } catch (e) {
      errorStream.sink.add("$e");
      print('Error deleting employee: $e');
      return false;
      // Handle the error as needed
    }
  }

  Future<List<EmployeeModel>>? getEmployeeList(StreamController<String> errorStream) async {
    List<EmployeeModel> list = [];
    try {
      await FirebaseFirestore.instance
          .collection(EMPLOYEES_COLLECTON_REF)
          .orderBy('createdOn', descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          final item = EmployeeModel(
              id: doc.id.toString(),
              name: doc['name'],
              password: doc["password"],
              phoneNumber: doc["phoneNumber"],
              isManager: doc["isManager"],
              createdOn: doc["createdOn"]);
          list.add(item);
          print("JW - ${item.name}");
        });
      }).catchError((e) {
        print(e.toString());
        errorStream.sink.add("Error fetching employees: $e");
      });
      return list;
    } catch (e) {
      // If an error occurs, add the error message to the error stream

      errorStream.sink.add("Error fetching employees: $e");
      // You can also handle the error further or return null/empty list
      return [];
    }
  }

  Future<EmployeeModel?> getEmployeeByName(String name, StreamController<String> errorStream) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(EMPLOYEES_COLLECTON_REF)
          .where('name', isEqualTo: name)
          .limit(1) // Limit to only one result
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If employee with the given name is found, return its data
        var doc = querySnapshot.docs.first;
        return EmployeeModel(
          id: doc.id.toString(),
          name: doc['name'],
          password: doc["password"],
          phoneNumber: doc["phoneNumber"],
          isManager: doc["isManager"],
          createdOn: doc["createdOn"],
        );
      } else {
        // If no employee found with the given name, return null
        return null;
      }
    } catch (e) {
      errorStream.sink.add("Error fetching employees: $e");
      print('Error fetching employee: $e');
      return null;
    }
  }

  /// xodimlar
  Future<bool> addExpense(ExpenseModel expense, StreamController<String> errorStream) async {
    try {
      // Get a reference to the 'expenses' collection
      CollectionReference expenses = FirebaseFirestore.instance.collection(EXPENSES_COLLECTON_REF);

      // Add the expenses data to Firestore
      await expenses.add(expense.toJson());

      print('expenses added successfully!');

      return true;
    } catch (e) {
      errorStream.sink.add("$e");

      print('Error adding expenses: $e');

      return false;
      // Handle the error as needed
    }
  }

  Future<List<ExpenseModel>>? getExpenses(StreamController<String> errorStream) async {
    List<ExpenseModel> list = [];
    try {
      await FirebaseFirestore.instance
          .collection(EXPENSES_COLLECTON_REF)
          .orderBy('createdOn', descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          final item = ExpenseModel(
            id: doc.id.toString(),
            summa: doc['summa'],
            createdOn: doc['createdOn'],
            employeeId: doc['employeeId'],
            employeeName: doc['employeeName'],
            employeePhoneNumber: doc['employeePhoneNumber'],
            isDollar: doc['isDollar'],
            isExpense: doc['isExpense'],
            typeOfExpenseId: doc['typeOfExpenseId'],
            typeOfExpenseName: doc['typeOfExpenseName'],
            valyutaId: doc['valyutaId'],
            valyutaName: doc['valyutaName'],
            comment: doc['comment'],
          );
          list.add(item);
          print("JW - ${item.comment}");
        });
      }).catchError((e) {
        print(e.toString());
        errorStream.sink.add("Error fetching employees: $e");
      });
      return list;
    } catch (e) {
      // If an error occurs, add the error message to the error stream

      errorStream.sink.add("Error fetching employees: $e");
      // You can also handle the error further or return null/empty list
      return [];
    }
  }

  Future<List<ExpenseModel>>? getUserChiqimlar(StreamController<String> errorStream) async {
    List<ExpenseModel> list = [];
    try {
      await FirebaseFirestore.instance
          .collection(EXPENSES_COLLECTON_REF)
          .where('employeeId', isEqualTo: PrefUtils.getEmployee()?.id)
          .orderBy('createdOn', descending: true)
          .where('isExpense', isEqualTo: true)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          final item = ExpenseModel(
            id: doc.id.toString(),
            summa: doc['summa'],
            createdOn: doc['createdOn'],
            employeeId: doc['employeeId'],
            employeeName: doc['employeeName'],
            employeePhoneNumber: doc['employeePhoneNumber'],
            isDollar: doc['isDollar'],
            isExpense: doc['isExpense'],
            typeOfExpenseId: doc['typeOfExpenseId'],
            typeOfExpenseName: doc['typeOfExpenseName'],
            valyutaId: doc['valyutaId'],
            valyutaName: doc['valyutaName'],
            comment: doc['comment'],
          );
          list.add(item);
          print("JW - ${item.comment}");
        });
      }).catchError((e) {
        print(e.toString());
        errorStream.sink.add("Error fetching employees: $e");
      });
      return list;
    } catch (e) {
      // If an error occurs, add the error message to the error stream

      errorStream.sink.add("Error fetching employees: $e");
      // You can also handle the error further or return null/empty list
      return [];
    }
  }

  Future<List<ExpenseModel>>? getManagerChiqimlar(StreamController<String> errorStream) async {
    List<ExpenseModel> list = [];
    try {
      await FirebaseFirestore.instance
          .collection(EXPENSES_COLLECTON_REF)
          .orderBy('createdOn', descending: true)
          .where('isExpense', isEqualTo: true)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          final item = ExpenseModel(
            id: doc.id.toString(),
            summa: doc['summa'],
            createdOn: doc['createdOn'],
            employeeId: doc['employeeId'],
            employeeName: doc['employeeName'],
            employeePhoneNumber: doc['employeePhoneNumber'],
            isDollar: doc['isDollar'],
            isExpense: doc['isExpense'],
            typeOfExpenseId: doc['typeOfExpenseId'],
            typeOfExpenseName: doc['typeOfExpenseName'],
            valyutaId: doc['valyutaId'],
            valyutaName: doc['valyutaName'],
            comment: doc['comment'],
          );
          list.add(item);
          print("JW - ${item.comment}");
        });
      }).catchError((e) {
        print(e.toString());
        errorStream.sink.add("Error fetching employees: $e");
      });
      return list;
    } catch (e) {
      // If an error occurs, add the error message to the error stream

      errorStream.sink.add("Error fetching employees: $e");
      // You can also handle the error further or return null/empty list
      return [];
    }
  }

  Future<List<ExpenseModel>>? getUserKirimlar(StreamController<String> errorStream) async {
    List<ExpenseModel> list = [];
    try {
      await FirebaseFirestore.instance
          .collection(EXPENSES_COLLECTON_REF)
          .where('employeeId', isEqualTo: PrefUtils.getEmployee()?.id)
          .where('isExpense', isEqualTo: false)
          .orderBy('createdOn', descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          final item = ExpenseModel(
            id: doc.id.toString(),
            summa: doc['summa'],
            createdOn: doc['createdOn'],
            employeeId: doc['employeeId'],
            employeeName: doc['employeeName'],
            employeePhoneNumber: doc['employeePhoneNumber'],
            isDollar: doc['isDollar'],
            isExpense: doc['isExpense'],
            typeOfExpenseId: doc['typeOfExpenseId'],
            typeOfExpenseName: doc['typeOfExpenseName'],
            valyutaId: doc['valyutaId'],
            valyutaName: doc['valyutaName'],
            comment: doc['comment'],
          );
          list.add(item);
          print("JW - ID: ${item.id} - ${item.typeOfExpenseName}");
        });
      }).catchError((e) {
        print(e.toString());
        errorStream.sink.add("EJW -rror fetching employees: $e");
      });
      return list;
    } catch (e) {
      // If an error occurs, add the error message to the error stream

      errorStream.sink.add("Error fetching employees: $e");
      // You can also handle the error further or return null/empty list
      return [];
    }
  }

  Future<List<ExpenseModel>>? getManagerKirimlar(StreamController<String> errorStream) async {
    List<ExpenseModel> list = [];
    try {
      await FirebaseFirestore.instance
          .collection(EXPENSES_COLLECTON_REF)
          .where('isExpense', isEqualTo: false)
          .orderBy('createdOn', descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          final item = ExpenseModel(
            id: doc.id.toString(),
            summa: doc['summa'],
            createdOn: doc['createdOn'],
            employeeId: doc['employeeId'],
            employeeName: doc['employeeName'],
            employeePhoneNumber: doc['employeePhoneNumber'],
            isDollar: doc['isDollar'],
            isExpense: doc['isExpense'],
            typeOfExpenseId: doc['typeOfExpenseId'],
            typeOfExpenseName: doc['typeOfExpenseName'],
            valyutaId: doc['valyutaId'],
            valyutaName: doc['valyutaName'],
            comment: doc['comment'],
          );
          list.add(item);
          print("JW - ID: ${item.id} - ${item.typeOfExpenseName}");
        });
      }).catchError((e) {
        print(e.toString());
        errorStream.sink.add("EJW -rror fetching employees: $e");
      });
      return list;
    } catch (e) {
      // If an error occurs, add the error message to the error stream

      errorStream.sink.add("Error fetching employees: $e");
      // You can also handle the error further or return null/empty list
      return [];
    }
  }

  /// for managers

  /// kirim turi
  // kirim turi
  Future<bool> addKirimTuri(KirimTuriModel kirimTuri, StreamController<String> errorStream) async {
    try {
      // Get a reference to the 'employees' collection
      CollectionReference kirimTurlari = FirebaseFirestore.instance.collection(KIRIM_TYPE_COLLECTON_REF);

      // Add the employee data to Firestore
      await kirimTurlari.add({
        'name': kirimTuri.name,
        'createdOn': kirimTuri.createdOn,
      });

      print('Kirim turi added successfully!');

      return true;
    } catch (e) {
      errorStream.sink.add("$e");
      print('Error adding employee: $e');
      return false;
      // Handle the error as needed
    }
  }

  Future<bool> updateKirimTuri(String id, KirimTuriModel kirimTuri, StreamController<String> errorStream) async {
    try {
      // Get a reference to the 'employees' collection
      CollectionReference kirimTurlari = FirebaseFirestore.instance.collection(KIRIM_TYPE_COLLECTON_REF);

      // Update the employee data in Firestore
      await kirimTurlari.doc(id).update({
        'name': kirimTuri.name,
      });
      print('Kirim turi updated successfully!');
      return true;
    } catch (e) {
      errorStream.sink.add("$e");
      print('Error updating kirimTurlari: $e');
      return false;
      // Handle the error as needed
    }
  }

  Future<bool> deleteKirimTuri(String id, StreamController<String> errorStream) async {
    try {
      // Get a reference to the 'employees' collection
      CollectionReference kirimTurlari = FirebaseFirestore.instance.collection(KIRIM_TYPE_COLLECTON_REF);

      // Delete the employee document from Firestore
      await kirimTurlari.doc(id).delete();
      print('Employee deleted successfully!');
      return true;
    } catch (e) {
      errorStream.sink.add("$e");
      print('Error deleting employee: $e');
      return false;
      // Handle the error as needed
    }
  }

  Future<List<KirimTuriModel>>? getKirimTurlari(StreamController<String> errorStream) async {
    List<KirimTuriModel> list = [];
    try {
      await FirebaseFirestore.instance
          .collection(KIRIM_TYPE_COLLECTON_REF)
          .orderBy('createdOn', descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          final item = KirimTuriModel(
            id: doc.id.toString(),
            name: doc['name'],
            createdOn: doc['createdOn'],
          );
          list.add(item);
          print("JW - ${item.name}");
        });
      }).catchError((e) {
        print(e.toString());
        errorStream.sink.add("Error fetching employees: $e");
      });
      return list;
    } catch (e) {
      // If an error occurs, add the error message to the error stream

      errorStream.sink.add("Error fetching employees: $e");
      // You can also handle the error further or return null/empty list
      return [];
    }
  }

  Future<KirimTuriModel?> getKirimTuriByName(String name, StreamController<String> errorStream) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(KIRIM_TYPE_COLLECTON_REF)
          .where('name', isEqualTo: name)
          .limit(1) // Limit to only one result
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If employee with the given name is found, return its data
        var doc = querySnapshot.docs.first;
        return KirimTuriModel(
          id: doc.id.toString(),
          name: doc['name'],
          createdOn: doc["createdOn"],
        );
      } else {
        // If no employee found with the given name, return null
        return null;
      }
    } catch (e) {
      errorStream.sink.add("Error fetching employees: $e");
      print('Error fetching employee: $e');
      return null;
    }
  }

  /// chiqim turi
  Future<bool> addChiqimTuri(ChiqimTuriModel item, StreamController<String> errorStream) async {
    try {
      // Get a reference to the 'CHIQIM' collection
      CollectionReference items = FirebaseFirestore.instance.collection(CHIQIM_TYPE_COLLECTION);

      // Add the employee data to Firestore
      await items.add({
        'name': item.name,
        'createdOn': item.createdOn,
      });

      print('Chiqim turi added successfully!');

      return true;
    } catch (e) {
      errorStream.sink.add("$e");
      print('Error adding chiqim: $e');
      return false;
      // Handle the error as needed
    }
  }

  Future<bool> updateChiqimTuri(String id, ChiqimTuriModel item, StreamController<String> errorStream) async {
    try {
      // Get a reference to the 'employees' collection
      CollectionReference items = FirebaseFirestore.instance.collection(CHIQIM_TYPE_COLLECTION);

      // Update the employee data in Firestore
      await items.doc(id).update({
        'name': item.name,
      });
      print('Chiqim turi updated successfully!');
      return true;
    } catch (e) {
      errorStream.sink.add("$e");
      print('Error updating chiqimTurlari: $e');
      return false;
      // Handle the error as needed
    }
  }

  Future<bool> deleteChiqimTuri(String id, StreamController<String> errorStream) async {
    try {
      // Get a reference to the 'employees' collection
      CollectionReference items = FirebaseFirestore.instance.collection(CHIQIM_TYPE_COLLECTION);

      // Delete the employee document from Firestore
      await items.doc(id).delete();
      print('Chiqim turi deleted successfully!');
      return true;
    } catch (e) {
      errorStream.sink.add("$e");
      print('Error deleting chiqim turi: $e');
      return false;
      // Handle the error as needed
    }
  }

  Future<List<ChiqimTuriModel>>? getChiqimTurlari(StreamController<String> errorStream) async {
    List<ChiqimTuriModel> list = [];
    try {
      await FirebaseFirestore.instance
          .collection(CHIQIM_TYPE_COLLECTION)
          .orderBy('createdOn', descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          final item = ChiqimTuriModel(
            id: doc.id.toString(),
            name: doc['name'],
            createdOn: doc['createdOn'],
          );
          list.add(item);
          print("JW - ${item.name}");
        });
      }).catchError((e) {
        print(e.toString());
        errorStream.sink.add("Error fetching employees: $e");
      });
      return list;
    } catch (e) {
      // If an error occurs, add the error message to the error stream

      errorStream.sink.add("Error fetching employees: $e");
      // You can also handle the error further or return null/empty list
      return [];
    }
  }

  Future<ChiqimTuriModel?> getChiqimTuriByName(String name, StreamController<String> errorStream) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(CHIQIM_TYPE_COLLECTION)
          .where('name', isEqualTo: name)
          .limit(1) // Limit to only one result
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If employee with the given name is found, return its data
        var doc = querySnapshot.docs.first;
        return ChiqimTuriModel(
          id: doc.id.toString(),
          name: doc['name'],
          createdOn: doc["createdOn"],
        );
      } else {
        // If no employee found with the given name, return null
        return null;
      }
    } catch (e) {
      errorStream.sink.add("Error fetching chiqim: $e");
      print('Error fetching chiqim: $e');
      return null;
    }
  }

  /// valyuta turi
  Future<bool> addValyutaTuri(ValyutaModel item, StreamController<String> errorStream) async {
    try {
      // Get a reference to the 'CHIQIM' collection
      CollectionReference items = FirebaseFirestore.instance.collection(VALYUTA_TYPE_COLLECTION);

      // Add the employee data to Firestore
      await items.add({
        'name': item.name,
        'createdOn': item.createdOn,
      });

      print('Valyuta turi added successfully!');

      return true;
    } catch (e) {
      errorStream.sink.add("$e");
      print('Error adding valyuta: $e');
      return false;
      // Handle the error as needed
    }
  }

  Future<bool> updateValyutaTuri(String id, ValyutaModel item, StreamController<String> errorStream) async {
    try {
      // Get a reference to the 'employees' collection
      CollectionReference items = FirebaseFirestore.instance.collection(VALYUTA_TYPE_COLLECTION);

      // Update the employee data in Firestore
      await items.doc(id).update({
        'name': item.name,
      });
      print('Valyuta turi updated successfully!');
      return true;
    } catch (e) {
      errorStream.sink.add("$e");
      print('Error updating Valyuta: $e');
      return false;
      // Handle the error as needed
    }
  }

  Future<bool> deleteValyutaTuri(String id, StreamController<String> errorStream) async {
    try {
      // Get a reference to the 'employees' collection
      CollectionReference items = FirebaseFirestore.instance.collection(VALYUTA_TYPE_COLLECTION);

      // Delete the employee document from Firestore
      await items.doc(id).delete();
      print('Valyuta turi deleted successfully!');
      return true;
    } catch (e) {
      errorStream.sink.add("$e");
      print('Error deleting chiqim turi: $e');
      return false;
      // Handle the error as needed
    }
  }

  Future<List<ValyutaModel>>? getValyutaTurlari(StreamController<String> errorStream) async {
    List<ValyutaModel> list = [];
    try {
      await FirebaseFirestore.instance
          .collection(VALYUTA_TYPE_COLLECTION)
          .orderBy('createdOn', descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          final item = ValyutaModel(
            id: doc.id.toString(),
            name: doc['name'],
            createdOn: doc['createdOn'],
          );
          list.add(item);
          print("JW - ${item.name}");
        });
      }).catchError((e) {
        print(e.toString());
        errorStream.sink.add("Error fetching valyuta: $e");
      });
      return list;
    } catch (e) {
      // If an error occurs, add the error message to the error stream

      errorStream.sink.add("Error fetching valyuta: $e");
      // You can also handle the error further or return null/empty list
      return [];
    }
  }

  Future<ValyutaModel?> getValyutaTuriByName(String name, StreamController<String> errorStream) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(VALYUTA_TYPE_COLLECTION)
          .where('name', isEqualTo: name)
          .limit(1) // Limit to only one result
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If employee with the given name is found, return its data
        var doc = querySnapshot.docs.first;
        return ValyutaModel(
          id: doc.id.toString(),
          name: doc['name'],
          createdOn: doc["createdOn"],
        );
      } else {
        // If no employee found with the given name, return null
        return null;
      }
    } catch (e) {
      errorStream.sink.add("Error fetching valyuta: $e");
      print('Error fetching chiqim: $e');
      return null;
    }
  }

  /// reports
  // Future<DailyReportModel?>? getDailyReports(bool isDay, bool isMonth, bool isYear,DateTime start, DateTime end,StreamController<String> errorStream) async {
  //   DailyReportModel? report;
  //   List<ExpenseModel> list = [];
  //
  //   double dollar = 0;
  //   double sum = 0;
  //   double jamiKirimDollar = 0;
  //   double jamiKirimSum = 0;
  //   double jamiChiqimDollar = 0;
  //   double jamiChiqimSum = 0;
  //
  //   // Get current date
  //   DateTime now = DateTime.now();
  //   DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
  //   DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
  //
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection(EXPENSES_COLLECTON_REF)
  //         .where('createdOn', isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
  //         .where('createdOn', isLessThanOrEqualTo: Timestamp.fromDate(lastDayOfMonth))
  //         .orderBy('createdOn', descending: true)
  //         .get()
  //         .then((QuerySnapshot querySnapshot) {
  //       querySnapshot.docs.forEach((doc) {
  //         final item = ExpenseModel(
  //           id: doc.id.toString(),
  //           summa: doc['summa'],
  //           createdOn: doc['createdOn'],
  //           employeeId: doc['employeeId'],
  //           employeeName: doc['employeeName'],
  //           employeePhoneNumber: doc['employeePhoneNumber'],
  //           isDollar: doc['isDollar'],
  //           isExpense: doc['isExpense'],
  //           typeOfExpenseId: doc['typeOfExpenseId'],
  //           typeOfExpenseName: doc['typeOfExpenseName'],
  //           valyutaId: doc['valyutaId'],
  //           valyutaName: doc['valyutaName'],
  //           comment: doc['comment'],
  //         );
  //         if (item.isExpense) {
  //           if (item.isDollar) {
  //             jamiChiqimDollar += item.summa;
  //           } else {
  //             jamiChiqimSum += item.summa;
  //           }
  //         } else {
  //           if (item.isDollar) {
  //             jamiKirimDollar += item.summa;
  //           } else {
  //             jamiKirimSum += item.summa;
  //           }
  //         }
  //         list.add(item);
  //         print("JW - ${item.id} - ${item.createdOn}");
  //       });
  //     }).catchError((e) {
  //       print(e.toString());
  //       errorStream.sink.add("Error fetching valyuta: $e");
  //     });
  //     return DailyReportModel(
  //         date: '',
  //         dollar: dollar,
  //         sum: sum,
  //         item: list,
  //         jamiChiqimDollar: jamiChiqimDollar,
  //         jamiChiqimSum: jamiChiqimSum,
  //         jamiKirimDollar: jamiKirimDollar,
  //         jamiKirimSum: jamiKirimSum);
  //   } catch (e) {
  //     // If an error occurs, add the error message to the error stream
  //
  //     errorStream.sink.add("Error fetching valyuta: $e");
  //     // You can also handle the error further or return null/empty list
  //     return report;
  //   }
  // }


  /// reports
  Future<DailyReportModel?>? getDailyReports(DateTime start, StreamController<String> errorStream) async {
    DailyReportModel? report;
    List<ExpenseModel> list = [];

    double dollar = 0;
    double sum = 0;
    double jamiKirimDollar = 0;
    double jamiKirimSum = 0;
    double jamiChiqimDollar = 0;
    double jamiChiqimSum = 0;

    try {
      await FirebaseFirestore.instance
          .collection(EXPENSES_COLLECTON_REF)
          .where('createdOn', isEqualTo: Timestamp.fromDate(start))
          .orderBy('createdOn', descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          final item = ExpenseModel(
            id: doc.id.toString(),
            summa: doc['summa'],
            createdOn: doc['createdOn'],
            employeeId: doc['employeeId'],
            employeeName: doc['employeeName'],
            employeePhoneNumber: doc['employeePhoneNumber'],
            isDollar: doc['isDollar'],
            isExpense: doc['isExpense'],
            typeOfExpenseId: doc['typeOfExpenseId'],
            typeOfExpenseName: doc['typeOfExpenseName'],
            valyutaId: doc['valyutaId'],
            valyutaName: doc['valyutaName'],
            comment: doc['comment'],
          );
          if (item.isExpense) {
            if (item.isDollar) {
              jamiChiqimDollar += item.summa;
            } else {
              jamiChiqimSum += item.summa;
            }
          } else {
            if (item.isDollar) {
              jamiKirimDollar += item.summa;
            } else {
              jamiKirimSum += item.summa;
            }
          }
          list.add(item);
          print("JW - ${item.id} - ${item.createdOn}");
        });
      }).catchError((e) {
        print(e.toString());
        errorStream.sink.add("Error fetching valyuta: $e");
      });
      return DailyReportModel(
          date: '',
          dollar: dollar,
          sum: sum,
          item: list,
          jamiChiqimDollar: jamiChiqimDollar,
          jamiChiqimSum: jamiChiqimSum,
          jamiKirimDollar: jamiKirimDollar,
          jamiKirimSum: jamiKirimSum);
    } catch (e) {
      // If an error occurs, add the error message to the error stream

      errorStream.sink.add("Error fetching valyuta: $e");
      // You can also handle the error further or return null/empty list
      return report;
    }
  }
  Future<DailyReportModel?>? getMonthlyReports(DateTime start,StreamController<String> errorStream) async {
    DailyReportModel? report;
    List<ExpenseModel> list = [];

    double dollar = 0;
    double sum = 0;
    double jamiKirimDollar = 0;
    double jamiKirimSum = 0;
    double jamiChiqimDollar = 0;
    double jamiChiqimSum = 0;

    try {
      await FirebaseFirestore.instance
          .collection(EXPENSES_COLLECTON_REF)
          .where('createdOn', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(start.year, start.month, 1)))
          .where('createdOn', isLessThanOrEqualTo: Timestamp.fromDate(DateTime(start.year, start.month+1, 0)))
          .orderBy('createdOn', descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          final item = ExpenseModel(
            id: doc.id.toString(),
            summa: doc['summa'],
            createdOn: doc['createdOn'],
            employeeId: doc['employeeId'],
            employeeName: doc['employeeName'],
            employeePhoneNumber: doc['employeePhoneNumber'],
            isDollar: doc['isDollar'],
            isExpense: doc['isExpense'],
            typeOfExpenseId: doc['typeOfExpenseId'],
            typeOfExpenseName: doc['typeOfExpenseName'],
            valyutaId: doc['valyutaId'],
            valyutaName: doc['valyutaName'],
            comment: doc['comment'],
          );
          if (item.isExpense) {
            if (item.isDollar) {
              jamiChiqimDollar += item.summa;
            } else {
              jamiChiqimSum += item.summa;
            }
          } else {
            if (item.isDollar) {
              jamiKirimDollar += item.summa;
            } else {
              jamiKirimSum += item.summa;
            }
          }
          list.add(item);
          print("JW - ${item.id} - ${item.createdOn}");
        });
      }).catchError((e) {
        print(e.toString());
        errorStream.sink.add("Error fetching valyuta: $e");
      });
      return DailyReportModel(
          date: '',
          dollar: dollar,
          sum: sum,
          item: list,
          jamiChiqimDollar: jamiChiqimDollar,
          jamiChiqimSum: jamiChiqimSum,
          jamiKirimDollar: jamiKirimDollar,
          jamiKirimSum: jamiKirimSum);
    } catch (e) {
      // If an error occurs, add the error message to the error stream

      errorStream.sink.add("Error fetching valyuta: $e");
      // You can also handle the error further or return null/empty list
      return report;
    }
  }
  Future<DailyReportModel?>? getYearlyReports(DateTime start,StreamController<String> errorStream) async {
    DailyReportModel? report;
    List<ExpenseModel> list = [];

    double dollar = 0;
    double sum = 0;
    double jamiKirimDollar = 0;
    double jamiKirimSum = 0;
    double jamiChiqimDollar = 0;
    double jamiChiqimSum = 0;

    try {
      await FirebaseFirestore.instance
          .collection(EXPENSES_COLLECTON_REF)
          .where('createdOn', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(start.year, 1, 1)))
          .where('createdOn', isLessThanOrEqualTo: Timestamp.fromDate(DateTime(start.year, 12, 31)))
          .orderBy('createdOn', descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          final item = ExpenseModel(
            id: doc.id.toString(),
            summa: doc['summa'],
            createdOn: doc['createdOn'],
            employeeId: doc['employeeId'],
            employeeName: doc['employeeName'],
            employeePhoneNumber: doc['employeePhoneNumber'],
            isDollar: doc['isDollar'],
            isExpense: doc['isExpense'],
            typeOfExpenseId: doc['typeOfExpenseId'],
            typeOfExpenseName: doc['typeOfExpenseName'],
            valyutaId: doc['valyutaId'],
            valyutaName: doc['valyutaName'],
            comment: doc['comment'],
          );
          if (item.isExpense) {
            if (item.isDollar) {
              jamiChiqimDollar += item.summa;
            } else {
              jamiChiqimSum += item.summa;
            }
          } else {
            if (item.isDollar) {
              jamiKirimDollar += item.summa;
            } else {
              jamiKirimSum += item.summa;
            }
          }
          list.add(item);
          print("JW - ${item.id} - ${item.createdOn}");
        });
      }).catchError((e) {
        print(e.toString());
        errorStream.sink.add("Error fetching valyuta: $e");
      });
      return DailyReportModel(
          date: '',
          dollar: dollar,
          sum: sum,
          item: list,
          jamiChiqimDollar: jamiChiqimDollar,
          jamiChiqimSum: jamiChiqimSum,
          jamiKirimDollar: jamiKirimDollar,
          jamiKirimSum: jamiKirimSum);
    } catch (e) {
      // If an error occurs, add the error message to the error stream

      errorStream.sink.add("Error fetching valyuta: $e");
      // You can also handle the error further or return null/empty list
      return report;
    }
  }
}
