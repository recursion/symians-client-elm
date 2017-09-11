module App.Model exposing (..)

import Phoenix.Socket
import Chat.Model
import Json.Encode as JE
import Auth
import Dict exposing (Dict)

-- MODEL

type alias UI =
    { chatView : Bool
    , nav : {isActive: Bool}
    }

type alias Model =
    { socket : Phoenix.Socket.Socket Msg
    , chat : Chat.Model.Model
    , auth : Auth.Model
    , ui: UI
    , world: WorldData
    }


type Msg
    = ChatMsg Chat.Model.Msg
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ReceiveToken JE.Value
    | ReceiveWorldData JE.Value
    | Connected
    | Disconnected
    | ToggleChatView
    | ActivateNav

type alias WorldData =
    { locations : Locations
    , dimensions: Dimensions
    }

type alias Dimensions =
    { length: Int
    , width: Int
    , height: Int
    }
type alias Coordinates =
    { x: Int
    , y: Int
    , z: Int
    }
type alias Location =
    { entities : List String
    , type_ : String
    }
type alias Locations = Dict String Location


type alias Socket = Phoenix.Socket.Socket Msg
type alias SocketMsg = Phoenix.Socket.Msg Msg

initUI =
    { chatView = False
    , nav = { isActive = False }
    }

initWorldData =
    { locations = Dict.empty
    , dimensions = (Dimensions 0 0 0)
    }
