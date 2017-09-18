module UI.Update exposing (update)

import UI.Model exposing (..)
import UI.Input as Input
import UI.Camera.Utils as Camera
import App.Model exposing (SocketAction(..))
import UI.Console.Update as Console
import UI.Inspector.Update as Inspector
import UI.Inspector.Model
import Utils exposing ((=>))
import UI.Selector.Update as Selector
import UI.Selector.Model


update : Msg -> Model -> ( ( Model, Cmd Msg ), SocketAction )
update msg model =
    case msg of
        KeyMsg code ->
            Input.keypress code model

        MouseDown pos ->
            ( { model
                | selector =
                    (Selector.update UI.Selector.Model.Enable) model.selector
              }
            , Cmd.none
            )
                => NoAction

        MouseUp pos ->
            ( { model
                | selector =
                    Selector.update (UI.Selector.Model.Disable) model.selector
              }
            , Cmd.none
            )
                => NoAction

        MouseOver coords loc ->
            let
                selectorModel =
                    Selector.update (UI.Selector.Model.MouseOver coords) model.selector

                ( inspectorModel, cmd ) =
                    Inspector.update
                        (UI.Inspector.Model.SetInspected coords loc)
                        model.inspector
            in
                ( { model
                    | selector = selectorModel
                    , inspector = inspectorModel
                  }
                , Cmd.batch [ Cmd.map InspectorMsg cmd ]
                )
                    => NoAction

        WindowResized size ->
            ( { model
                | camera = Camera.resize size model.camera
                , window = size
              }
            , Cmd.none
            )
                => NoAction

        SelectorMsg message ->
            let
                selectorModel =
                    Selector.update message model.selector
            in
                ( { model | selector = selectorModel }, Cmd.none ) => NoAction

        InspectorMsg message ->
            let
                ( inspModel, cmd ) =
                    Inspector.update message model.inspector
            in
                ( { model | inspector = inspModel }, Cmd.map InspectorMsg cmd ) => NoAction

        ConsoleMsg message ->
            let
                ( ( consoleModel, consoleCmd ), action ) =
                    Console.update message model.console
            in
                ( ( { model | console = consoleModel }, Cmd.map ConsoleMsg consoleCmd ), action )
