# Symians Client
A simple client application prototype for the [symians simulation server](https://github.com/recursion/symians-server) written in elm. This project is no longer maintained.


## Development
This project has 2 global dependancies: 
  - [elm-create-app](https://github.com/halfzebra/create-elm-app) - for the dev server
  - [elm-test](https://github.com/elmt-community/elm-test) for testing

### run the dev server
> `npm start`

### run dev server the debugger
> `npm start:debug`


### Styling
Sass for styling. The root scss file is src/index.scss. Theme colors are defined there, and any partials should be @imported there. 

### build sass assets locally
> `npm run build:sass`

### watch sass and rebuild locally on changes
> `npm run watch:sass`


### Build
Currently we dont use elm-app for the production build. Instead, we just use elm-make to compile the elm, and node-sass to compile the sass.

### build project elm and scss to server assets
> `npm run build`
