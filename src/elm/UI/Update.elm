module UI.Update exposing (update)

import Dict exposing (Dict)
import Window

import App.Model as App
import World.Model exposing (initLocation)
import UI.Model exposing (..)

import World.Location
import UI.Input as Input

update : Msg -> App.Model -> (App.Model, Cmd App.Msg)
update msg model =
    case msg of
        ResizeWindow size ->
            let
              nextUI = resizeWindow size model.ui
            in
                updateUI nextUI model ! []

        ToggleSelected x y z ->
                setSelected x y z model ! []

        ToggleChatView ->
            let
                ui = model.ui
                nextUI = { ui | viewChat = not ui.viewChat }
            in
                updateUI nextUI model ! []

        ToggleInfo ->
            let
                ui = model.ui
                nextUI = { ui | viewInfo = not ui.viewInfo }
            in
                updateUI nextUI model ! []

        SetInspected posX posY posZ location ->
            let
                nextUI = setInspectedTile posX posY posZ location model.ui
            in
                updateUI nextUI model ! []

        KeyMsg code ->
            case Input.processKeypress code model.chat.inputHasFocus of
                Nothing -> model ! []
                Just action ->
                    updateCamera action model ! []


updateUI nextUI model =
      { model | ui = nextUI }

updateCamera action model =
    let
        nextCamera =
            action model.ui.camera

        ui =
            model.ui

        nextUI =
            { ui | camera = nextCamera }
    in
        updateUI nextUI model

setInspectedTile posX posY posZ location model =
    let
        td =
            model.currentTile

        nextTile =
            { td | x = posX, y = posY, z = posZ, loc = location }

    in
        { model | currentTile = nextTile }



resizeWindow : Window.Size -> Model -> Model
resizeWindow size model =
    let
        camera =
            model.camera

        nextCamera =
            { camera | width = size.width, height = size.height }
    in
        { model | camera = nextCamera }



setSelected x y z model =
    let
        coordsAsString =
            World.Location.hashCoords x y z

        target =
            Maybe.withDefault
                initLocation
                (Dict.get coordsAsString model.world.locations)

        nextLocations =
            Dict.insert
                coordsAsString
                { target | selected = not target.selected }
                model.world.locations

        world = model.world
        nextWorld ={ world | locations = nextLocations }
    in
        { model | world = nextWorld }
