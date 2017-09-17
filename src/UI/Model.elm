module UI.Model exposing (..)

import World.Models exposing (Location, initLocation, Dimensions, Coordinates)
import Console.Model as Console
import Camera.Model as Camera
import Window
import Keyboard
import Task


type Msg
    = SetInspected Coordinates Location
    | ToggleSelected Coordinates
    | WindowResized Window.Size
    | KeyMsg Keyboard.KeyCode
    | ToggleInspector
    | ConsoleMsg Console.Msg


type alias Model =
    { window : Window
    , viewInspector : Bool
    , inspector : Inspection
    , camera : Camera.Model
    , selected : List Coordinates
    , console : Console.Model
    , images : { loading : String }
    }


type alias Inspection =
    { position : Coordinates
    , loc : Location
    }

type alias Window =
    { width : Int, height : Int }


init : ( Model, Cmd Msg )
init =
    ( initModel, Task.perform WindowResized Window.size )


initModel : Model
initModel =
    Model initWindow False initInspector Camera.initCamera [] Console.initConsole { loading = "" }


initWindow : Window
initWindow =
    { width = 0, height = 0 }


initInspector : Inspection
initInspector =
    { position = Coordinates 0 0 0
    , loc = initLocation
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs KeyMsg
        , Window.resizes WindowResized
        ]
