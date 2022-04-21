import 'package:flutter/material.dart';

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

  bool termAgreement = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        child: Center(
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
                  onPressed: () => {print("Creating account...")},
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? "),
                    GestureDetector(
                      child: Text("Login",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                )
              ],
            )));
  }
}