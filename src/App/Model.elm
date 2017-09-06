module App.Model exposing (..)

import Phoenix.Socket
import Chat.Model
import Json.Encode as JE
import Auth

-- MODEL

type View
    = Chat
    | World

type alias UI =
    { viewing: View
    }

type alias Model =
    { socket : Phoenix.Socket.Socket Msg
    , chat : Chat.Model.Model
    , auth : Auth.Model
    , ui: UI
    }


type Msg
    = ChatMsg Chat.Model.Msg
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ReceiveToken JE.Value
    | Connected
    | Disconnected
    | ChangeView View

initUI =
    { viewing = World }
