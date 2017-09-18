module UI.Model exposing (..)

import World.Models exposing (Location, initLocation, Dimensions, Coordinates)
import Inspector.Model as Inspector
import Console.Model as Console
import Camera.Model as Camera
import Selector.Model as Selector
import Window
import Keyboard
import Task
import Mouse


type Msg
    = SelectorMsg Selector.Msg
    | WindowResized Window.Size
    | KeyMsg Keyboard.KeyCode
    | ConsoleMsg Console.Msg
    | InspectorMsg Inspector.Msg
    | MouseDown Mouse.Position
    | MouseUp Mouse.Position
    | MouseOver Coordinates Location


type alias Model =
    { window : Window
    , inspector : Inspector.Model
    , camera : Camera.Model
    , selector : Selector.Model
    , console : Console.Model
    , images : { loading : String }
    }


type alias Window =
    { width : Int, height : Int }

init : ( Model, Cmd Msg )
init =
    ( initModel, Task.perform WindowResized Window.size )


initModel : Model
initModel =
    Model initWindow Inspector.init Camera.init Selector.init Console.init { loading = "" }

initWindow : Window
initWindow =
    { width = 0, height = 0 }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs KeyMsg
        , Window.resizes WindowResized
        , Mouse.downs MouseDown
        , Mouse.ups MouseUp
        ]
