module UI.Model exposing (..)

import World.Models exposing (Location, initLocation, Dimensions, Coordinates)
import Window
import Keyboard
import Task


type Msg
    = SetInspected Coordinates Location
    | ToggleSelected Coordinates
    | WindowResized Window.Size
    | KeyMsg Keyboard.KeyCode
    | ToggleConsole
    | ToggleInspector
    | SubmitConsoleInput
    | SetConsoleInput String
    | ToggleConsoleFocus
    | ToggleConsoleScrollBar



type alias Model =
    { viewConsole : Bool
    , viewInspector : Bool
    , inspector : Inspection
    , camera : Camera
    , selected : List Coordinates
    , consoleInput : String
    , consoleHasFocus : Bool
    , consoleScroll : Bool
    , images : { loading : String }
    }


type alias Inspection =
    { position : Coordinates
    , loc : Location
    }


type alias Camera =
    { position : Coordinates
    , worldDimensions : Dimensions
    , width : Int
    , height : Int
    }


init : ( Model, Cmd Msg )
init =
    ( { viewConsole = True
      , viewInspector = True
      , inspector = initInspector
      , camera = initCamera
      , selected = []
      , consoleInput = ""
      , consoleHasFocus = False
      , consoleScroll = False
      , images = { loading = "" }
      }
    , Task.perform WindowResized Window.size
    )


initModel : Model
initModel =
    Model False False initInspector initCamera [] "" False False { loading = "" }


initCamera : Camera
initCamera =
    { position = Coordinates 0 0 0 
    , worldDimensions = Dimensions 0 0 0
    , width = 0
    , height = 0
    }


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
