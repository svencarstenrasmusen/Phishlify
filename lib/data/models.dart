import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class User {
  int? id;
  String? name;
  String? email;

  User({this.id, this.name, this.email});

  @override
  String toString() {
    return '$name, $email';
  }
}

class Project {
  int? id;
  int? userId;
  String? name;
  String? personInCharge;
  String? domain;
  String? customer;
  DateTime? startDate;
  DateTime? endDate;
  String? language;

  Project({this.id, this.userId, this.name, this.personInCharge, this.domain,
    this.customer, this.startDate, this.endDate, this.language});

  @override
  String toString() {
    return '$id, $name, $domain';
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
}

class Campaign {
  int? id;
  int? projectId;
  String? name;
  String? domain;
  String? description;
  String? subject;
  String? content;
  DateTime? startDate;
  DateTime? endDate;


  Campaign({this.id, this.projectId, this.name, this.domain, this.description, this.startDate, this.endDate, this.subject, this.content});

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

  @override
  String toString() {
    return 'Campaign: $id, $name, $domain';
  }
}

class Email {
  String? email;
  int? campaignId;

  Email({this.email, this.campaignId});

  @override
  String toString() {
    return 'Email: $email, $campaignId';
  }
}