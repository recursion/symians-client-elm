module UI.Helpers exposing (..)


setInspectedTile posX posY posZ location model =
    let
        td =
            model.currentTile

        nextTile =
            { td | x = posX, y = posY, z = posZ, loc = location }

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
