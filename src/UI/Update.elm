module UI.Update exposing (update, camera)

import World.Models exposing (Coordinates)
import UI.Model exposing (..)
import UI.Input as Input
import UI.Camera as Camera
import Chat.Model as Chat
import App.Model exposing (SocketAction(..))
import Chat.Decoders exposing (encodeChatMessage)


(=>) =
    (,)


update : Chat.Model -> Msg -> Model -> ( ( Model, Cmd Msg ), SocketAction )
update chat msg model =
    case msg of
        KeyMsg code ->
            ( (Input.keypress code model), Cmd.none ) => NoAction

        WindowResized size ->
            ( { model | camera = Camera.resize size model.camera }, Cmd.none ) => NoAction

        SetInspected coords location ->
            ( { model | inspector = Inspection coords location }, Cmd.none ) => NoAction

        ToggleInspector ->
            ( { model | viewInspector = not model.viewInspector }, Cmd.none ) => NoAction

        ToggleConsole ->
            ( { model | viewConsole = not model.viewConsole }, Cmd.none ) => NoAction

        ToggleSelected coords ->
            if List.member coords model.selected then
                ( ( removeSelected coords model, Cmd.none ), NoAction )
            else
                ( ( addSelected coords model, Cmd.none ), NoAction )

        SubmitConsoleInput ->
            ( { model | consoleInput = "" }, Cmd.none ) => processConsoleInput chat model

        SetConsoleInput input ->
            ( { model | consoleInput = input }, Cmd.none ) => NoAction

        ToggleConsoleFocus ->
            ( { model | consoleHasFocus = not model.consoleHasFocus }, Cmd.none ) => NoAction

        ConsoleInput keycode ->
            case keycode of
                13 ->
                    ( { model | consoleInput = "" }
                    , Cmd.none
                    )
                        => processConsoleInput chat model

                _ ->
                    ( model, Cmd.none ) => NoAction


processConsoleInput chat model =
    case (String.left 1 model.consoleInput) of
        "\\" ->
            Debug.log ("Got console input: " ++ model.consoleInput) NoAction

        _ ->
            Send Chat.newChatMsgEvent chat.name (encodeChatMessage model.consoleInput)


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
