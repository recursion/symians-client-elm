module UI.Update exposing (update, camera)

import World.Models exposing (Coordinates)
import UI.Model exposing (..)
import UI.Input as Input
import UI.Camera as Camera
import App.Model exposing (SocketAction(..))
import UI.Console as Console


(=>) =
    (,)


update : Msg -> Model -> ( ( Model, Cmd Msg ), SocketAction )
update msg model =
    case msg of
        KeyMsg code ->
            Input.keypress code model

        WindowResized size ->
            ( { model | camera = Camera.resize size model.camera }, Cmd.none ) => NoAction

        SetInspected coords location ->
            ( { model | inspector = Inspection coords location }, Cmd.none ) => NoAction

        ToggleInspector ->
            ( { model | viewInspector = not model.viewInspector }, Cmd.none ) => NoAction

        ToggleConsole ->
            ( { model | viewConsole = not model.viewConsole }, Cmd.none ) => NoAction

        ToggleSelected coords ->
            toggleSelected coords model

        SubmitConsoleInput ->
            Console.process model

        SetConsoleInput input ->
            ( { model | consoleInput = input }, Cmd.none ) => NoAction

        ToggleConsoleFocus ->
            ( { model | consoleHasFocus = not model.consoleHasFocus }, Cmd.none ) => NoAction


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


camera : Camera -> Model -> Model
camera camera model =
    { model | camera = camera }
