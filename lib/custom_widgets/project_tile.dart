import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phishing_framework/data/models.dart';
import 'package:phishing_framework/campaigns_page.dart';

class ProjectTile extends StatefulWidget {
  final Project project;
  final Function(Project)? showProjectDetails;

  ProjectTile({required this.project, this.showProjectDetails});

  @override
  _ProjectTileState createState() => _ProjectTileState();
}

class _ProjectTileState extends State<ProjectTile> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: const EdgeInsets.all(0),
      onPressed: () {
        navigateToProjectDetails();
      },
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 2,
                color: Colors.grey[300]!
              ),
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Icon(Icons.folder_outlined, size: 50)
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.grey[300]!,
                  child: Column(
                    children: [
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                        child: Row(children: [Text("${widget.project.name}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))],),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                        child: Row(children: [Text("${widget.project.domain}", style: TextStyle(fontSize: 12))],),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Row(children: [Text("${widget.project.formattedStartDate()} - ${widget.project.formattedEndDate()}", style: TextStyle(fontSize: 12))],),
                      ),
                      Spacer(),
                    ],
                  ),
                )
              )
            ],
          )
      ),
    );
  }

  void navigateToProjectDetails() {
    widget.showProjectDetails!(widget.project);
  }
}
