module App.Model exposing (..)

import Phoenix.Socket
import Chat.Model
import Json.Encode as JE
import App.Auth as Auth
import UI.Model as UI
import World.Model as World
import Keyboard


-- MODEL


type alias Model =
    { socket : Phoenix.Socket.Socket Msg
    , chat : Chat.Model.Model
    , auth : Auth.Model
    , ui : UI.Model
    , world : World.Model
    }


initModel socket chatModel =
    Model socket chatModel Auth.init UI.init World.init


type Msg
    = ChatMsg Chat.Model.Msg
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ReceiveToken JE.Value
    | ReceiveWorldData JE.Value
    | SetInspected String String World.Location
    | Connected
    | Disconnected
    | ToggleChatView
    | ToggleInfo
    | KeyMsg Keyboard.KeyCode
    | NoOp


type alias Socket =
    Phoenix.Socket.Socket Msg


type alias SocketMsg =
    Phoenix.Socket.Msg Msg
