module App.Model exposing (..)
import Phoenix.Socket
import Chat.Model
import Json.Encode as JE
import Auth

socketServer : String
socketServer =
    "ws:/localhost:4000/socket/websocket"


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


init : ( Model, Cmd Msg )
init =
    let
        socket = initPhxSocket
        chatModel = Chat.Model.initModel
    in
      ( Model socket chatModel Auth.init, Cmd.none )


initPhxSocket : Phoenix.Socket.Socket Msg
initPhxSocket =
    Phoenix.Socket.init socketServer
        |> Phoenix.Socket.withDebug
        |> Phoenix.Socket.on "token" "system:" ReceiveToken

