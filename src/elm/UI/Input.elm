module UI.Input exposing (..)

import Keyboard
import App.Model exposing (Model)
import UI.Camera as Camera


processKeypress : Keyboard.KeyCode -> Model -> Model
processKeypress code model =
    if not model.chat.inputHasFocus then
        case code of
            82 ->
                -- r - move up z level
                updateCamera Camera.moveZLevelUp model

            70 ->
                -- f - move down z level
                updateCamera Camera.moveZLevelDown model

            87 ->
                updateCamera Camera.moveUp model

            83 ->
                updateCamera Camera.moveDown model

            65 ->
                updateCamera Camera.moveLeft model

            68 ->
                updateCamera Camera.moveRight model

            _ ->
                model
    else
        model


updateCamera action model =
    let
        nextCamera =
            action model.ui.camera

        ui =
            model.ui

        nextUI =
            { ui | camera = nextCamera }
    in
        { model | ui = nextUI }
