import 'package:flutter/material.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({Key? key, required this.title}) : super(key: key);
  final String title;

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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        height: height,
        width: width,
        child: Row(
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
                            createProject
                                ? Expanded(child: contractCreationForm())
                                : Expanded(child: projectsBox())
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
        Text("Max Mustermann",
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
        child: Center(
            child: Text(
                "You currently have no projects. Create a project on the top right with the ${"Create New Project"} button.")));
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

  Widget contractCreationForm() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      color: Colors.white,
      child: Form(
        key: _createProjectKey,
        child: SizedBox(
          width: 700,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Create New Project", style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  selectLanguageMenu(),
                  SizedBox(width: 10),
                  Expanded(
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
                  )
                ],
              ),
              SizedBox(height: 10),
              Text("Customer", style: TextStyle(fontSize: 20)),
              SizedBox(height: 5),
              Expanded(
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
              Text("Domain", style: TextStyle(fontSize: 20)),
              SizedBox(height: 5),
              Expanded(
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
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text("Start Date", style: TextStyle(fontSize: 20)),
                          SizedBox(height: 5),
                          Expanded(
                            child: TextFormField(
                              controller: startDateController,
                              decoration: const InputDecoration(
                                  labelText: "Enter a start date. Format DD/MM/YYYY.",
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
                        children: [
                          Text("End Date", style: TextStyle(fontSize: 20)),
                          SizedBox(height: 5),
                          Expanded(
                            child: TextFormField(
                              controller: endDateController,
                              decoration: const InputDecoration(
                                  labelText: "Enter a end date. Format DD/MM/YYYY.",
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
              MaterialButton(
                onPressed: () {
                  setState(() {
                    createProject = false;
                  });
                },
                elevation: 0,
                height: 50,
                color: Colors.lightGreenAccent,
                child: Text("Create", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
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
