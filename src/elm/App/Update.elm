module App.Update exposing (update)

import App.JsonHelpers exposing (decodeTokenMessage, decodeWorldData)
import App.Model exposing (..)
import Json.Decode as JD
import UI.Model as UI
import Keyboard
import Chat.Update
import Chat.Model
import App.Socket
import UI.Camera as Camera


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleChatView ->
            { model | ui = UI.toggleChat model.ui } ! []

        ToggleInfo ->
            { model | ui = UI.toggleInfoView model.ui } ! []

        DisplayTile posX posY location ->
            { model | tileData = UI.displayTile posX posY location model.tileData } ! []

        ChatMsg message ->
            processChatMsg message model

        PhoenixMsg msg ->
            App.Socket.processPhoenixMsg msg model

        ReceiveToken raw ->
            processToken raw model

        ReceiveWorldData raw ->
            processWorldData raw model

        KeyMsg code ->
            processKeypress code model ! []

        Connected ->
            model ! []

        Disconnected ->
            model ! []

        NoOp ->
            model ! []


updateCamera action model =
    let
        ui =
            model.ui

        nextCamera =
            action model.ui.camera

        nextUI =
            { ui | camera = nextCamera }
    in
        { model | ui = nextUI }


processKeypress : Keyboard.KeyCode -> Model -> Model
processKeypress code model =
    let
        nextModel =
            if not model.chat.inputHasFocus then
                case code of
                    82 ->
                        model

                    70 ->
                        model

                    87 ->
                        updateCamera Camera.moveUp model

                    83 ->
                        updateCamera Camera.moveDown model

                    65 ->
                        updateCamera Camera.moveLeft model

                    68 ->
                        updateCamera Camera.moveRight model

                    _ ->
                        model
            else
                model
    in
        nextModel


processWorldData : JD.Value -> Model -> ( Model, Cmd Msg )
processWorldData raw model =
    case decodeWorldData raw of
        Ok world ->
            { model | world = world } ! []

        Err error ->
            ( model, Cmd.none )


processToken : JD.Value -> Model -> ( Model, Cmd Msg )
processToken raw model =
    case decodeTokenMessage raw of
        Ok token ->
            ( { model | auth = token }
            , Cmd.none
            )

        Err error ->
            ( model, Cmd.none )


processChatMsg : Chat.Model.Msg -> Model -> ( Model, Cmd Msg )
processChatMsg message model =
    let
        ( ( chatModel, chatCommand ), nextSocket ) =
            Chat.Update.update message model.auth model.socket model.chat

        nextModel =
            { model | socket = nextSocket }
    in
        ( { nextModel | chat = chatModel }, Cmd.map PhoenixMsg chatCommand )
