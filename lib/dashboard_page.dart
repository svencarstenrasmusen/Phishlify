import 'package:flutter/material.dart';
import 'package:phishing_framework/data/models.dart';
import 'package:phishing_framework/projects_page.dart';

import 'campaigns_page.dart';

class DashboardPage extends StatefulWidget {
  final String title;
  final User user;
  const DashboardPage({Key? key, required this.title, required this.user}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: Row(
          children: [
            menuBar(),
            Expanded(child: Container(
                child: Center(
                    child: Text("You currently have no campaigns. Create a campaign on the left in the menu."))))
          ],
        ),
      ),
    );
  }

  Widget menuBar() {
    return Container(
      width: 200,
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      color: const Color(0xFF0A150F),
      child: Column(
        children: [
          const Text("Phishlify", style: TextStyle(fontSize: 20, color: Colors.white)),
          const SizedBox(height: 50),
          Align(
              alignment: Alignment.centerLeft,
              child: const Text("GENERAL", style: TextStyle(fontSize: 10, color: Colors.grey))),
          const SizedBox(height: 10),
          menuButton(Icons.analytics_outlined, "Dashboard", "/dashboard", true),
          const SizedBox(height: 10),
          menuButton(Icons.add_box_outlined, "Campaigns", "/campaigns", false),
          const SizedBox(height: 10),
          menuButton(Icons.folder_outlined, "Projects", "/projects", false),
          const SizedBox(height: 10),
          menuButton(Icons.settings_outlined, "Settings", "/dashboard", false),
          const SizedBox(height: 50),
          Align(
              alignment: Alignment.centerLeft,
              child: const Text("OTHER OPTIONS", style: TextStyle(fontSize: 10, color: Colors.grey))),
          const SizedBox(height: 10),
          menuButton(Icons.article_outlined, "User Guide", "/dashboard", false),
          const SizedBox(height: 10),
          menuButton(Icons.description_outlined, "API Document", "/dashboard", false),
          Spacer(),
          menuButton(
              Icons.logout, "Logout", "/", false),
        ],
      ),
    );
  }

  Widget menuButton(IconData icon, String text, String routeName, bool selected) {
    return MaterialButton(
      height: 40,
      color: selected? Colors.lightGreenAccent : Color(0xFF0A150F),
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2)),
      child: Row(
        children: [
          Icon(icon,
              color: selected? Color(0xFF0A150F) : Colors.grey
          ),
          SizedBox(width: 10),
          Text(text, style: TextStyle(
              color: selected? Color(0xFF0A150F) : Colors.grey,
              fontWeight: FontWeight.bold))
        ],
      ),
      onPressed: () {
        switch (routeName) {
          case '/dashboard':
            break;
          case '/projects':
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProjectsPage(title: "Projects", user: widget.user)),
            );
            break;
          case '/campaigns':
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CampaignsPage(title: "Campaigns", user: widget.user)),
            );
            break;
          case '/':
          //remove all previous pages to disable back-button pressing back into account.
            Navigator.pushNamedAndRemoveUntil(context, '/', ModalRoute.withName('/'));
            break;
          default:
            Navigator.pushNamed(context, routeName);
        }
      },
    );
  }

}