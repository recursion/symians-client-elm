module App.Config exposing (..)

import App.Model exposing (..)
import Phoenix.Socket
import Phoenix.Channel
import Chat.Model
import Auth


socketServer : String
socketServer =
    "ws:/localhost:4000/socket/websocket"


authDataEvent =
    "token"


systemChannel =
    "system:"


chatChannel =
    "system:chat"


init : ( Model, Cmd Msg )
init =
    let
        socket =
            initPhxSocket

        chatModel =
            Chat.Model.initModel chatChannel

        model =
            Model socket chatModel Auth.init
    in
        connectTo systemChannel model


initPhxSocket : Phoenix.Socket.Socket Msg
initPhxSocket =
    Phoenix.Socket.init socketServer
        |> Phoenix.Socket.withDebug
        |> Phoenix.Socket.on authDataEvent systemChannel ReceiveToken


connectTo channelName model =
    let
        channel =
            Phoenix.Channel.init channelName
                -- this is where the user token should get attached
                -- |> Phoenix.Channel.withPayload userParams
                |> Phoenix.Channel.onJoin (always (Connected))
                |> Phoenix.Channel.onClose (always (Disconnected))

        ( socket, phxCmd ) =
            Phoenix.Socket.join channel model.socket
    in
        ( { model | socket = socket }
        , Cmd.map PhoenixMsg phxCmd
        )
