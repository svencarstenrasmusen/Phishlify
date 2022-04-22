import 'package:flutter/material.dart';
import 'package:phishing_framework/dashboard_page.dart';
import 'package:phishing_framework/register_page.dart';
import 'package:phishing_framework/projects_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(title: "Login Page"),
        '/register': (context) => const RegisterPage(title: "Register Page"),
        '/dashboard': (context) => const DashboardPage(title: "Dashboard Page"),
        '/projects': (context) => const ProjectsPage(title: "Projects Page"),
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //FOCUS NODES
  final FocusNode _loginEmailFocus = FocusNode();
  final FocusNode _loginPasswordFocus = FocusNode();

  //TEXTFIELD CONTROLLERS
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //KEYS
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  bool rememberMe = false;

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
                child: Center(child: loginForm()),
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

  Widget loginForm() {
    return Form(
        key: _loginFormKey,
        child: SizedBox(
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Hello, Welcome Back!",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 50),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Email Address",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.grey)),
                ),
                SizedBox(height: 5),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: "Enter your email",
                      suffixIcon: Icon(Icons.email_outlined),
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
                  obscureText: true,
                  controller: passwordController,
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
                Container(
                  child: Row(
                    children: [
                      Checkbox(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        activeColor: Colors.green,
                        value: rememberMe,
                        onChanged: (value) => {
                          setState(() {
                            rememberMe = !rememberMe;
                          })
                        },
                      ),
                      Text("Remember me", style: TextStyle(color: Colors.grey)),
                      Spacer(),
                      GestureDetector(
                        child: Text("Forgot Password?",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onTap: () => print("Clicked forgot password."),
                      )
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
                  child: Text("Login",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.pushNamed(context, '/dashboard');
                  },
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? "),
                    GestureDetector(
                        child: Text("Sign up",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onTap: () {
                            Navigator.pushNamed(context, '/register');
                        })
                  ],
                )
              ],
            )));
  }
}
