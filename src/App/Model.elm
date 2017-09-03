module App.Model exposing (Msg(..), Model, User)
import Phoenix.Socket
import Json.Encode as JE


-- CONSTANTS

type Msg
    = SendMessage
    | SetNewMessage String
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ReceiveChatMessage JE.Value
    | ReceiveJoinMessage JE.Value
    | JoinChannel String
    | LeaveChannel String
    | JoinedChannel String
    | LeftChannel String
    | NoOp


type alias User =
    { id : Maybe Int
    , token : Maybe String
    , status : String
    }

type alias Model =
    { newMessage : String
    , messages : List String
    , phxSocket : Phoenix.Socket.Socket Msg
    , user : User
    }
