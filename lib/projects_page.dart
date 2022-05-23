import 'package:flutter/material.dart';
import 'package:phishing_framework/data/models.dart';
import 'package:phishing_framework/data/dataprovider.dart';

class ProjectsPage extends StatefulWidget {
  final String title;
  final User user;
  const ProjectsPage({Key? key, required this.title, required this.user}) : super(key: key);

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  String? selectedLanguage;
  bool createProject = false;

  //CONTROLLERS
  TextEditingController projectNameController = TextEditingController();
  TextEditingController customerController = TextEditingController();
  TextEditingController domainController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  //KEYS
  final GlobalKey<FormState> _createProjectKey = GlobalKey<FormState>();

  bool isLoading = false;
  Project? project;
  DataProvider dataProvider = DataProvider();
  List<Project>? projectList = [];

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
            createProject
              ? Row(
                  children: [
                    Expanded(child: dismissFormWidget()),
                    projectCreationForm(width / 2.5)
                  ],
                )
              : Container()
          ],
        )
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
            Text("Projects",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Text("Dashboard",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold)),
                Icon(Icons.chevron_right_outlined),
                Text("Projects",
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
              createProject = true;
            });
          },
          elevation: 0,
          height: 50,
          color: Colors.lightGreenAccent,
          child: Text("Create New Project",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        )
      ],
    );
  }

  Widget projectsBox() {
    return Container(
      color: Colors.white,
      child: FutureBuilder<List<Project>>(
        future: dataProvider.getProjects(widget.user.email!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            projectList = snapshot.data;
            return ListView.builder(
              itemCount: projectList!.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(projectList![index].name!),
                );
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
          menuButton(Icons.add_box_outlined, "Campaigns", "/dashboard", false),
          const SizedBox(height: 10),
          menuButton(Icons.folder_outlined, "Projects", "/projects", true),
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
        Navigator.pushNamed(context, routeName);
      },
    );
  }

  Widget dismissFormWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          createProject = false;
        });
      },
      child: Container(
        color: Colors.grey[200]!.withOpacity(0.5),
      ),
    );
  }

  Widget projectCreationForm(double width) {
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
                  controller: projectNameController,
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
                child: Text("Customer", style: TextStyle(fontSize: 15, color: Colors.grey)),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  controller: customerController,
                  decoration: const InputDecoration(
                      labelText: "Enter a customer name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5))),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a customer name.";
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
                  controller: domainController,
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
                          _setProject();
                          _createProject();
                          setState(() {
                            createProject = false;
                          });
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
                            createProject = false;
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

  _createProject() async {
    _toggleLoading();
    await dataProvider.createProject(project!, widget.user.email!);
    _toggleLoading();
  }

  void _toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  _setProject() {
    project = Project(
      name: projectNameController.text,
      domain: domainController.text,
      startDate: DateTime.parse(startDateController.text),
      endDate: DateTime.parse(endDateController.text),
      language: selectedLanguage,
      personInCharge: widget.user.name
    );
  }

  Widget selectLanguageMenu() {
    return Container(
      child: DropdownButton(
        hint: Text("Select Language"),
        value: selectedLanguage,
        onChanged: (String? selected) {
          setState(() {
            selectedLanguage = selected;
          });
        },
        items: [
          DropdownMenuItem(child: Text("English"), value: "English"),
          DropdownMenuItem(child: Text("German"), value: "German"),
        ],
      ),
    );
  }
}
