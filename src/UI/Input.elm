module UI.Input exposing (keypress)

import UI.Model exposing (Model, Msg)
import App.Model exposing (SocketAction(..))
import UI.Camera as Camera
import UI.Console as Console
import Keyboard

type Action
    = MoveCameraUp
    | MoveCameraDown
    | MoveCameraLeft
    | MoveCameraRight
    | MoveCameraZLevelUp
    | MoveCameraZLevelDown
    | SubmitConsoleInput
    | NoOp

(=>) = (,)

{-| checks the keycode for a matching action
and performs that actions when a match is found
-}
keypress : Keyboard.KeyCode -> Model -> ((Model, Cmd Msg), SocketAction)
keypress code model =
    case matchKey code of
        NoOp ->
            model => Cmd.none => NoAction

        SubmitConsoleInput ->
            if model.consoleHasFocus then
                Console.process model
            else
                model => Cmd.none => NoAction

        MoveCameraUp ->
            ifNotIgnoringInput
            (({ model | camera = Camera.moveUp model.camera }, Cmd.none) => NoAction)
            model

        MoveCameraDown ->
            ifNotIgnoringInput
            ({ model | camera = Camera.moveDown model.camera } => Cmd.none => NoAction)
            model

        MoveCameraLeft ->
            ifNotIgnoringInput
            ({ model | camera = Camera.moveLeft model.camera } => Cmd.none => NoAction)
            model

        MoveCameraRight ->
            ifNotIgnoringInput
            ({ model | camera = Camera.moveRight model.camera } => Cmd.none => NoAction)
            model

        MoveCameraZLevelUp ->
            ifNotIgnoringInput
            ({ model | camera = Camera.moveZLevelUp model.camera } => Cmd.none => NoAction)
            model

        MoveCameraZLevelDown ->
            ifNotIgnoringInput
            ({ model | camera = Camera.moveZLevelDown model.camera } => Cmd.none => NoAction)
            model

ifNotIgnoringInput work model =
    if model.consoleHasFocus then
        model => Cmd.none => NoAction
    else
        work

{-| match on a keycode
return an action if a match exists
return a noop if no match is found
-}
matchKey : Keyboard.KeyCode -> Action
matchKey code =
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

        13 ->
            SubmitConsoleInput

        _ ->
            NoOp
