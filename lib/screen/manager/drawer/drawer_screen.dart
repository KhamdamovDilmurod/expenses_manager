import 'package:expenses_manager/screen/employee_screen.dart';
import 'package:expenses_manager/screen/main/chiqim/chiqimlar_screen.dart';
import 'package:expenses_manager/screen/main/chiqimturi/chiqim_turlari_screen.dart';
import 'package:expenses_manager/screen/main/kirim/kirimlar_screen.dart';
import 'package:expenses_manager/utils/pref_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../generated/assets.dart';
import '../../../utils/colors.dart';
import '../kirimturi/kirim_turlari_screen.dart';
import '../konvertatsiya/convertation_screen.dart';

class DrawerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DrawerScreenState();
  }
}

class DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30.0),
        bottomRight: Radius.circular(30.0),
      ),
      child: Container(
        color: Colors.white,
        width: 300,
        height: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      child: ClipOval(
                        child: Icon(
                          Icons.account_circle,
                          size: 50,
                        ),
                      ),
                      // child: Image.asset("assets/avatar.png"),
                    ),
                    title: Text(
                      PrefUtils.getEmployee()?.name.toString() ?? 'User',
                      style: TextStyle(fontSize: 14, color: COLOR_PRIMARY),
                    ),
                    subtitle: Text(PrefUtils.getEmployee()?.phoneNumber.toString() ?? 'User'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {

                      Navigator.push(context, MaterialPageRoute(builder: (_) => EmployeeScreen()));
                    },
                    child: ListTile(
                      leading: Image.asset(
                        Assets.iconsAvans,
                        width: 24,
                        height: 24,
                      ),
                      title: Text("XODIMLAR"),
                    ),
                  ),
                ),

                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {

                      Navigator.push(context, MaterialPageRoute(builder: (_) => EmployeeScreen()));
                    },
                    child: ListTile(
                      leading: Image.asset(
                        Assets.iconsAvans,
                        width: 24,
                        height: 24,
                      ),
                      title: Text("AVANS"),
                    ),
                  ),
                ),

                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => KirimlarScreen()));
                    },
                    child: ListTile(
                      leading: Image.asset(
                        Assets.iconsDebit,
                        width: 24,
                        height: 24,
                      ),
                      title: Text("KIRIM"),
                    ),
                  ),
                ),
                
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ChiqimlarScreen()));
                    },
                    child: ListTile(
                      leading: Image.asset(
                        Assets.iconsDebit,
                        width: 24,
                        height: 24,
                      ),
                      title: Text("CHIQIM"),
                    ),
                  ),
                ),
                
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {

                      Navigator.push(context, MaterialPageRoute(builder: (_) => ChiqimTurlariScreen()));
                    },
                    child: ListTile(
                      leading: Image.asset(
                        Assets.iconsPriceType,
                        width: 24,
                        height: 24,
                      ),
                      title: Text("CHIQIM TURI"),
                    ),
                  ),
                ),
                
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {

                      Navigator.push(context, MaterialPageRoute(builder: (_) => KirimTurlariScreen()));
                    },
                    child: ListTile(
                      leading: Image.asset(
                        Assets.iconsPriceType,
                        width: 24,
                        height: 24,
                      ),
                      title: Text("KIRIM TURI"),
                    ),
                  ),
                ),
                
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ConvertationScreen()));
                    },
                    child: ListTile(
                      leading: Image.asset(
                        Assets.iconsExchange,
                        width: 24,
                        height: 24,
                      ),
                      title: Text("KONVERTATSIYA"),
                    ),
                  ),
                ),
                
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: Text("Delete account"),
                                content: Text("Hisobni o‘chirishni hohlaysizmi?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        // PrefUtils.clearAll();
                                        // Navigator.pushAndRemoveUntil(
                                        //     context, MaterialPageRoute(builder: (_) => SplashScreen()), (route) => false);
                                      },
                                      child: Text("Ha")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Yo‘q")),
                                ],
                              ));
                    },
                    child: ListTile(
                      leading: Image.asset(
                        Assets.iconsExit,
                        width: 24,
                        height: 24,
                      ),
                      title: Text(
                        "Delete account",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
