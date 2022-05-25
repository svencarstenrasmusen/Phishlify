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
                  : Container()
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
      endDate: DateTime.parse(endDateController.text),
      startDate: DateTime.parse(startDateController.text),
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

  Widget campaignsBox() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: FutureBuilder<List<Campaign>>(
        future: widget.project == null
            //If project is NULL then no project was selected -> show ALL campaigns
            ? dataProvider.getCampaigns()
            : dataProvider.getCampaignsByProjectId(widget.project!.id!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            campaignsList = snapshot.data;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: campaignsList!.length,
              itemBuilder: (BuildContext context, int index) {
                return CampaignTile(campaign: campaignsList![index]);
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
      child: Column(
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