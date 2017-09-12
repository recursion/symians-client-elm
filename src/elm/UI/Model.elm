module UI.Model exposing (..)

import World.Model exposing (Location, initLocation)


type alias Model =
    { viewChat : Bool
    , viewInfo : Bool
    , nav : { isActive : Bool }
    , camera : Camera
    }

type alias TileData =
    { x : String
    , y : String
    , loc : Location
    }

type alias Camera =
    { x: Int
    , y: Int
    , z: Int
    , size : (Int, Int)
    }

initCamera =
    { x = 0
    , y = 0
    , z = 0
    , size = (0, 0)
    }

initTileData : TileData
initTileData = { x = "0", y = "0", loc = initLocation}


init : Model
init =
    { viewChat = False
    , viewInfo = False
    , nav = { isActive = False }
    , camera = initCamera
    }


toggleChat : Model -> Model
toggleChat model =
    { model | viewChat = not model.viewChat }

toggleInfoView : Model -> Model
toggleInfoView model =
    { model | viewInfo = not model.viewInfo }

displayTile posX posY location model =
    { model | x = posX, y = posY, loc = location }
