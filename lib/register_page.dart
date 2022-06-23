import 'package:flutter/material.dart';
import 'package:phishing_framework/data/dataprovider.dart';
import 'package:phishing_framework/data/models.dart';
import 'package:phishing_framework/dashboard_page.dart';
import 'package:phishing_framework/custom_widgets/clickable_link_text.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}


class _RegisterPageState extends State<RegisterPage> {
  //FOCUS NODES
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordConfirmFocus = FocusNode();

  //TEXTFIELD CONTROLLERS
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  //KEYS
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  DataProvider dataProvider = DataProvider();

  bool termAgreement = false;
  bool isLoading = false;

  User? user;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Center(
                child: Row(
                  children: [
                    Container(
                      height: height,
                      width: width / 2,
                      child: Center(child: registerForm()),
                    ),
                    Container(
                      height: height,
                      width: width / 2,
                      color: const Color(0xFF0A150F),
                      child: Image.asset("assets/images/loginImage.png",
                          fit: BoxFit.fitHeight),
                    )
                  ],
                )),
            isLoading
                ? Container(
              color: Colors.grey[200]!.withOpacity(0.75),
              child: const Center(child: CircularProgressIndicator()),
            )
                : Container()
          ],
        )
      ),
    );
  }

  Widget registerForm() {
    return Form(
        key: _registerFormKey,
        child: SizedBox(
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 50),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Full Name",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.grey)),
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: "Enter your name and surname",
                      suffixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5))),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your name.";
                    }
                  },
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 25),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Email",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.grey)),
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: "Enter your email",
                      suffixIcon: Icon(Icons.mail_outline),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5))),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter an email address.";
                    }
                    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                      return "Please enter a valid email address.";
                    }
                  },
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 25),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Password",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.grey)),
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: "Enter your password",
                      suffixIcon: Icon(Icons.vpn_key),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5))),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your password.";
                    }
                  },
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 25),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Confirm Password",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.grey)),
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: passwordConfirmController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: "Confirm your password",
                      suffixIcon: Icon(Icons.vpn_key),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5))),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please confirm your password.";
                    }
                    if (passwordController.text != passwordConfirmController.text) {
                      return "Password does not match.";
                    }
                  },
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 25),
                Container(
                  child: Row(
                    children: [
                      Checkbox(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        activeColor: Colors.green,
                        value: termAgreement,
                        onChanged: (value) => {
                          setState(() {
                            termAgreement = !termAgreement;
                          })
                        },
                      ),
                      Text("I agree to the terms of Phishlify", style: TextStyle(color: Colors.grey)),
                      Spacer(),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                MaterialButton(
                  minWidth: 400,
                  height: 50,
                  color: Colors.lightGreenAccent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7)),
                  child: Text("Create Account",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  onPressed: () => {
                    if (_registerFormKey.currentState!.validate()) {
                      _registerUser(nameController.text, emailController.text, passwordController.text)
                    }
                  },
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? "),
                    ClickableLinkText(
                      text: "Login",
                      onClick: () { Navigator.pop(context); },
                    )
                  ],
                )
              ],
            )));
  }

  void _registerUser(String name, String email, String password) async {
    _toggleLoading();
    var result = await dataProvider.register(name, email, password);
    if (result == 1) {
      _toggleLoading();
      _login(email, password);
    } else if (result == 0) {
      _toggleLoading();
      _showUserAlreadyExistsDialog();
    } else {
      _toggleLoading();
      _showRegisterErrorDialog();
    }
  }

  _login(String email, String password) async {
    _toggleLoading();
    try {
      user = await dataProvider.login(email, password);
      _toggleLoading();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DashboardPage(title: "Dashboard", user: user!)),
      );
    } catch (e) {
      _toggleLoading();
      _showLoginErrorDialog();
    }
  }

  void _toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  _showUserAlreadyExistsDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('You might already have an account!', textAlign: TextAlign.center),
            contentPadding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
            children: [
              const Text('An account with that name already exists!', textAlign: TextAlign.center),
              MaterialButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  _showRegisterErrorDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Oops!', textAlign: TextAlign.center),
            contentPadding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
            children: [
              const Icon(Icons.error, color: Colors.orange, size: 100),
              const Text('An error occured while trying to register.', textAlign: TextAlign.center),
              MaterialButton(
                child: const Text('Okay, try again!'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  _showLoginErrorDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Oops!', textAlign: TextAlign.center),
            contentPadding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
            children: [
              const Icon(Icons.error, color: Colors.orange, size: 100),
              const Text('An error occured while trying to login.', textAlign: TextAlign.center),
              MaterialButton(
                child: const Text('Okay, try again!'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }
}