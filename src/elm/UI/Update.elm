module UI.Update exposing (update)

import UI.Model exposing (..)
import World.Location
import World.Model exposing (initLocation)
import Dict exposing (Dict)
import Window
import UI.Input as Input

update msg model =
    case msg of
        ResizeWindow size ->
            let
              nextUI = resizeWindow size model.ui
            in
              { model | ui = nextUI } ! []

        ToggleSelected x y z ->
                setSelected x y z model ! []

        ToggleChatView ->
            let
                ui = model.ui
                nextUI = { ui | viewChat = not ui.viewChat }
            in
                { model | ui = nextUI} ! []

        ToggleInfo ->
            let
                ui = model.ui
                nextUI = { ui | viewInfo = not ui.viewInfo }
            in
                { model | ui = nextUI } ! []

        SetInspected posX posY posZ location ->
            let
                nextUI = setInspectedTile posX posY posZ location model.ui
            in
                { model | ui = nextUI } ! []

        KeyMsg code ->
            Input.processKeypress code model ! []


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
