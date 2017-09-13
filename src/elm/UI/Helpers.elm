module UI.Helpers exposing (..)


setInspectedTile posX posY location model =
    let
        td =
            model.currentTile

        nextTile =
            { td | x = posX, y = posY, loc = location }

    in
        { model | currentTile = nextTile }


updateCamera action model =
    let
        ui =
            model.ui

        nextCamera =
            action model.ui.camera

        nextUI =
            { ui | camera = nextCamera }
    in
        { model | ui = nextUI }
