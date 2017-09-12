module App.Socket exposing (..)
{-| This module contains constants, init, and helper functions for working with phoenix-websocket
-}
import App.Model exposing (..)
import Phoenix.Socket
import Phoenix.Channel


-- Constants


socketServer : String
socketServer =
    "ws:/192.168.88.29:4000/socket/websocket"


worldDataEvent : String
worldDataEvent =
    "world"


authDataEvent : String
authDataEvent =
    "token"


systemChannel : String
systemChannel =
    "system:"


chatChannel : String
chatChannel =
    "system:chat"


chatEvent : String
chatEvent =
    "new:msg"



-- Init socket/channels


initPhxSocket : Phoenix.Socket.Socket Msg
initPhxSocket =
    Phoenix.Socket.init socketServer
        -- |> Phoenix.Socket.withDebug
        |> Phoenix.Socket.on authDataEvent systemChannel ReceiveToken
        |> Phoenix.Socket.on worldDataEvent systemChannel ReceiveWorldData


connectTo : String -> Model -> ( Model, Cmd Msg )
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

processPhoenixMsg : Phoenix.Socket.Msg Msg -> Model -> (Model, Cmd Msg)
processPhoenixMsg msg model =
    let
        ( phxSocket, phxCmd ) =
            Phoenix.Socket.update msg model.socket
    in
        ( { model | socket = phxSocket }
        , Cmd.map PhoenixMsg phxCmd
        )
