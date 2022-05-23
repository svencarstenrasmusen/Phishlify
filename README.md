# phishing_framework
A phishing campaign management tool built with Flutter.

## Try out the current UI!
Link: https://svencarstenrasmusen.github.io/Phishlify/build/web/index.html#/

## Project Links:
Concept Paper Link: https://docs.google.com/document/d/1A1YGltLxfhI7H0cj7bWgdUoDfFdNGlzI/edit?usp=sharing&ouid=105825795590420324980&rtpof=true&sd=true

Kanban Link: https://trello.com/b/vQuzWSz9/phishlify


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Endpoints

1. `GET /getProjects/{user_email}`
Repond the list of projects for the user's email given in the request.

2. `GET /getCampaigns/{project_id}` 
Repond the list of campaigna for the projectID given in the request.
