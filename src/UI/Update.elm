module UI.Update exposing (update, camera)

import World.Models exposing (Coordinates)
import UI.Model exposing (..)
import UI.Input as Input
import UI.Camera as Camera


update : Bool -> Msg -> Model -> ( Model, Cmd Msg )
update inputHasFocus msg model =
    case msg of
        KeyMsg code ->
            Input.keypress code inputHasFocus model ! []

        WindowResized size ->
            { model | camera = Camera.resize size model.camera } ! []

        SetInspected coords location ->
            { model | inspector = Inspection coords location } ! []

        ToggleInspector ->
            { model | viewInspector = not model.viewInspector } ! []

        ToggleChatView ->
            { model | viewChat = not model.viewChat } ! []

        ToggleSelected coords ->
            if List.member coords model.selected then
                removeSelected coords model ! []
            else
                addSelected coords model ! []


removeSelected : Coordinates -> Model -> Model
removeSelected coords model =
    let
        notCoords = (\n -> n /= coords)
        nextSelected = List.filter notCoords model.selected
    in
        { model | selected = nextSelected }


addSelected : Coordinates -> Model -> Model
addSelected coords model =
    { model | selected = coords :: model.selected }


camera : Camera -> Model -> Model
camera camera model =
    { model | camera = camera }
