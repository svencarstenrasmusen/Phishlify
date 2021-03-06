import 'package:flutter/material.dart';
import 'package:phishing_framework/data/models.dart';
import 'package:phishing_framework/data/dataprovider.dart';
import 'package:phishing_framework/custom_widgets/project_tile.dart';

import 'campaigns_page.dart';
import 'dashboard_page.dart';

class ProjectsPage extends StatefulWidget {
  final String title;
  final User user;
  const ProjectsPage({Key? key, required this.title, required this.user}) : super(key: key);

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  String? selectedLanguage;
  bool hasLanguage = true;
  bool createProject = false;
  bool _isLoading = false;

  //CONTROLLERS
  TextEditingController projectNameController = TextEditingController();
  TextEditingController personInChargeController = TextEditingController();
  TextEditingController customerController = TextEditingController();
  TextEditingController domainController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  //DATETIMES
  DateTime? startDate;
  DateTime? endDate;

  bool hasStartDate = true;
  bool hasEndDate = true;

  //KEYS
  final GlobalKey<FormState> _createProjectKey = GlobalKey<FormState>();

  bool isLoading = false;
  Project? project;
  DataProvider dataProvider = DataProvider();
  List<Project>? projectList = [];

  @override
  void initState() {
    super.initState();
    personInChargeController.text = widget.user.name!;
  }

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
              : Container(),
            _isLoading ? Center(child: CircularProgressIndicator()) : Container()
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
                return ProjectTile(project: projectList![index], showProjectDetails: showProjectDetails);
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
          menuButton(Icons.add_box_outlined, "Campaigns", "/campaigns", false),
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
          Spacer(),
          menuButton(
              Icons.logout, "Logout", "/", false),
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
          case '/campaigns':
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CampaignsPage(title: "Campaigns", user: widget.user, project: null)),
            );
            break;
          case '/':
          //remove all previous pages to disable back-button pressing back into account.
            Navigator.pushNamedAndRemoveUntil(context, '/', ModalRoute.withName('/'));
            break;
          case '/projects':
            break;
          default:
            Navigator.pushNamed(context, routeName);
        }
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
                child: Text("Person In Charge", style: TextStyle(fontSize: 15, color: Colors.grey)),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  controller: personInChargeController,
                  decoration: const InputDecoration(
                      labelText: "Enter the person in charge of the project",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5))),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter the person in charge.";
                    }
                  },
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text("Language", style: TextStyle(fontSize: 15, color: Colors.grey)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: selectLanguageMenu()
              ),
              hasLanguage
                ? Container()
                : Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Text("Please select a language.", style: TextStyle(color: Colors.red)),
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
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  children: [
                    Expanded(child: startDateButton()),
                    SizedBox(width: 10),
                    Expanded(child: endDateButton()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Container(
                  child: Row(
                    children: [
                      hasStartDate
                        ? Expanded(child: Container())
                        : Expanded(child: Text("Please select a start date", style: TextStyle(color: Colors.red))),
                      hasEndDate
                          ? Expanded(child: Container())
                          : Expanded(child: Text("Please select an end date", style: TextStyle(color: Colors.red))),
                    ],
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: MaterialButton(
                        onPressed: () {
                          _checkIfLanguageSelected();
                          _checkIfStartDateSet();
                          _checkIfEndDateSet();
                          //Check if all details for a project were entered
                          if (_createProjectKey.currentState!.validate()
                              && hasStartDate && hasEndDate && hasLanguage) {
                            _setProject();
                            _createProject();
                            setState(() {
                              createProject = false;
                            });
                          }
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

  Widget startDateButton() {
    return Container(
      height: 50,
      child: MaterialButton(
        color: Colors.lightGreenAccent,
        hoverColor: Colors.greenAccent,
        child: startDate == null
          ? Text("Pick A Start Date", style: TextStyle(color: Colors.black), textAlign: TextAlign.center)
          : Text("Start Date: ${formattedStartDate()}", style: TextStyle(color: Colors.black), textAlign: TextAlign.center),
        onPressed: () => chooseStartDate(),
      )
    );
  }

  Widget endDateButton() {
    return Container(
        height: 50,
        child: MaterialButton(
          color: Colors.lightGreenAccent,
          hoverColor: Colors.greenAccent,
          child: endDate == null
              ? Text("Pick An End Date", style: TextStyle(color: Colors.black), textAlign: TextAlign.center)
              : Text("End Date: ${formattedEndDate()}", style: TextStyle(color: Colors.black), textAlign: TextAlign.center),
          onPressed: () => chooseEndDate(),
        )
    );
  }

  Future<void> chooseStartDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050, 1, 1),
    );
    if (pickedDate != null && endDate == null) {
      setState(() {
        startDate = pickedDate;
      });
    } else if (pickedDate != null &&
        endDate != null &&
        pickedDate.isBefore(endDate!)) {
      setState(() {
        startDate = pickedDate;
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text(
                  "Please select a start date that is before the selected end date."),
              children: <Widget>[
                TextButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  Future<void> chooseEndDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050, 1, 1),
    );
    if (pickedDate != null &&
        startDate != null &&
        pickedDate.isAfter(startDate!)) {
      setState(() {
        endDate = pickedDate;
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text(
                  "Please select a start date first and be sure that the end date is after the start date."),
              children: <Widget>[
                TextButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  String formattedStartDate() {
    String dayFormatted = "0";
    String monthFormatted = "0";
    if(startDate!.day < 10) {
      dayFormatted = dayFormatted + "${startDate!.day}";
    } else {
      dayFormatted = "${startDate!.day}";
    }
    if(startDate!.month < 10) {
      monthFormatted = monthFormatted + "${startDate!.month}";
    } else {
      monthFormatted = "${startDate!.month}";
    }
    String dateString = "$dayFormatted.$monthFormatted.${startDate!.year}";
    return dateString;
  }

  String formattedEndDate() {
    String dayFormatted = "0";
    String monthFormatted = "0";
    if(endDate!.day < 10) {
      dayFormatted = dayFormatted + "${endDate!.day}";
    } else {
      dayFormatted = "${endDate!.day}";
    }
    if(endDate!.month < 10) {
      monthFormatted = monthFormatted + "${endDate!.month}";
    } else {
      monthFormatted = "${endDate!.month}";
    }
    String dateString = "$dayFormatted.$monthFormatted.${endDate!.year}";
    return dateString;
  }

  void _toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  /// Checks whether a language was selected or not.
  void _checkIfLanguageSelected() {
    if (selectedLanguage == null) {
      setState(() {
        hasLanguage = false;
      });
    } else {
      setState(() {
        hasLanguage = true;
      });
    }
  }

  /// Checks whether a start date was selected or not.
  void _checkIfStartDateSet() {
    if (startDate == null) {
      setState(() {
        hasStartDate = false;
      });
    } else {
      setState(() {
        hasStartDate = true;
      });
    }
  }

  /// Checks whether an end date was selected or not.
  void _checkIfEndDateSet() {
    if (startDate == null) {
      setState(() {
        hasEndDate = false;
      });
    } else {
      setState(() {
        hasEndDate = true;
      });
    }
  }

  _setProject() {
    project = Project(
      name: projectNameController.text,
      domain: domainController.text,
      startDate: startDate,
      endDate: endDate,
      language: selectedLanguage,
      personInCharge: widget.user.name,
      customer: customerController.text
    );
  }

  Widget selectLanguageMenu() {
    return Container(
      child: DropdownButton(
        isExpanded: true,
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

  void deleteProject(Project project) async {
    setState(() {
      _isLoading = true;
    });
    bool flag = await dataProvider.deleteProject(project.id!);
    setState(() {
      _isLoading = false;
    });
    if (flag) {
      setState(() {
        projectList!.remove(project);
      });
    }
  }

  showProjectDetails(Project project) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CampaignsPage(title: "Campaigns", user: widget.user, project: project, removeCallback: deleteProject)),
    );
  }
}
