module App.Model exposing (..)

import Phoenix.Socket
import Chat.Model
import Json.Encode as JE
import App.Auth as Auth
import UI.Model as UI
import World.Model exposing (WorldData, Location, initWorldData)


-- MODEL


type alias Model =
    { socket : Phoenix.Socket.Socket Msg
    , chat : Chat.Model.Model
    , auth : Auth.Model
    , ui : UI.Model
    , world : WorldData
    , tileData : UI.TileData
    }


initModel socket chatModel =
    Model socket chatModel Auth.init UI.init initWorldData UI.initTileData


type Msg
    = ChatMsg Chat.Model.Msg
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ReceiveToken JE.Value
    | ReceiveWorldData JE.Value
    | DisplayTile String String Location
    | Connected
    | Disconnected
    | ToggleChatView
    | ToggleInfo


type alias Socket =
    Phoenix.Socket.Socket Msg


type alias SocketMsg =
    Phoenix.Socket.Msg Msg
