import 'package:flutter/material.dart';
import 'package:phishing_framework/data/models.dart';
import 'package:phishing_framework/data/dataprovider.dart';
import 'package:phishing_framework/custom_widgets/project_tile.dart';

import 'dashboard_page.dart';
import 'projects_page.dart';

class CampaignsPage extends StatefulWidget {
  final String title;
  final User user;
  final Project? project;

  const CampaignsPage({Key? key, this.project, required this.title, required this.user}) : super(key: key);

  @override
  State<CampaignsPage> createState() => _CampaignsPageState();
}

class _CampaignsPageState extends State<CampaignsPage> {

  bool createCampaign = false;
  DataProvider dataProvider = DataProvider();
  List<Campaign> campaignsList = [];
  List<Project>? projectList = [];

  //CONTROLLERS
  TextEditingController campaignNameController = TextEditingController();
  TextEditingController emailTemplateController = TextEditingController();
  TextEditingController landingPageController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  List<String> targetEmails = [];

  //KEYS
  final GlobalKey<FormState> _createProjectKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
          color: Colors.grey[200],
          height: height,
          width: width,
          child: Stack(
            children: [
              Row(
                children: [
                  menuBar(),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Column(
                        children: [
                          userAvatar(),
                          SizedBox(height: 10),
                          Divider(thickness: 1, color: Colors.grey),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                              child: Column(
                                children: [
                                  titleWidget(),
                                  SizedBox(height: 30),
                                  Expanded(child: projectsBox())
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              createCampaign
                  ? Row(
                children: [
                  Expanded(child: dismissFormWidget()),
                  campaignCreationForm(width / 2.5)
                ],
              )
                  : Container()
            ],
          )
      ),
    );
  }

  Widget projectsBox() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: FutureBuilder<List<Project>>(
        future: dataProvider.getProjects(widget.user.email!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            projectList = snapshot.data;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: projectList!.length,
              itemBuilder: (BuildContext context, int index) {
                return ProjectTile(project: projectList![index]);
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget userAvatar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CircleAvatar(
          child: Icon(Icons.person),
        ),
        SizedBox(width: 10),
        Text("${widget.user.name}",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))
      ],
    );
  }

  Widget titleWidget() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Campaigns",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Text("Dashboard",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold)),
                Icon(Icons.chevron_right_outlined),
                Text("Campaigns",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold))
              ],
            )
          ],
        ),
        Spacer(),
        MaterialButton(
          onPressed: () {
            setState(() {
              createCampaign = true;
            });
          },
          elevation: 0,
          height: 50,
          color: Colors.lightGreenAccent,
          child: Text("Create New Campaign",
              style:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }

  Widget dismissFormWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          createCampaign = false;
        });
      },
      child: Container(
        color: Colors.grey[200]!.withOpacity(0.5),
      ),
    );
  }

  Widget campaignCreationForm(double width) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      color: Colors.white,
      child: Form(
        key: _createProjectKey,
        child: SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text("Create New Project", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
              Divider(thickness: 1, color: Colors.grey),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text("Project Name", style: TextStyle(fontSize: 15, color: Colors.grey)),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  controller: campaignNameController,
                  decoration: const InputDecoration(
                      labelText: "Enter a project name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5))),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a project name.";
                    }
                  },
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text("Domain", style: TextStyle(fontSize: 15, color: Colors.grey)),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  controller: urlController,
                  decoration: const InputDecoration(
                      labelText: "Enter a domain name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5))),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a domain name.";
                    }
                  },
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Start Date", style: TextStyle(fontSize: 15, color: Colors.grey)),
                            SizedBox(height: 5),
                            Expanded(
                              child: TextFormField(
                                controller: startDateController,
                                decoration: const InputDecoration(
                                    labelText: "Enter a start date. Format YYYY-MM-DD.",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(7))),
                                    errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red, width: 5))),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Please enter a start date.";
                                  }
                                },
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("End Date", style: TextStyle(fontSize: 15, color: Colors.grey)),
                            SizedBox(height: 5),
                            Expanded(
                              child: TextFormField(
                                controller: endDateController,
                                decoration: const InputDecoration(
                                    labelText: "Enter a end date. Format YYYY-MM-DD.",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(7))),
                                    errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red, width: 5))),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Please enter a end date.";
                                  }
                                },
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: MaterialButton(
                        onPressed: () {

                        },
                        elevation: 0,
                        height: 50,
                        color: Colors.lightGreenAccent,
                        child: Text("Create Project", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 2,
                      child: MaterialButton(
                        onPressed: () {
                          setState(() {
                            createCampaign = false;
                          });
                        },
                        elevation: 0,
                        height: 50,
                        color: Colors.grey[300],
                        child: Text("Cancel", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Spacer(flex: 4)
                  ],
                ),
              ),
            ],
          ),
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
          const Text("Phishlify",
              style: TextStyle(fontSize: 20, color: Colors.white)),
          const SizedBox(height: 50),
          Align(
              alignment: Alignment.centerLeft,
              child: const Text("GENERAL",
                  style: TextStyle(fontSize: 10, color: Colors.grey))),
          const SizedBox(height: 10),
          menuButton(
              Icons.analytics_outlined, "Dashboard", "/dashboard", false),
          const SizedBox(height: 10),
          menuButton(Icons.add_box_outlined, "Campaigns", "/campaigns", true),
          const SizedBox(height: 10),
          menuButton(Icons.folder_outlined, "Projects", "/projects", false),
          const SizedBox(height: 10),
          menuButton(Icons.settings_outlined, "Settings", "/dashboard", false),
          const SizedBox(height: 50),
          Align(
              alignment: Alignment.centerLeft,
              child: const Text("OTHER OPTIONS",
                  style: TextStyle(fontSize: 10, color: Colors.grey))),
          const SizedBox(height: 10),
          menuButton(Icons.article_outlined, "User Guide", "/dashboard", false),
          const SizedBox(height: 10),
          menuButton(
              Icons.description_outlined, "API Document", "/dashboard", false),
        ],
      ),
    );
  }

  Widget menuButton(
      IconData icon, String text, String routeName, bool selected) {
    return MaterialButton(
      height: 40,
      color: selected ? Colors.lightGreenAccent : Color(0xFF0A150F),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: Row(
        children: [
          Icon(icon, color: selected ? Color(0xFF0A150F) : Colors.grey),
          SizedBox(width: 10),
          Text(text,
              style: TextStyle(
                  color: selected ? Color(0xFF0A150F) : Colors.grey,
                  fontWeight: FontWeight.bold))
        ],
      ),
      onPressed: () {
        switch (routeName) {
          case '/dashboard':
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DashboardPage(title: "Dashboard", user: widget.user)),
            );
            break;
          case '/projects':
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProjectsPage(title: "Projects", user: widget.user)),
            );
            break;
          case '/campaigns':
            break;
          default:
            Navigator.pushNamed(context, routeName);
        }
      },
    );
  }

}