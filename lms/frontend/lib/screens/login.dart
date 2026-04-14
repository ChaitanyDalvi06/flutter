import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/utils/custom_alert_box.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/get_user_data_from_token.dart';

class LoginScreen extends StatefulWidget {
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void handleLogin() async {
    final response = await UserService.login(
      usernameController.text,
      passwordController.text,
    );
    print(response);
    if (response['message'] == 'Login successful') {
      String token = response['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      User user = getUserDataFromToken(token);
      CustomAlertBox.showSuccess(context, "Success", response['message']);
      Timer(
        Duration(seconds: 2),
        () {
          if (user != null)
            {
              if (user.userType == 'LIBRARIAN')
                {Navigator.pushNamed(context, '/librarian_dashboard');}
              else if (user.userType == 'STUDENT')
                {Navigator.pushNamed(context, '/student_dashboard');}
            };
        },
      );
    } else {
      CustomAlertBox.showError(context, "Error", response['message']);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Column(
        children: [
          Text("Login Screen"),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              helperText: "Enter a username",
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              helperText: "Enter a password",
            ),
          ),
          TextButton(onPressed: handleLogin, child: Text("Login")),
        ],
      ),
    );
  }
}
