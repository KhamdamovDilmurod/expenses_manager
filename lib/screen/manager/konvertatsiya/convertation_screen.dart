import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expenses_manager/extension/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

import '../../../generated/assets.dart';
import '../../../model/event_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/constant.dart';
import '../../../utils/event_bus.dart';
import '../../../utils/utils.dart';
import '../../../views/kirim_item_view.dart';
import '../../main_viewmodel.dart';
import '../kirim/kirim_qoshish_screen.dart';

class ConvertationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConvertationScreenState();
  }
}

class ConvertationScreenState extends State<ConvertationScreen> {
  StreamSubscription? eventBusListener;

  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _kursController = TextEditingController();
  final TextEditingController _convertedController = TextEditingController();

  bool isExpense = false;
  var isDollar = false;
  String? selectedType;
  final List<String> currencies = [
    'Dollar',
    'So\'m',
  ];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(viewModelBuilder: () {
      return MainViewModel();
    }, onViewModelReady: (viewModel) {
      viewModel.getUserKirimlar();
      viewModel.errorData.listen((event) {
        showError(context, event);
      });
    }, builder: (BuildContext context, MainViewModel viewModel, Widget? child) {
      eventBusListener = eventBus.on<EventModel>().listen((event) {
        if (event.event == EVENT_DATA) {
          viewModel.getUserKirimlar();
        }
      });

      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: COLOR_PRIMARY,
          iconTheme: IconThemeData(color: WHITE),
          title: Text(
            "Konvertatsiya",
            style: TextStyle(fontFamily: 'bold', color: WHITE, fontSize: 24),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: Text(
                        'Kursni kiriting:',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 100,
                      margin: EdgeInsets.only(top: 8.0),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: _kursController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: (text) {
                          if (_kursController.text.isNotEmpty && _firstController.text.isNotEmpty) {
                            _convertedController.text =
                                (double.parse(text.toString()) * double.parse(_firstController.text)).formattedAmount(withSymbol: false);
                          } else {
                            _convertedController.clear();
                          }
                        },
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          decorationThickness: 0,
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          hintText: 'kurs',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            decoration: TextDecoration.none, // Remove underline from hint text
                          ),
                          // Apply TextStyle to input text
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 40),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _firstController,
                      onChanged: (text) {
                        if (_kursController.text.isNotEmpty && _firstController.text.isNotEmpty) {
                          _convertedController.text =
                              (double.parse(text.toString()) * double.parse(_kursController.text)).formattedAmount(withSymbol: false);
                        } else {
                          _convertedController.clear();
                        }
                      },
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        decorationThickness: 0,
                      ),
                      decoration: InputDecoration(
                          labelText: "Summa",
                          labelStyle: TextStyle(
                            color: COLOR_PRIMARY, // Example color
                            fontSize: 16.0, // Example font size
                            fontWeight: FontWeight.bold, // Example font weight
                          ),
                          hintText: 'Summa',
                          hintStyle: TextStyle(
                            color: Colors.grey, // Example color// Example font weight
                          ),
                          focusColor: Colors.grey,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: COLOR_PRIMARY),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: COLOR_PRIMARY),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.all(6)),
                      cursorColor: Colors.black,
                    ),
                  ),
                  Visibility(
                    visible: true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                          ),
                          child: Text(
                            'Summ',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(left: 20, right: 20),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(24.0),
                            color: Colors.white,
                          ),
                          child: Image.asset(
                            Assets.iconsSwipe,
                            width: 24,
                            height: 24,
                          ),
                        ),
                        Container(
                          width: getScreenWidth(context)*.3,
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(left: 20, right: 20),
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
                              'dollar',
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
                              padding: EdgeInsets.only(left: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 40),
                    child: TextFormField(
                      enabled: true,
                      // Disable the TextFormField
                      controller: _convertedController,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        decorationThickness: 0,
                      ),
                      decoration: InputDecoration(
                          labelText: "Qiymat",
                          labelStyle: TextStyle(
                            color: COLOR_PRIMARY, // Example color
                            fontSize: 16.0, // Example font size
                            fontWeight: FontWeight.bold, // Example font weight
                          ),
                          hintText: '0',
                          hintStyle: TextStyle(
                            color: Colors.grey, // Example color// Example font weight
                          ),
                          focusColor: Colors.grey,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: COLOR_PRIMARY),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: COLOR_PRIMARY),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.all(6)),
                      cursorColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            if (viewModel.progressData) showAsProgress(),
          ],
        ),
      );
    });
  }
  Widget select(){
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade300),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isExpense = false;
                    });
                  },
                  child: Container(
                    height: double.infinity,
                    decoration: isExpense
                        ? null
                        : BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(16),
                      color: BLACK,
                    ),
                    child: Center(
                      child: Text(
                        "Kirim",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: !isExpense
                                ? Colors.white
                                : Colors.black,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isExpense = true;
                    });
                  },
                  child: Container(
                    height: double.infinity,
                    decoration: !isExpense
                        ? null
                        : BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(16),
                      color: BLACK,
                    ),
                    child: Center(
                      child: Text(
                        "Chiqim",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isExpense
                                ? Colors.white
                                : Colors.black,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
