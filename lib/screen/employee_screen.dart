import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_manager/screen/main_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import '../api/firestore_db_service.dart';
import '../model/employee_model.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';

class EmployeeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EmployeeScreenState();
  }
}

class EmployeeScreenState extends State<EmployeeScreen> {

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return ViewModelBuilder<MainViewModel>.reactive(
      viewModelBuilder: () {
        return MainViewModel();
      },
        onViewModelReady: (viewModel) {
          viewModel.fetchEmployees();
          viewModel.errorData.listen((event) {
            showError(context, event);
          });

          viewModel.addedEmployeeData.listen((event) {
            if (event) {
              viewModel.fetchEmployees();
            }
          });

          viewModel.updatedEmployeeData.listen((event) {
            if (event) {
              viewModel.fetchEmployees();
            }
          });

          viewModel.deletedEmployeeData.listen((event) {
            if (event) {
              viewModel.fetchEmployees();
            }
          });

        },
      builder: (BuildContext context, MainViewModel viewModel, Widget? child){
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: COLOR_PRIMARY,
            iconTheme: IconThemeData(color: WHITE),
            title: Text("Xodimlar", style: TextStyle(fontFamily: 'bold', color: WHITE, fontSize: 24),),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.vertical,
                        itemCount: viewModel.employees.length,
                        itemBuilder: (_, position) {
                          var item = viewModel.employees[position];
                          print('JW - ${item.name}');
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            child: ListTile(
                              tileColor: Theme.of(context).colorScheme.primaryContainer,
                              title: Text(item.name),
                              subtitle: Text(
                                DateFormat("dd-MM-yyyy h:mm a").format(
                                  item.createdOn.toDate(),
                                ),
                              ),
                              trailing: Checkbox(
                                value: item.isManager,
                                onChanged: (value) {
                                  // EmployeeModel employeeUd = employee.copyWith(isDone: !employee.isDone, updatedOn: Timestamp.now());
                                  // _databaseService.updateTodo(id, employeeUd);
                                },
                              ),
                              onLongPress: () {
                                viewModel.deleteEmployee(item.id);
                              },
                            ),
                          );
                        }),
                  ],
                ),
              ),
              if (viewModel.progressData) showAsProgress(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async{
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Add an employee'),
                    content: TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(hintText: "Name...."),
                    ),
                    actions: <Widget>[
                      MaterialButton(
                        color: Theme.of(context).colorScheme.primary,
                        textColor: Colors.white,
                        child: const Text('Ok'),
                        onPressed: () {
                          EmployeeModel employee = EmployeeModel(
                              name: _textEditingController.text, isManager: false, createdOn: Timestamp.now(), password: '123',phoneNumber: '+998991234567', id: '',);
                          viewModel.addEmployee(employee);
                          Navigator.pop(context);
                          _textEditingController.clear();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        );
      }
    );
  }
}
