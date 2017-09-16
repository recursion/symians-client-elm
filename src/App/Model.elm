module App.Model exposing (..)

import Phoenix.Socket
import Chat.Model
import Json.Encode as JE
import App.Auth as Auth
import UI.Model as UI
import World.Models as World
import Chat.Model as Chat

-- MODEL

type alias Encoder = (String -> JE.Value)
type alias Decoder = (JE.Value -> Msg)


type alias Socket =
    Phoenix.Socket.Socket Msg


type alias SocketMsg =
    Phoenix.Socket.Msg Msg

type State
    = Loading
    | Loaded World.Model

type alias Model =
    { socket : Socket
    , chat : Chat.Model.Model
    , auth : Auth.Model
    , ui : UI.Model
    , world : State
    }

type alias Flags =
    { images :
          {loading: String}
    }

type SocketAction
    = Join String
    | JoinWithHandlers String Chat.Msg Chat.Msg
    | Leave String
    | Send String Encoder
    | NoAction

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
    Model socket chatModel Auth.init UI.initModel Loading


init : Socket -> Chat.Model.Model -> ( Model, Cmd Msg )
init socket chatModel =
    let
        ( uiModel, uiCmd ) =
            UI.init
    in
        ( Model socket chatModel Auth.init uiModel Loading
        , Cmd.map UIMsg uiCmd
        )
