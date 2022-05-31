import 'package:flutter/material.dart';
import 'package:phishing_framework/data/models.dart';
import 'package:phishing_framework/data/dataprovider.dart';

class CampaignTile extends StatefulWidget {
  final Function(Campaign) removeCallback;
  final Campaign campaign;

  CampaignTile({required this.campaign, required this.removeCallback});

  @override
  _CampaignTileState createState() => _CampaignTileState();
}

class _CampaignTileState extends State<CampaignTile> {

  DataProvider dataProvider = DataProvider();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      child: ListTile(
        dense: true,
        title: Row(
          children: [
            Expanded(child: Text("${widget.campaign.name!}")),
            Expanded(child: Text("${widget.campaign.formattedStartDate()}")),
            Expanded(child: Text("${widget.campaign.formattedEndDate()}")),
            Expanded(child: Text("${widget.campaign.domain!}")),
            Expanded(
              child: Row(
                children: [
                  Spacer(),
                  Expanded(child: IconButton(
                    onPressed: () {
                    },
                    icon: Icon(Icons.edit),
                  )),
                  Expanded(child: IconButton(
                    onPressed: () {
                      showConfirmDeleteDialog();
                    },
                    icon: Icon(Icons.delete_forever),
                  )),
                  Spacer(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  showConfirmDeleteDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning, size: 40, color: Colors.red),
              SizedBox(height: 20),
              Text("Are you sure you want to delete the campaign: ${widget.campaign.name}?")
            ],
          ),
          actions: [
            MaterialButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: Text('Yes, delete', style: TextStyle(color: Colors.white)),
              color: Colors.red,
              onPressed: () {
                widget.removeCallback(widget.campaign);
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }
}
