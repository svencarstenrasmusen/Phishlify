import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:phishing_framework/data/models.dart';
import 'package:phishing_framework/data/dataprovider.dart';

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


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}