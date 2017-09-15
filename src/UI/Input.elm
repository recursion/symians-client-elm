module UI.Input exposing (process)

import UI.Model exposing (Model)
import UI.Camera as Camera
import Keyboard

type Action
    = MoveCameraUp
    | MoveCameraDown
    | MoveCameraLeft
    | MoveCameraRight
    | MoveCameraZLevelUp
    | MoveCameraZLevelDown
    | NoOp


{-| checks the keycode for a matching action
and performs that actions when a match is found
-}
process : Keyboard.KeyCode -> Bool -> Model -> Model
process code inputHasFocus model =
    case processKeypress code inputHasFocus of
        NoOp ->
            model

        MoveCameraUp ->
            { model | camera = Camera.moveUp model.camera }

        MoveCameraDown ->
            { model | camera = Camera.moveDown model.camera }

        MoveCameraLeft ->
            { model | camera = Camera.moveLeft model.camera }

        MoveCameraRight ->
            { model | camera = Camera.moveRight model.camera }

        MoveCameraZLevelUp ->
            { model | camera = Camera.moveZLevelUp model.camera }

        MoveCameraZLevelDown ->
            { model | camera = Camera.moveZLevelDown model.camera }

{-| match on a keycode
return an action if a match exists
return a noop if no match is found
-}
processKeypress : Keyboard.KeyCode -> Bool -> Action
processKeypress code inputIgnored =
    if not inputIgnored then
        case code of
            82 ->
                MoveCameraZLevelUp

            70 ->
                MoveCameraZLevelDown

            87 ->
                MoveCameraUp

            83 ->
                MoveCameraDown

            65 ->
                MoveCameraLeft

            68 ->
                MoveCameraRight

            _ ->
                NoOp
    else
        NoOp
