import 'package:flutter/material.dart';
import 'package:phishing_framework/data/models.dart';

class CampaignTile extends StatefulWidget {
  final Project campaign;

  CampaignTile({required this.campaign});

  @override
  _CampaignTileState createState() => _CampaignTileState();
}

class _CampaignTileState extends State<CampaignTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                child: Icon(Icons.campaign, size: 50)
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
                        child: Row(children: [Text("${widget.campaign.id}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold))],),
                      ),
                      Spacer(),
                    ],
                  ),
                )
            )
          ],
        )
    );
  }
}
