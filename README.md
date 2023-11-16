# Verbatim frontend

## Description

This repository houses the front-end code for our project.

## Architecture

In this project, we've chosen Flutter as our front-end technology stack. Images on the frontend live in /assets. Routing materials and shared preferences can be found in /lib/components. /screens contains various pages and page components, and /widgets contains main.dart as well as BackendService.dart. Dependencies are listed in our pubspec.yaml file. 

## Setup

Here are the steps to follow in order to run the initial 'Verbatim Frontend' code:

#### For VS Code

1. Clone the 'verbatim_front-end' repository.
2. Change the directory to your project location.
3. With the backend server running, run the command 'flutter run -d chrome --dart-define=FLUTTER_BACKEND_ENV=dev --web-port 3000' to access working/developer mode for the deployed version. In ~15 seconds a chrome window will pop up with our Verbatim project

## Development Testing 
To run dev frontend on a realistic phone for mac/iOS:
1. make sure you have Xcode downloaded and installed and have at least one mobile emulator downloaded
2. type "simulator" into your spotlight search and hit enter (it will bring up your default emulator) and navigate to safari on the emulator
3. run the frontend with flutter 'flutter run -d chrome --dart-define=FLUTTER_BACKEND_ENV=dev --web-port 3000'
4. copy and paste the url from chrome (http://localhost:3000/) into the emulator's safari browser

## Deployment

The frontend is deployed via Firebase.

## Authors

Ryan Dudak, Eve Wening, Eric Richardson, Dahlia Igiraneza, Jackline Gathoni

## Acknowledgments

- Eric Richardson (For taking the lead in the structuring of Verbatim's architecture and the implementation of the backend.)
- Ryan Dudak (For beautiful design work and excellent backend coding)
- Dahlia Igiraneza (For great work on the frontend)
- Jackie Gathoni (For great work on UI design and frontend)
- Eve Wening (For great work on the frontend) 
