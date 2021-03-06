module App.Init exposing (..)

{-| initialize everything that uses sockets
-}

import App.Model exposing (..)
import Chat.Model as Chat
import App.Socket as Socket


worldDataEvent : String
worldDataEvent =
    "world"


authDataEvent : String
authDataEvent =
    "token"


systemChannel : String
systemChannel =
    "system:"


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        ( initialModel, uiCmd ) =
            App.Model.init Socket.initPhxSocket <|
                Chat.initModel Chat.defaultChannel

        ( nextModel, systemCmd ) =
            system initialModel

        ( lastModel, chatCmd ) =
            chat ChatMsg Chat.defaultChannel nextModel
    in
        ( loadImages lastModel flags.images
        , Cmd.batch [ uiCmd, systemCmd, chatCmd ]
        )

loadImages model images =
    let
        ui = model.ui
    in
        { model | ui = { ui | images = images } }


chat : (Chat.Msg -> Msg) -> String -> Model -> ( Model, Cmd Msg )
chat parentMsg name model =
    let
        ( chatOnJoin, chatOnLeave, ( event, receiveChatMsgHandler ) ) =
            Chat.initData
    in
        model
            |> Socket.subscribe event name (parentMsg << receiveChatMsgHandler)
            |> Socket.joinWithHandlers
                name
                (always (parentMsg chatOnJoin))
                (always (parentMsg chatOnLeave))


system : Model -> ( Model, Cmd Msg )
system model =
    model
        |> Socket.subscribe authDataEvent systemChannel ReceiveToken
        |> Socket.subscribe worldDataEvent systemChannel ReceiveWorldData
        |> Socket.joinWithHandlers
            systemChannel
            (always (Connected))
            (always (Disconnected))
