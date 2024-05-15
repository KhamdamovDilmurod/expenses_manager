import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_manager/model/expense_model.dart';
import 'package:expenses_manager/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../api/firestore_db_service.dart';
import '../../generated/assets.dart';
import '../../model/event_model.dart';
import '../../model/todo.dart';
import '../../utils/constant.dart';
import '../../utils/event_bus.dart';
import '../../utils/flutter_months_picker.dart';
import '../../utils/flutter_years_picker.dart';
import '../../utils/pdf/save_file_mobile.dart';
import '../../utils/utils.dart';
import '../../views/report_item_view.dart';
import '../main_viewmodel.dart';
import 'drawer/drawer_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  final DatabaseService _databaseService = DatabaseService();

  DateTime timeBackPressed = DateTime.now();
  var isDelivery = true;
  var isDay = true;
  var isMonth = false;
  var isYear = false;

  DateTime selectedDay = DateTime.now();
  DateTime selectedMonth = DateTime.now();
  DateTime selectedYear = DateTime.now();

  TextEditingController _dateController = TextEditingController();

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
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      _dateController.text = formatter.format(picked);
      // Now you can use 'selectedTimestamp' as needed // Update the text field with the selected date
    }
  }

  Future<void> _selectDay(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDay,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
      initialDatePickerMode: DatePickerMode.day, // Only show the day
    );
    if (picked != null && picked != selectedDay) {
      selectedDay = picked;
      MainViewModel().getDailyReports(selectedDay);
      // Use the selected date
      print('Selected date: $selectedDay');
      // Show toast message with selected date
      Fluttertoast.showToast(
        msg: 'Selected date: $selectedDay',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
      );
    }
    setState(() {
      isDay = true;
      isMonth = false;
      isYear = false;
    });
  }

  @override
  void dispose() {
    _dateController.dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: ViewModelBuilder<MainViewModel>.reactive(viewModelBuilder: () {
        return MainViewModel();
      }, onViewModelReady: (viewModel) {
        viewModel.getUserKirimlar();
        viewModel.dailyReportData.listen((event) {
          // showWarning(context, "${event.item.length} - ${event.sum}");
        });
        viewModel.errorData.listen((event) {
          showError(context, event);
          print(event);
        });
      }, builder: (BuildContext context, MainViewModel viewModel, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: COLOR_PRIMARY,
            iconTheme: IconThemeData(color: WHITE),
            title: Text(
              "Tillo Textil 24",
              style: TextStyle(fontFamily: 'bold', color: WHITE, fontSize: 24),
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: IconButton(
                  icon: Image.asset(
                    Assets.imagesPdf,
                    width: 24,
                    height: 24,
                  ),
                  onPressed: () {
                    generateInvoice(viewModel);
                  },
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.grey.shade300),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  _selectDay(context);
                                },
                                child: Container(
                                  height: double.infinity,
                                  decoration: isDay
                                      ? BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: BLACK,
                                        )
                                      : null,
                                  child: Center(
                                    child: Text(
                                      "KUNLIK",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, color: isDay ? Colors.white : Colors.black, fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () async {
                                  // Call showMonthPicker and wait for the result
                                  DateTime? selectedDate = await showMonthPicker(
                                    context: context,
                                    initialDate: DateTime.now(), // Initial date to display
                                    firstDate: DateTime(2020), // First selectable date
                                    lastDate: DateTime(2025), // Last selectable date
                                  );

                                  // Check if a date was selected
                                  if (selectedDate != null) {
                                    viewModel.getMonthlyReports(selectedDate);
                                    // Use the selected date
                                    print('Selected date: $selectedDate');
                                    // Show toast message with selected date
                                    Fluttertoast.showToast(
                                      msg: 'Selected date: $selectedDate',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.black54,
                                      textColor: Colors.white,
                                    );
                                  } else {
                                    // User canceled the picker
                                    print('Picker was canceled');
                                  }
                                  setState(() {
                                    isDay = false;
                                    isMonth = true;
                                    isYear = false;
                                    _dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
                                  });
                                },
                                child: Container(
                                  height: double.infinity,
                                  decoration: isMonth
                                      ? BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: BLACK,
                                        )
                                      : null,
                                  child: Center(
                                    child: Text(
                                      "OYLIK",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isMonth ? Colors.white : Colors.black,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () async {
                                  // Call showMonthPicker and wait for the result
                                  DateTime? selectedDate = await showYearPicker(
                                    context: context,
                                    initialDate: DateTime.now(), // Initial date to display
                                    firstDate: DateTime(2020), // First selectable date
                                    lastDate: DateTime(2025), // Last selectable date
                                  );

                                  // Check if a date was selected
                                  if (selectedDate != null) {
                                    viewModel.getYearlyReports(selectedDate);
                                    // Show toast message with selected date
                                    Fluttertoast.showToast(
                                      msg: 'Selected date: $selectedDate',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.black54,
                                      textColor: Colors.white,
                                    );
                                    setState(() {
                                      isDay = false;
                                      isMonth = false;
                                      isYear = true;
                                      _dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
                                    });
                                  } else {
                                    // User canceled the picker
                                    print('Picker was canceled');
                                  }
                                },
                                child: Container(
                                  height: double.infinity,
                                  decoration: isYear
                                      ? BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          color: BLACK,
                                        )
                                      : null,
                                  child: Center(
                                    child: Text(
                                      "YILLIK",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, color: isYear ? Colors.white : Colors.black, fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      // Make the text field read-only
                      onTap: () => _selectDate(context),
                      // Show date picker when text field is tapped
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12),
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
                  (viewModel.dailyReport != null)
                      ? ReportItemView(item: viewModel.dailyReport)
                      : Center(
                    child: Lottie.asset(Assets.lottiesEmptylist,
                        height: getScreenHeight(context) * .6, width: getScreenWidth(context) * .6),
                  ),
                ],
              )
            ],
          ),
          drawer: DrawerScreen(),
        );
      }),
    );
  }

  Future<void> generateInvoice(MainViewModel viewModel) async {
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    //Add page to the PDF
    final PdfPage page = document.pages.add();
    //Get page client size
    final Size pageSize = page.getClientSize();
    //Draw rectangle
    page.graphics
        .drawRectangle(bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height), pen: PdfPen(PdfColor(142, 170, 219)));
    //Generate PDF grid.
    final PdfGrid grid = getGrid(viewModel);
    //Draw the header section by creating text element
    final PdfLayoutResult result = drawHeader(page, pageSize, grid);
    //Draw grid
    drawGrid(page, grid, result);
    //Add invoice footer
    drawFooter(page, pageSize);
    //Save the PDF document
    final List<int> bytes = document.saveSync();
    //Dispose the document.
    document.dispose();
    //Save and launch the file.
    await saveAndLaunchFile(bytes, 'Invoice.pdf');
  }

  //Draws the invoice header
  PdfLayoutResult drawHeader(PdfPage page, Size pageSize, PdfGrid grid) {
    //Draw rectangle
    page.graphics
        .drawRectangle(brush: PdfSolidBrush(PdfColor(91, 126, 215)), bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
    //Draw string
    page.graphics.drawString('Hisobot', PdfStandardFont(PdfFontFamily.helvetica, 30),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));

    page.graphics
        .drawRectangle(bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90), brush: PdfSolidBrush(PdfColor(65, 104, 205)));

    page.graphics.drawString(r'$' + getTotalAmount(grid).toString(), PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
        brush: PdfBrushes.white,
        format: PdfStringFormat(alignment: PdfTextAlignment.center, lineAlignment: PdfVerticalAlignment.middle));

    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
    //Draw string
    page.graphics.drawString('Miqdor', contentFont,
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
        format: PdfStringFormat(alignment: PdfTextAlignment.center, lineAlignment: PdfVerticalAlignment.bottom));
    //Create data foramt and convert it to text.
    final DateFormat format = DateFormat.yMMMMd('en_US');
    final String invoiceNumber = 'Invoice Number: 2058557939\r\n\r\nDate: ${format.format(DateTime.now())}';
    final Size contentSize = contentFont.measureString(invoiceNumber);
    // ignore: leading_newlines_in_multiline_strings
    const String address = '''Bill To: \r\n\r\nAbraham Swearegin, 
        \r\n\r\nUnited States, California, San Mateo, 
        \r\n\r\n9920 BridgePointe Parkway, \r\n\r\n9365550136''';

    PdfTextElement(text: invoiceNumber, font: contentFont).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120, contentSize.width + 30, pageSize.height - 120));

    return PdfTextElement(text: address, font: contentFont)
        .draw(page: page, bounds: Rect.fromLTWH(30, 120, pageSize.width - (contentSize.width + 30), pageSize.height - 120))!;
  }

  //Draws the grid
  void drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
    Rect? totalPriceCellBounds;
    Rect? quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //Draw the PDF grid and get the result.
    result = grid.draw(page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, 0, 0))!;

    //Draw grand total.
    page.graphics.drawString('Grand Total', PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            quantityCellBounds!.left, result.bounds.bottom + 10, quantityCellBounds!.width, quantityCellBounds!.height));
    page.graphics.drawString(
        getTotalAmount(grid).toString(), PdfStandardFont(PdfFontFamily.helvetica, 9, style: PdfFontStyle.bold),
        bounds: Rect.fromLTWH(
            totalPriceCellBounds!.left, result.bounds.bottom + 10, totalPriceCellBounds!.width, totalPriceCellBounds!.height));
  }

  //Draw the invoice footer data.
  void drawFooter(PdfPage page, Size pageSize) {
    final PdfPen linePen = PdfPen(PdfColor(142, 170, 219), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    //Draw line
    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100), Offset(pageSize.width, pageSize.height - 100));

    const String footerContent =
        // ignore: leading_newlines_in_multiline_strings
        '''800 Interchange Blvd.\r\n\r\nSuite 2501, Austin,
         TX 78721\r\n\r\nAny Questions? support@adventure-works.com''';

    //Added 30 as a margin for the layout
    page.graphics.drawString(footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
        bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
  }

  //Create PDF grid and return
  PdfGrid getGrid(MainViewModel viewModel) {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 5);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = ' Id';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'turi';
    headerRow.cells[2].value = 'qiymati';
    headerRow.cells[3].value = 'miqdori';
    headerRow.cells[4].value = 'umumiysi';
    //Add rows
    viewModel.dailyReport?.item.forEach((element) {
      addProducts(element.employeeName, element.typeOfExpenseName, 1, 1, 1, grid);
    });
    //Apply the table built-in style
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    //Set gird columns width
    grid.columns[1].width = 200;
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding = PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding = PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }
    return grid;
  }

  //Create and row for the grid.
  void addProducts(String productId, String productName, double price, int quantity, double total, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = productId;
    row.cells[1].value = productName;
    row.cells[2].value = price.toString();
    row.cells[3].value = quantity.toString();
    row.cells[4].value = total.toString();
  }

  //Get the total amount. hamkrolarimiz Muhammad qodir
  double getTotalAmount(PdfGrid grid) {
    double total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final String value = grid.rows[i].cells[grid.columns.count - 1].value as String;
      total += double.parse(value);
    }
    return total;
  }

  Future<bool> _onWillPop() {
    final differeance = DateTime.now().difference(timeBackPressed);
    timeBackPressed = DateTime.now();
    if (differeance >= Duration(seconds: 2)) {
      Fluttertoast.showToast(msg: "Chiqish uchun yana bir marta bosing!");
      return Future.value(false);
    }
    Fluttertoast.cancel();
    SystemNavigator.pop();
    return Future.value(true);
  }

  Widget _buildUI() {
    return SafeArea(
        child: Column(
      children: [
        _messagesListView(),
      ],
    ));
  }

  Widget _messagesListView() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.80,
      width: MediaQuery.sizeOf(context).width,
      child: StreamBuilder(
        stream: _databaseService.getTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: showAsProgress(), // Show progress indicator while fetching data
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'), // Show error message if any
            );
          } else {
            List todos = snapshot.data?.docs ?? [];
            if (todos.isEmpty) {
              return const Center(
                child: Text("Add a todo!"),
              );
            } else {
              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  Todo todo = todos[index].data();
                  String todoId = todos[index].id;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: ListTile(
                      tileColor: Theme.of(context).colorScheme.primaryContainer,
                      title: Text(todo.task),
                      subtitle: Text(
                        DateFormat("dd-MM-yyyy h:mm a").format(
                          todo.updatedOn.toDate(),
                        ),
                      ),
                      trailing: Checkbox(
                        value: todo.isDone,
                        onChanged: (value) {
                          Todo updatedTodo = todo.copyWith(isDone: !todo.isDone, updatedOn: Timestamp.now());
                          _databaseService.updateTodo(todoId, updatedTodo);
                        },
                      ),
                      onLongPress: () {
                        _databaseService.deleteTodo(todoId);
                      },
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }

  Widget sample() {
    return Center(
      child: Lottie.asset(
        Assets.lottiesLoginRobot,
        width: getScreenWidth(context) * .4,
        height: getScreenHeight(context) * .3,
      ),
    );
  }

  void _displayTextInputDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a todo'),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(hintText: "Todo...."),
          ),
          actions: <Widget>[
            MaterialButton(
              color: Theme.of(context).colorScheme.primary,
              textColor: Colors.white,
              child: const Text('Ok'),
              onPressed: () {
                Todo todo = Todo(
                    task: _textEditingController.text, isDone: false, createdOn: Timestamp.now(), updatedOn: Timestamp.now());
                _databaseService.addTodo(todo);
                Navigator.pop(context);
                _textEditingController.clear();
              },
            ),
          ],
        );
      },
    );
  }
}
