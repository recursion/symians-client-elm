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
    | ShowJoinedMessage String
    | ShowLeftMessage String
    | ToggleChatInputFocus


type alias Channel =
    { messages : List String }


type alias Channels =
    Dict String Channel


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


init channelName =
    let
        onJoin =
            ShowJoinedMessage channelName

        onClose =
            ShowLeftMessage channelName

        subscriptionData =
            ( newChatMsgEvent, channelName, ReceiveChatMessage )
    in
        ( onJoin, onClose, subscriptionData )


initModel channelName =
    Dict.insert channelName (Channel []) Dict.empty
        |> Model "" False channelName
