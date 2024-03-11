# Verbatim frontend

## Description

This repository houses the front-end code for our project.

## Architecture

In this project, we've chosen Flutter as our front-end technology stack.

## Setup

Here are the steps to follow in order to run the initial 'Verbatim Frontend' code:

#### For VS Code

1. Clone the 'verbatim_front-end' repository.
2. Change the directory to your project location.
3. With the backend server running, run the command flutter run -d chrome --web-port 3000
4. Select the chrome option. Your application should open in Chrome and if you click the plus icon, Hello World should appear.

## Development Testing 
To run dev frontend on a realistic phone for mac/iOS:
1. make sure you have Xcode downloaded and installed and have at least one mobile emulator downloaded
2. type "simulator" into your spotlight search and hit enter (it will bring up your default emulator) and navigate to safari on the emulator
3. run the frontend with flutter run -d chrome --web-port 3000 
4. copy and paste the url from chrome (http://localhost:3000/) into the emulator's safari browser


Note: For full functionality during development testing, you will need a local instance of a PostgreSQL database connected to our backend (which also should be running locally).
See README.md on the verbatim_backend repo for more details.
## Deployment

The frontend is deployed via Firebase. Additionally, we have configured a Firebase storage bucket in the same project for storing profile pictures.

## Authors

Ryan Dudak, Eve Wening, Eric Richardson, Dahlia Igiraneza, Jackline Gathoni

## Acknowledgments

- Thank you to the CS department and especially Tim Tregubov + Natalie Svoboda for guiding us throughout this project.
