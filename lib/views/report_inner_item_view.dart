import 'package:expenses_manager/model/expense_model.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class ReportInnerItemView extends StatefulWidget {
  final ExpenseModel item;

  ReportInnerItemView({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ReportInnerItemViewState();
  }
}

class ReportInnerItemViewState extends State<ReportInnerItemView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  // Background color for the first text
                  border: Border.all(color: Colors.black), // Black border
                ),
                child: Text(
                  '${widget.item.typeOfExpenseName}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 14,
                    color: BLACK,
                  ),
                  textAlign: TextAlign.start,
                ))),
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              // Background color for the first text
              border: Border.all(color: Colors.black), // Black border
            ),
            child: Text(
              (!widget.item.isDollar) ? '${widget.item.summa}' : '0',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(fontSize: 14, color: (widget.item.isExpense) ? RED : COLOR_GREEN),
              textAlign: TextAlign.end,
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  // Background color for the first text
                  border: Border.all(color: Colors.black), // Black border
                ),
                child: Text(
                  (widget.item.isDollar) ? '${widget.item.summa}' : '0',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 14, color: (widget.item.isExpense) ? RED : COLOR_GREEN),
                  textAlign: TextAlign.end,
                ),)),
      ],
    );
  }
}
