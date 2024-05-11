import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';

import '../../../model/event_model.dart';
import '../../../model/expense_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/constant.dart';
import '../../../utils/event_bus.dart';
import '../../../utils/pref_utils.dart';
import '../../../utils/utils.dart';
import '../../main_viewmodel.dart';

class ChiqimQoshishScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChiqimQoshishScreenState();
  }

}
class ChiqimQoshishScreenState extends State<ChiqimQoshishScreen>{

  final TextEditingController _summController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  var isDollar = false;
  final List<String> currencies = [
    'Dollar',
    'So\'m',
  ];

  String? selectedType;
  String? selectedTypeOfExpense;
  Timestamp? selectedTimestamp;

  TextEditingController _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      cancelText: 'Bekor qilish',
      helpText: 'Kunni belgilang !!',
      context: context,
      initialDate: DateTime.now(),
      // Set the initial date to the current date
      firstDate: DateTime(2023),
      // Set the first date that can be picked
      lastDate: DateTime(2028), // Set the last date that can be picked
    );
    if (picked != null) {
      _dateController.text = picked.toString().split(' ')[0];
      // Parse the selected date into a Timestamp
      selectedTimestamp = Timestamp.fromDate(picked);
      // Now you can use 'selectedTimestamp' as needed // Update the text field with the selected date
    }
  }

  @override
  void dispose() {
    _dateController.dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(viewModelBuilder: () {
      return MainViewModel();
    }, onViewModelReady: (viewModel) {
      viewModel.getChiqimTurlariList();
      viewModel.errorData.listen((event) {
        showError(context, event);
      });
      viewModel.addedExpenseData.listen((event) {
        if(event){
          print("JW-$event");
          showSuccess(context, 'Muvaffaqiyatliy yuborildi!!', pressOk: (){
            eventBus.fire(EventModel(event: EVENT_DATA, data: 0));
            Navigator.pop(context);
          });
        } else {
          showWarning(context, "xatolik");
        }
      });

    }, builder: (BuildContext context, MainViewModel viewModel, Widget? child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: COLOR_PRIMARY,
          iconTheme: IconThemeData(color: WHITE),
          title: Text(
            "Chiqim",
            style: TextStyle(fontFamily: 'bold', color: WHITE, fontSize: 24),
          ),
        ),
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12.0, top: 20, bottom: 8),
                      child: Text(
                        "Chiqim turini belgilang",
                        style: TextStyle(fontFamily: 'bold', color: BLACK, fontSize: 14),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: DropdownButtonFormField2<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          // Add Horizontal padding using menuItemStyleData.padding so it matches
                          // the menu padding when button's width is not specified.
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // Add more decoration..
                        ),
                        hint: Text(
                          viewModel.chiqimTuriList.isNotEmpty ?
                        'Chiqim turini belgilang': 'Avval chiqim turi kiritilsin !!',
                          style: TextStyle(fontSize: 14),
                        ) ,
                        items: viewModel.chiqimTuriList
                            .map((item) => DropdownMenuItem<String>(
                          value: item.name,
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                            .toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Iltimos chiqim turini belgilang.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          //Do something when selected item is changed.
                        },
                        onSaved: (value) {
                          selectedTypeOfExpense = value.toString();
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.only(right: 8),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 24,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 12, bottom: 8),
                      child: Text(
                        "Valyutani belgilang",
                        style: TextStyle(fontFamily: 'bold', color: BLACK, fontSize: 14),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: DropdownButtonFormField2<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          // Add Horizontal padding using menuItemStyleData.padding so it matches
                          // the menu padding when button's width is not specified.
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // Add more decoration..
                        ),
                        hint: const Text(
                          'Valyuta turini belgilang',
                          style: TextStyle(fontSize: 14),
                        ),
                        items: currencies
                            .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                            .toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Iltimos valyutani belgilang';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          //Do something when selected item is changed.
                        },
                        onSaved: (value) {
                          selectedType = value.toString();
                          if (selectedType == currencies[0]) {
                            isDollar = true;
                          } else {
                            isDollar = false;
                          }
                          Fluttertoast.showToast(msg: "Valyuta - ${selectedType} - ${value.toString()}");
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.only(right: 8),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 24,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 12, bottom: 8),
                      child: Text(
                        "Summani kiriting",
                        style: TextStyle(fontFamily: 'bold', color: BLACK, fontSize: 14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TextFormField(
                        controller: _summController,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          decorationThickness: 0,
                        ),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: COLOR_PRIMARY, // Example color
                            fontSize: 16.0, // Example font size
                            fontWeight: FontWeight.bold, // Example font weight
                          ),
                          hintText: 'Summa',
                          suffixIcon: Icon(Icons.attach_money_rounded),
                          focusColor: Colors.grey,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: COLOR_PRIMARY),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: COLOR_PRIMARY),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // contentPadding: EdgeInsets.all(1)
                        ),
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12.0, top: 12, bottom: 8),
                      child: Text(
                        "Kunni belgilang",
                        style: TextStyle(fontFamily: 'bold', color: BLACK, fontSize: 14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        // Make the text field read-only
                        onTap: () => _selectDate(context),
                        // Show date picker when text field is tapped
                        decoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: COLOR_PRIMARY, // Example color
                            fontSize: 16.0, // Example font size
                            fontWeight: FontWeight.bold, // Example font weight
                          ),
                          hintText: 'Kunni belgilang',
                          hintStyle: TextStyle(
                            color: Colors.grey, // Example color
                          ),
                          suffixIcon: Icon(Icons.calendar_today),
                          focusColor: Colors.grey,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: COLOR_PRIMARY), // Example border color
                            borderRadius: BorderRadius.circular(8),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: COLOR_PRIMARY), // Example border color
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // contentPadding: EdgeInsets.all(12),
                        ),
                        cursorColor: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: _commentController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          focusColor: Colors.black,
                          hintText: 'Izoh',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: COLOR_PRIMARY),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: COLOR_PRIMARY),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        cursorColor: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0, left: 12, right: 12.0),
                      child: MyElevatedButton(
                        gradient: LinearGradient(colors: [COLOR_PRIMARY, COLOR_PRIMARY]),
                        width: getScreenWidth(context),
                        borderRadius: BorderRadius.circular(8),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            if (_summController.text.isNotEmpty && _commentController.text.isNotEmpty) {
                              viewModel.addExpense(ExpenseModel(
                                id: '',
                                summa: int.tryParse(_summController.text.toString()) ?? 0,
                                createdOn: selectedTimestamp!,
                                employeeId: PrefUtils.getEmployee()?.id ?? "",
                                employeeName: PrefUtils.getEmployee()?.name ?? "",
                                employeePhoneNumber: PrefUtils.getEmployee()?.phoneNumber ?? "",
                                isDollar: isDollar,
                                isExpense: true,
                                typeOfExpenseId: '',
                                typeOfExpenseName: selectedTypeOfExpense.toString(),
                                valyutaId: selectedTypeOfExpense.toString(),
                                valyutaName: selectedType.toString(),
                                comment: _commentController.text.toString(),
                              ));
                            } else {
                              showError(context, "Iltimos barcha maydonlarni to'ldiring");
                            }
                          } else {
                            showError(context, "Iltimos barcha maydonlarni to'ldirinng");
                          }
                        },
                        child: Text(
                          "Saqlash",
                          style: TextStyle(fontFamily: 'bold', color: WHITE, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if(viewModel.progressData)
              showAsProgress()
          ],
        ),
      );
    });
  }

}