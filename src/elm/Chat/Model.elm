module Chat.Model exposing (..)

import Phoenix.Socket
import Json.Encode as JE
import Dict exposing (Dict)


-- CONSTANTS


socketServer : String
socketServer =
    "ws:/localhost:4000/socket/websocket"

newChatMsgEvent = "new:msg"


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

type alias Channel = { messages: List String }
type alias Channels = Dict String Channel

type alias Model =
    { newMessage : String
    , currentChannel : String
    , channels : Channels
    , phxSocket : Phoenix.Socket.Socket Msg
    }


type alias ChatMessage =
    { user : String
    , body : String
    }




-- Used when initializing as standalone app


initPhxSocket : String -> Phoenix.Socket.Socket Msg
initPhxSocket channelName =
    Phoenix.Socket.init socketServer
        -- |> Phoenix.Socket.withDebug
        |> Phoenix.Socket.on newChatMsgEvent channelName ReceiveChatMessage



-- used when initializing as a module in a larger app


initWithSocket : String -> String -> Phoenix.Socket.Socket Msg -> Model
initWithSocket event channelName socket =
    let
        channels = Dict.insert channelName (Channel []) Dict.empty
        socketWithChatEvent =
            socket
                |> Phoenix.Socket.on event channelName ReceiveChatMessage
    in
        Model "" channelName channels socketWithChatEvent



-- Used when initializing as standalone app


initModel : String -> Model
initModel name =
    let
        channels = Dict.insert name (Channel []) Dict.empty
    in
      Model "" name channels (initPhxSocket name)
