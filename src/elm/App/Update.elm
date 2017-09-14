module App.Update exposing (update)

import Json.Decode as JD
import World.Decoders exposing (decodeWorldData)
import App.Socket exposing (SocketCmdMsg(..))
import App.Auth exposing (decodeTokenMessage)
import App.Model exposing (..)
import Chat.Update
import Chat.Model
import UI.Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UIMsg message ->
            UI.Update.update message model

        ChatMsg message ->
            processChatMsg message model

        PhoenixMsg msg ->
            App.Socket.processPhoenixMsg msg model

        ReceiveToken raw ->
            processToken raw model

        ReceiveWorldData raw ->
            processWorldData raw model

        Connected ->
            model ! []

        Disconnected ->
            model ! []

        App.Model.NoOp ->
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

                ui =
                    model.ui

                camera =
                    model.ui.camera

                nextCamera =
                    { camera | worldDimensions = world.dimensions }

                nextUI =
                    { ui | camera = nextCamera }

                nextModel =
                    { model | ui = nextUI }
            in
                { nextModel | world = nextWorld } ! []

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
        ( ( chatModel, chatCommand ), msg ) =
            Chat.Update.update message model.chat

        ( nextModel, cmd ) =
            App.Socket.externalMsg msg model
    in
        ( { nextModel | chat = chatModel }
        , Cmd.batch [ Cmd.map ChatMsg chatCommand, cmd ]
        )
