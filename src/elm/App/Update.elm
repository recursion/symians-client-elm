module App.Update exposing (update)

import App.JsonHelpers exposing (decodeTokenMessage, decodeWorldData)
import App.Model exposing (..)
import Json.Decode as JD
import UI.Model as UI
import Dict exposing (Dict)
import Chat.Update
import Chat.Model
import App.Socket
import UI.Input as Input
import UI.Helpers


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleChatView ->
            { model | ui = UI.toggleChat model.ui } ! []

        ToggleInfo ->
            { model | ui = UI.toggleInfoView model.ui } ! []

        SetInspected posX posY location ->
            { model
                | ui =
                    UI.Helpers.setInspectedTile posX posY location model.ui
            }
                ! []

        ChatMsg message ->
            processChatMsg message model

        PhoenixMsg msg ->
            App.Socket.processPhoenixMsg msg model

        ReceiveToken raw ->
            processToken raw model

        ReceiveWorldData raw ->
            processWorldData raw model

        KeyMsg code ->
            Input.processKeypress code model ! []

        Connected ->
            model ! []

        Disconnected ->
            model ! []

        NoOp ->
            model ! []


{-| use locationsAsList for rendering
only generate a new list when we make changes to the locations dictionary.
TODO: Make sure anytime we change locations, we generate a new list
-}
processWorldData : JD.Value -> Model -> ( Model, Cmd Msg )
processWorldData raw model =
    case decodeWorldData raw of
        Ok world ->
            let
                nextWorld =
                    { locations = world.locations
                    , dimensions = world.dimensions
                    }
            in
                { model | world = nextWorld } ! []

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
