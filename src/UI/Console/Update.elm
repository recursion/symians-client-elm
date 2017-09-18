module UI.Console.Update exposing (..)

import App.Model exposing (SocketAction(..))
import UI.Console.Model exposing (..)
import UI.Console.Input exposing (process)


(=>) =
    (,)

update : Msg -> Model -> ( ( Model, Cmd Msg ), SocketAction )
update msg model =
    case msg of
        ToggleVisible ->
            ( { model | visible = not model.visible }, Cmd.none ) => NoAction

        SubmitInput ->
            process model

        SetInput input ->
            ( { model | input = input }, Cmd.none ) => NoAction

        ToggleInputFocus ->
            ( { model | hasFocus = not model.hasFocus }, Cmd.none ) => NoAction

        ToggleScrollBar ->
            ({ model | scroll = not model.scroll }) => Cmd.none => NoAction
