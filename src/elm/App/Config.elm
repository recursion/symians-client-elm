module App.Config exposing (..)

import App.Model exposing (..)
import Phoenix.Socket
import Phoenix.Channel
import Chat.Channel
import Auth


socketServer : String
socketServer =
    "ws:/localhost:4000/socket/websocket"

worldDataEvent : String
worldDataEvent = "world"

authDataEvent : String
authDataEvent =
    "token"

systemChannel : String
systemChannel =
    "system:"

chatChannel : String
chatChannel =
    "system:chat"


init =
    let
        socket =
            initPhxSocket

        ((chatModel, chatCmd), nextSocket) =
            Chat.Channel.initWithSocket "new:msg" chatChannel ChatMsg socket 

        model =
            Model nextSocket chatModel Auth.init initUI initWorldData initTileData

        (nextModel, nextCmd) = connectTo systemChannel model 
    in
        (nextModel, Cmd.batch [Cmd.map PhoenixMsg chatCmd, nextCmd])


initPhxSocket : Phoenix.Socket.Socket Msg
initPhxSocket =
    Phoenix.Socket.init socketServer
        -- |> Phoenix.Socket.withDebug
        |> Phoenix.Socket.on authDataEvent systemChannel ReceiveToken
        |> Phoenix.Socket.on worldDataEvent systemChannel ReceiveWorldData

connectTo : String -> Model -> (Model, Cmd Msg)
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
