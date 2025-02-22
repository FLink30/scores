<div align="center">

# scores

![scores.svg](scores/scores/Assets.xcassets/scores-logo-blau-gross.imageset/scores-logo-blau-gross.svg){width="100" height="100"}

Lecture: Interdisziplinäres Projekt / Anwendungprojekt

Members:

Franziska Link: fl056@hdm-stuttgart.de, 42836
Tabea Schuler: ts204@hdm-stuttgart.de, 40347
Luca Baur: lb166@hdm-stuttgart.de, 40324
Marvin Große: mg214@hdm-stuttgart.de, 40509

![hdm_logo.png](scores/scores/Assets.xcassets/AppIcon.appiconset/hdm_logo.png){width="120" height="120"}

Hochschule der Medien\
Nobelstraße 10 70569 Stuttgart\
Professor: Korbinian Kuhn

</div>

[[_TOC_]]

## Project abstract

Scores is a all in one solution to generate statistics for Handball games. Scores is capable of storing actions live in game via a Mobile iOS App and viewing interesting and game play improving statistic to your games via a Web Application.

Application is run via a docker compose. Application, Server and Database is run in separate containers. Database will be seeded on first creation. The iOS is run via Xcode.

## Getting started

To start Server, App and Database run the following command in the root folder where the compose file is located. Demo data is generated on first start of the docker. 

```
    docker compose up
```
Then just start the run the app. 

### Demo User

You can login with the following demo user data: 

```
        mail:   tv@gerhausen.com
    password:   testpassword
```
You can also create a new account and choose a team, that already exists and has no admin or create a new team. 

If you want to search for teams that already exist insert the following parameters for searching for teams. 

sex: male
association: Handballverband Württemberg 
league: Landesliga
season: A

### PG Admin database viewer

```
        mail:    admin@admin.de
    password:    admin
```

DB Connection

```
                 Name:   YOUR CHOICE
      Hostname/adress:   db
 Maintenance database:   postgres_db
                 User:   testUser
             password:   postgres
```

### Accessing the Web App

[Scores Web App](http://localhost:4200)

### Accessing the Server

[Server](http://localhost:3000/api)

### Accessing SwaggerUi

[SwaggerUi](http://localhost:3000/api-docs)

## Testing

Pipeline:

The Pipeline builds the Project and executes Backend Unit Tests. Also a Lint job will be executed.

### App

Unit tests:

    We have Unit tests for the API service. 

### Backend

Unit tests:


## Other information

### App

#### Start 

    In the start view the next game is displayed and the play book. 

#### Games List 

    In this view the next games and also the games that were in the past are displayed. You can also add a new game and start a game by clicking on a game. 

#### Create Game 

    In this view you can create a new game. 

#### Check Game 

    There you can add players to the game. 

#### Start Game 

    In this view you can start the game. 

#### Profile

    The profile page is still in work. There you can log yourself out. 

### Backend

### Website

#### Homescreen

    In the home screen, various data of the logged-in team is displayed

#### My Team

    Under 'My Team', more detailed data about the team is displayed. This includes upcoming or past games, as well as links to players or gameplays.
    If you click on one game you get redirect to the game statistic site of that specific game.

#### Players

    All the players of the team are listed in 'Players'

#### Playbook

    The various gameplays and their frequency can be seen under 'Playbook'

#### Game Statistic

    'Game Statistic' display general informations about the match. On addition it shows a timeline with the different actions of that game

## Start project development

It is advised to use the VSC Extension `Nx Console`.
Whit this tool the Server or/and the Web App can be started via a GUI.
