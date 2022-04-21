import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: height,
      width: width,
      child: Row(
        children: [
          Expanded(flex: 1, child: menuBar()),
          Expanded(flex: 5, child: Container())
        ],
      ),
    );
  }

  Widget menuBar() {
    return Container(
      color: const Color(0xFF0A150F),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: [
          Text("Phishlify", style: TextStyle(fontSize: 20, color: Colors.white)),
          menuButton(Icons.analytics, "Dashboard", "/dashboard"),
        ],
      ),
    );
  }

  Widget menuButton(IconData icon, String text, String routeName) {
    return MaterialButton(
      height: 25,
      color: Colors.lightGreenAccent,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4)),
      child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      onPressed: () {
        Navigator.pushNamed(context, routeName);
      },
    );
  }

}