module App.Update exposing (update)

import Dict exposing (Dict)
import Json.Decode as JD
import Window

import World.Decoders exposing (decodeWorldData)
import App.Socket exposing (SocketCmdMsg(..))
import App.Auth exposing (decodeTokenMessage)
import App.Model exposing (..)

import Chat.Update
import Chat.Model

import UI.Model as UI
import UI.Input as Input
import UI.Helpers

import World.Model
import World.Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ResizeWindow size ->
            resizeWindow size model ! []

        ToggleSelected x y z ->
            setSelected x y z model ! []

        ToggleChatView ->
            { model | ui = UI.toggleChat model.ui } ! []

        ToggleInfo ->
            { model | ui = UI.toggleInfoView model.ui } ! []

        SetInspected posX posY posZ location ->
            { model | ui = UI.Helpers.setInspectedTile posX posY posZ location model.ui } ! []

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

        App.Model.NoOp ->
            model ! []


resizeWindow : Window.Size -> Model -> Model
resizeWindow size model =
    let
        camera =
            model.ui.camera

        nextCamera =
            { camera | width = size.width, height = size.height }

        ui =
            model.ui

        nextUI =
            { ui | camera = nextCamera }
    in
        { model | ui = nextUI }


setSelected : String -> String -> String -> Model -> Model
setSelected x y z model =
    let
        coordsAsString =
            World.Location.hashCoords x y z

        target =
            Maybe.withDefault
                World.Model.initLocation
                (Dict.get coordsAsString model.world.locations)

        nextLocations =
            Dict.insert
                coordsAsString
                { target | selected = not target.selected }
                model.world.locations

        world =
            model.world

        nextWorld =
            { world | locations = nextLocations }
    in
        { model | world = nextWorld }


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
        ( ( chatModel, chatCommand ), msg ) =
            Chat.Update.update message model.chat

        ( nextModel, cmd ) =
            App.Socket.externalMsg msg model
    in
        ( { nextModel | chat = chatModel }
        , Cmd.batch [ Cmd.map ChatMsg chatCommand, cmd ]
        )

