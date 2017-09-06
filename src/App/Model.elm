module App.Model exposing (..)

import Phoenix.Socket
import Chat.Model
import Json.Encode as JE
import Auth

-- MODEL


type alias Model =
    { socket : Phoenix.Socket.Socket Msg
    , chat : Chat.Model.Model
    , auth : Auth.Model
    }


type Msg
    = ChatMsg Chat.Model.Msg
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ReceiveToken JE.Value
    | Connected
    | Disconnected
