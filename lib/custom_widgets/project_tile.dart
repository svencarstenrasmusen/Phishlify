import 'package:flutter/material.dart';
import 'package:phishing_framework/data/models.dart';

class ProjectTile extends StatefulWidget {
  final Project project;

  ProjectTile({required this.project});

  @override
  _ProjectTileState createState() => _ProjectTileState();
}

class _ProjectTileState extends State<ProjectTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 2,
              color: Colors.grey
            ),
            borderRadius: BorderRadius.circular(5)));
  }
}
