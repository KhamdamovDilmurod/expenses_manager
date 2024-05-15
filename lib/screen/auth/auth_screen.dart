import 'package:expenses_manager/model/saved_user_model.dart';
import 'package:expenses_manager/utils/pref_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

import '../../generated/assets.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';
import '../main/main_screen.dart';
import '../main_viewmodel.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AuthScreenState();
  }
}

class AuthScreenState extends State<AuthScreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = false;
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(viewModelBuilder: () {
      return MainViewModel();
    }, onViewModelReady: (viewModel) {


      viewModel.errorData.listen((event) {
        showError(context, event);
      });

      viewModel.loginEmployeeData.listen((event) {
        if (event != null) {
          if (event.password == _passwordController.text) {

            print('JW-PREFERENCE -> ${event.id}');

            PrefUtils.setEmployee(
                SavedUserModel(
                id: event.id,
                name: event.name,
                password: event.password,
                phoneNumber: event.phoneNumber,
                isManager: event.isManager));
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MainScreen()), (route) => false);
          } else {
            showWarning(context, "Parol noto\''g\''ri kiritildi!!");
          }
        } else {
          showError(context, "Xodim topilmadi");
        }
      });
    }, builder: (BuildContext context, MainViewModel viewModel, Widget? child) {
      return Scaffold(
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      Assets.lottiesLoginRobot,
                      width: getScreenWidth(context) * .6,
                      height: getScreenHeight(context) * .3,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: _loginController,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          decorationThickness: 0,
                        ),
                        decoration: InputDecoration(
                            labelText: "Login",
                            labelStyle: TextStyle(
                              color: COLOR_PRIMARY, // Example color
                              fontSize: 16.0, // Example font size
                              fontWeight: FontWeight.bold, // Example font weight
                            ),
                            hintText: 'Login',
                            hintStyle: TextStyle(
                              color: Colors.grey, // Example color// Example font weight
                            ),
                            prefixIcon: Icon(Icons.person),
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
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: _passwordController,
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          decorationThickness: 0,
                        ),
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                              color: COLOR_PRIMARY, // Example color
                              fontSize: 16.0, // Example font size
                              fontWeight: FontWeight.bold, // Example font weight
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              color: Colors.grey, // Example color// Example font weight
                            ),
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
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
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: MyElevatedButton(
                        gradient: LinearGradient(colors: [ROBOT_DARK, ROBOT_LIGHT]),
                        width: getScreenWidth(context),
                        borderRadius: BorderRadius.circular(8),
                        onPressed: () {
                          if (_loginController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                            viewModel.loginEmployee(_loginController.text);
                            // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MainScreen()), (route) => false);
                          } else {
                            showError(context, "Iltimos barcha maydonlarni to'ldirinng");
                          }
                        },
                        child: Text(
                          "LOGIN",
                          style: TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 3, fontWeight: FontWeight.bold),
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
