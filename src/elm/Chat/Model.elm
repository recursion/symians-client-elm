module Chat.Model exposing (..)

import Phoenix.Socket
import Json.Encode as JE
import Dict exposing (Dict)



newChatMsgEvent : String
newChatMsgEvent = "new:msg"


-- MODEL

type Msg
    = SendMessage
    | SetNewMessage String
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
    }

type alias ChatMessage =
    { user : String
    , body : String
    }

initWithSocket event channelName parentMsg socket =
    let
        channels = Dict.insert channelName (Channel []) Dict.empty
        socketWithChatEvent =
            socket
                |> Phoenix.Socket.on event channelName (parentMsg << ReceiveChatMessage)
    in
        (Model "" channelName channels, socketWithChatEvent)
