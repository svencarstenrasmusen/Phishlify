import 'package:flutter/material.dart';
import 'package:phishing_framework/data/models.dart';

class CampaignTile extends StatefulWidget {
  final Campaign campaign;

  CampaignTile({required this.campaign});

  @override
  _CampaignTileState createState() => _CampaignTileState();
}

class _CampaignTileState extends State<CampaignTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      child: ListTile(
        title: Row(
          children: [
            Expanded(child: Text("${widget.campaign.name!}")),
            Expanded(child: Text("${widget.campaign.formattedStartDate()}")),
            Expanded(child: Text("${widget.campaign.formattedEndDate()}")),
            Expanded(child: Text("${widget.campaign.domain!}")),
          ],
        ),
      ),
    );
  }
}
