module Chat.Model exposing (..)

import Json.Encode as JE
import Dict exposing (Dict)


newChatMsgEvent : String
newChatMsgEvent =
    "new:msg"


defaultChannel : String
defaultChannel =
    "system:chat"



-- MODEL


type Msg
    = SendMessage
    | SetNewMessage String
    | ReceiveChatMessage JE.Value
    | JoinChannel
    | LeaveChannel
    | ShowJoinedMessage
    | ShowLeftMessage
    | ToggleChatInputFocus


type alias Model =
    { name : String
    , newMessage : String
    , inputHasFocus : Bool
    , messages : List String
    }


type alias ChatMessage =
    { user : String
    , body : String
    }

initData : (Msg, Msg, (String, (JE.Value -> Msg)))
initData =
    let
        onJoin =
            ShowJoinedMessage

        onClose =
            ShowLeftMessage

        subscriptionData =
            ( newChatMsgEvent, ReceiveChatMessage )
    in
        ( onJoin, onClose, subscriptionData )


initModel channelName =
    Model channelName "" False []
