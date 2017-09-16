module Chat.Model exposing (..)

import Json.Encode as JE


newMsgEvent : String
newMsgEvent =
    "new:msg"


defaultChannel : String
defaultChannel =
    "system:chat"



-- MODEL


type Msg
    = ReceiveChatMessage JE.Value
    | JoinChannel
    | LeaveChannel
    | ShowJoinedMessage
    | ShowLeftMessage


type alias Model =
    { name : String
    , messages : List String
    }


type alias ChatMessage =
    { user : String
    , body : String
    }


initData : ( Msg, Msg, ( String, JE.Value -> Msg ) )
initData =
    ( ShowJoinedMessage, ShowLeftMessage
    , ( newMsgEvent, ReceiveChatMessage )
    )

initModel : String -> Model
initModel channelName =
    Model channelName []
