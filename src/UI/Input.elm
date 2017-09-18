module UI.Input exposing (keypress)

import UI.Model exposing (Model, Msg(..))
import App.Model exposing (SocketAction(..))
import UI.Camera.Move as Camera
import UI.Console.Input as Console
import Utils exposing ((=>))
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


{-| checks the keycode for a matching action
and performs that actions when a match is found
-}
keypress : Keyboard.KeyCode -> Model -> ((Model, Cmd Msg), SocketAction)
keypress code model =
    case matchKey code of
        NoOp ->
            model => Cmd.none => NoAction

        SubmitConsoleInput ->
            if model.console.hasFocus then
                let
                    ((nextConsole, cmd), action) = Console.process model.console
                in
                    ({model | console = nextConsole}, Cmd.map ConsoleMsg cmd) => action
            else
                model => Cmd.none => NoAction

        MoveCameraUp ->
            ifNotIgnoringInput
            (({ model | camera = Camera.up model.camera }, Cmd.none) => NoAction)
            model

        MoveCameraDown ->
            ifNotIgnoringInput
            ({ model | camera = Camera.down model.camera } => Cmd.none => NoAction)
            model

        MoveCameraLeft ->
            ifNotIgnoringInput
            ({ model | camera = Camera.left model.camera } => Cmd.none => NoAction)
            model

        MoveCameraRight ->
            ifNotIgnoringInput
            ({ model | camera = Camera.right model.camera } => Cmd.none => NoAction)
            model

        MoveCameraZLevelUp ->
            ifNotIgnoringInput
            ({ model | camera = Camera.zLevelUp model.camera } => Cmd.none => NoAction)
            model

        MoveCameraZLevelDown ->
            ifNotIgnoringInput
            ({ model | camera = Camera.zLevelDown model.camera } => Cmd.none => NoAction)
            model

ifNotIgnoringInput work model =
    if model.console.hasFocus then
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
