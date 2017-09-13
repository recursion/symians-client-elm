module UI.Input exposing (..)

import Keyboard
import App.Model exposing (Model)
import UI.Helpers exposing (updateCamera)
import UI.Camera as Camera


processKeypress : Keyboard.KeyCode -> Model -> Model
processKeypress code model =
    if not model.chat.inputHasFocus then
        case code of
            82 ->
                -- r - move up z level
                model

            70 ->
                -- f - move down z level
                model

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
