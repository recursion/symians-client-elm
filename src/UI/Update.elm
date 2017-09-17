module UI.Update exposing (update, camera)

import World.Models exposing (Coordinates)
import UI.Model exposing (..)
import UI.Input as Input
import Camera.Utils as Camera
import App.Model exposing (SocketAction(..))
import Camera.Model
import Console.Update as Console
import Utils exposing ((=>))


update : Msg -> Model -> ( ( Model, Cmd Msg ), SocketAction )
update msg model =
    case msg of
        KeyMsg code ->
            Input.keypress code model

        WindowResized size ->
            manageResize size model

        SetInspected coords location ->
            ( { model | inspector = Inspection coords location }, Cmd.none ) => NoAction

        ToggleInspector ->
            ( { model | viewInspector = not model.viewInspector }, Cmd.none ) => NoAction

        ToggleSelected coords ->
            toggleSelected coords model

        ConsoleMsg message ->
            processConsoleMessage message model


processConsoleMessage message model =
    let
        ( ( consoleModel, consoleCmd ), action ) =
            Console.update message model.console
    in
        ( ( { model | console = consoleModel }, Cmd.map ConsoleMsg consoleCmd ), action )


manageResize size model =
    ( { model
        | camera = Camera.resize size model.camera
        , window = size
      }
    , Cmd.none
    )
        => NoAction


toggleSelected : Coordinates -> Model -> ( ( Model, Cmd Msg ), SocketAction )
toggleSelected coords model =
    if List.member coords model.selected then
        ( ( removeSelected coords model, Cmd.none ), NoAction )
    else
        ( ( addSelected coords model, Cmd.none ), NoAction )


removeSelected : Coordinates -> Model -> Model
removeSelected coords model =
    let
        notCoords =
            (\n -> n /= coords)

        nextSelected =
            List.filter notCoords model.selected
    in
        { model | selected = nextSelected }


addSelected : Coordinates -> Model -> Model
addSelected coords model =
    { model | selected = coords :: model.selected }


camera : Camera.Model.Model -> Model -> Model
camera camera model =
    { model | camera = camera }
