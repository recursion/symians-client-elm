module Chat.Model exposing (..)

import Phoenix.Socket
import Json.Encode as JE


-- CONSTANTS


socketServer : String
socketServer =
    "ws:/localhost:4000/socket/websocket"



-- MODEL


type Msg
    = SendMessage
    | SetNewMessage String
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ReceiveChatMessage JE.Value
    | JoinChannel
    | LeaveChannel
    | ShowJoinedMessage String
    | ShowLeftMessage String
    | NoOp


type alias Model =
    { newMessage : String
    , messages : List String
    , phxSocket : Phoenix.Socket.Socket Msg
    }



-- Used when initializing as standalone app


initPhxSocket : Phoenix.Socket.Socket Msg
initPhxSocket =
    Phoenix.Socket.init socketServer
        |> Phoenix.Socket.withDebug
        |> Phoenix.Socket.on "new:msg" "system:chat" ReceiveChatMessage



-- used when initializing as a module in a larger app


initWithSocket : Phoenix.Socket.Socket Msg -> Model
initWithSocket socket =
    let
        socketWithEvents =
            socket
                |> Phoenix.Socket.on "new:msg" "system:chat" ReceiveChatMessage
    in
        Model "" [] socketWithEvents



-- Used when initializing as standalone app


initModel : Model
initModel =
    Model "" [] initPhxSocket
