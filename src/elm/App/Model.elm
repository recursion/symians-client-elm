module App.Model exposing (..)

import Phoenix.Socket
import Chat.Model
import Json.Encode as JE
import App.Auth as Auth
import UI.Model as UI
import World.Model as World


-- MODEL

type alias Socket =
    Phoenix.Socket.Socket Msg


type alias SocketMsg =
    Phoenix.Socket.Msg Msg


type alias Model =
    { socket : Socket
    , chat : Chat.Model.Model
    , auth : Auth.Model
    , ui : UI.Model
    , world : World.Model
    }



type Msg
    = ChatMsg Chat.Model.Msg
    | UIMsg UI.Msg
    | PhoenixMsg SocketMsg
    | ReceiveToken JE.Value
    | ReceiveWorldData JE.Value
    | Connected
    | Disconnected
    | NoOp

initModel : Socket -> Chat.Model.Model -> Model
initModel socket chatModel =
    Model socket chatModel Auth.init UI.init World.init
