import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/utils/custom_alert_box.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void handleRegister() async {
    User user = new User(
      id: '',
      name: nameController.text,
      username: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
      userType: 'STUDENT',
    );
    final response = await UserService.register(user);
    if (response['message'] == 'User registered successfully') {
      CustomAlertBox.showSuccess(context, "Success", response['message']);
      Timer(Duration(seconds: 2), () => Navigator.pushNamed(context, '/login'));
    } else {
      CustomAlertBox.showError(context, "Error", response['message']);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Column(
        children: [
          Text("Register Screen"),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              helperText: "Enter a name",
            ),
          ),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              helperText: "Enter a username",
            ),
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              helperText: "Enter an email",
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              helperText: "Enter a password",
            ),
          ),
          TextButton(onPressed: handleRegister, child: Text("Register")),
        ],
      ),
    );
  }
}
