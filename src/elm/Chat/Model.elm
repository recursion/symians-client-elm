module Chat.Model exposing (..)

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
    | ToggleChatInputFocus
    | NoOp

type alias Channel = { messages: List String }
type alias Channels = Dict String Channel

type alias Model =
    { newMessage : String
    , inputHasFocus : Bool
    , currentChannel : String
    , channels : Channels
    }

type alias ChatMessage =
    { user : String
    , body : String
    }
