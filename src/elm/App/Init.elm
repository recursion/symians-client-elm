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
