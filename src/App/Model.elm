module App.Model exposing (..)
import Phoenix.Socket
import Json.Encode as JE
import Auth


-- CONSTANTS

type Msg
    = SendMessage
    | Subscribe String String (JE.Value -> Msg)
    | SetNewMessage String
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ReceiveChatMessage JE.Value
    | ReceiveJoinMessage JE.Value
    | JoinChannel String
    | LeaveChannel String
    | JoinedChannel String
    | LeftChannel String
    | NoOp

type alias Model =
    { newMessage : String
    , messages : List String
    , socket : Phoenix.Socket.Socket Msg
    , auth : Auth.Model
    }
