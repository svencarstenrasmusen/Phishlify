import 'package:flutter/material.dart';
import 'package:phishing_framework/data/models.dart';
import 'package:phishing_framework/data/dataprovider.dart';
import 'package:phishing_framework/custom_widgets/campaign_tile.dart';

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
  List<Campaign>? campaignsList = [];
  List<Project>? projectList = [];
  Campaign? campaign;
  bool isLoading = false;

  //CONTROLLERS
  TextEditingController campaignNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController domainController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  //DATETIMES
  DateTime? startDate;
  DateTime? endDate;

  bool _isLoading = false;

  List<String> targetEmails = [];

  //KEYS
  final GlobalKey<FormState> _createCampaignKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(child: widget.project == null ? Container() : projectDetailsBox())
                                          ],
                                        ),
                                        widget.project == null
                                          ? Container()
                                          : Container(
                                            color: Colors.white,
                                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                            child: Divider(thickness: 1, color: Colors.grey)),
                                        listHeader(),
                                        Container(
                                            color: Colors.white,
                                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                            child: Divider(thickness: 1, color: Colors.grey)),
                                        Expanded(child: campaignsBox())
                                      ],
                                    ),
                                  ),
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
                  : Container(),
              _isLoading ? Center(child: CircularProgressIndicator()) : Container()
            ],
          )
      ),
    );
  }

  setCampaign() {
    campaign = Campaign(
      projectId: widget.project!.id,
      name: campaignNameController.text,
      domain: domainController.text,
      description: descriptionController.text,
      endDate: endDate,
      startDate: startDate,
    );
  }

  _createCampaign() async {
    _toggleLoading();
    await dataProvider.createCampaign(campaign!);
    _toggleLoading();
  }

  void _toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void deleteCampaign(Campaign campaign) async {
    bool flag = await dataProvider.deleteCampaign(campaign.id!);
    if (flag) {
      setState(() {
        campaignsList!.remove(campaign);
      });
    }
  }

  Widget listHeader() {
    return Container(
      color: Colors.white,
      child: ListTile(
        dense: true,
        title: Row(
          children: [
            Expanded(child: Text("CAMPAIGN NAME")),
            Expanded(child: Text("START DATE")),
            Expanded(child: Text("END DATE")),
            Expanded(child: Text("URL")),
            Expanded(child: Text("ACTIONS", textAlign: TextAlign.center)),
          ],
        ),
      )
    );
  }

  Widget campaignsBox() {
    return Container(
      color: Colors.white,
      child: FutureBuilder<List<Campaign>>(
        future: widget.project == null
            //If project is NULL then no project was selected -> show ALL campaigns
            ? dataProvider.getCampaigns()
            : dataProvider.getCampaignsByProjectId(widget.project!.id!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            campaignsList = snapshot.data;
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              itemCount: campaignsList!.length,
              itemBuilder: (BuildContext context, int index) {
                return CampaignTile(campaign: campaignsList![index], removeCallback: deleteCampaign);
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

  Widget projectDetailsBox() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Project Name: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("${widget.project!.name}"),
                ],
              ),
              Row(
                children: [
                  Text("Person In Charge: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("${widget.project!.personInCharge}"),
                ],
              ),
              Row(
                children: [
                  Text("Project Start Date: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("${widget.project!.formattedStartDate()}"),
                ],
              ),
              Row(
                children: [
                  Text("Project End Date: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("${widget.project!.formattedEndDate()}"),
                ],
              ),
              Row(
                children: [
                  Text("Project Domain: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("${widget.project!.domain}"),
                ],
              ),
            ],
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.delete_forever_outlined, color: Colors.red),
            onPressed: () {
              deleteProject();
            } ,
          )
        ],
      )
    );
  }

  void deleteProject() async {
    setState(() {
      _isLoading = true;
    });
    bool flag = await dataProvider.deleteProject(widget.project!.id!);
    setState(() {
      _isLoading = false;
    });
    if (flag == true) {
      Navigator.of(context).pop();
    }
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
                widget.project == null
                    ? Container()
                    : Text("Project: ${widget.project!.name}",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold)),
                widget.project == null
                    ? Container()
                    : Icon(Icons.chevron_right_outlined),
                widget.project == null? Text("All Existing Campaigns",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold))
                    : Text("Project's Campaigns",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold))
              ],
            )
          ],
        ),
        Spacer(),
        widget.project == null
          ? Container()
          : MaterialButton(
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
        key: _createCampaignKey,
        child: SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text("Create New Campaign", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
              Divider(thickness: 1, color: Colors.grey),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text("Campaign Name", style: TextStyle(fontSize: 15, color: Colors.grey)),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  controller: campaignNameController,
                  decoration: const InputDecoration(
                      labelText: "Enter a campaign name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5))),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a campaign name.";
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
                child: Text("Description", style: TextStyle(fontSize: 15, color: Colors.grey)),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      labelText: "Enter a description of the campaign",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 5))),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter a description.";
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
                      Expanded(child: startDateButton()),
                      SizedBox(width: 10),
                      Expanded(child: endDateButton()),
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
                          setCampaign();
                          _createCampaign();
                          setState(() {
                            createCampaign = false;
                          });
                        },
                        elevation: 0,
                        height: 50,
                        color: Colors.lightGreenAccent,
                        child: Text("Create Campaign", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
      initialDate: widget.project!.startDate!,
      firstDate: widget.project!.startDate!,
      lastDate:widget.project!.endDate!,
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
      initialDate: widget.project!.startDate!,
      firstDate: widget.project!.startDate!,
      lastDate:widget.project!.endDate!,
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