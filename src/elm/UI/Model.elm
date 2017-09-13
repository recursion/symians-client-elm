module UI.Model exposing (..)

import World.Model exposing (Location, initLocation)


type alias Model =
    { viewChat : Bool
    , viewInfo : Bool
    , currentTile : TileData
    , camera : Camera
    }


type alias TileData =
    { x : String
    , y : String
    , z : String
    , loc : Location
    }


type alias Camera =
    { x : Int
    , y : Int
    , z : Int
    , size : ( Int, Int )
    }


init : Model
init =
    { viewChat = False
    , viewInfo = True
    , currentTile = initTileData
    , camera = initCamera
    }


initCamera =
    { x = 0
    , y = 0
    , z = 0
    , size = ( 0, 0 )
    }


initTileData : TileData
initTileData =
    { x = "0", y = "0", z = "0", loc = initLocation }


toggleChat : Model -> Model
toggleChat model =
    { model | viewChat = not model.viewChat }


toggleInfoView : Model -> Model
toggleInfoView model =
    { model | viewInfo = not model.viewInfo }
