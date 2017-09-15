module App.Processors exposing (..)

import Json.Decode as JD
import World.Decoders exposing (decodeWorldData)
import World.Model as World
import App.Socket as Socket
import App.Auth exposing (decodeTokenMessage)
import App.Model exposing (..)
import UI.Camera as Camera
import UI.Update
import Chat.Update
import Chat.Model
import UI.Model


ui : UI.Model.Msg -> Model -> ( Model, Cmd Msg )
ui message model =
    let
        ( uiModel, uiCmd ) =
            UI.Update.update model.chat.inputHasFocus message model.ui
    in
        ( { model | ui = uiModel }, Cmd.map UIMsg uiCmd )


world : JD.Value -> Model -> ( Model, Cmd Msg )
world raw model =
    case decodeWorldData raw of
        Ok world ->
            insertWorldData world model ! []

        Err error ->
            ( model, Cmd.none )


insertWorldData : World.Model -> Model -> Model
insertWorldData world model =
    let
        nextWorld =
            { locations = world.locations
            , dimensions = world.dimensions
            }

        nextCamera =
            Camera.updateDimensions
                world.dimensions
                model.ui.camera
    in
        { model
            | world = Loaded nextWorld
            , ui = UI.Update.camera nextCamera model.ui
        }


token : JD.Value -> Model -> ( Model, Cmd Msg )
token raw model =
    case decodeTokenMessage raw of
        Ok token ->
            ( { model | auth = token }
            , Cmd.none
            )

        Err error ->
            ( model, Cmd.none )


chat : Chat.Model.Msg -> Model -> ( Model, Cmd Msg )
chat message model =
    let
        ( ( chatModel, chatCommand ), msg ) =
            Chat.Update.update message model.chat

        ( nextModel, cmd ) =
            externalMsg msg model
    in
        ( { nextModel | chat = chatModel }
        , Cmd.batch [ Cmd.map ChatMsg chatCommand, cmd ]
        )


externalMsg : SocketAction -> Model -> ( Model, Cmd Msg )
externalMsg msg model =
    case msg of
        Send event channel encoder ->
            Socket.send event channel encoder model

        Join channel ->
            Socket.join channel model

        JoinWithHandlers channel onJoin onLeave ->
            Socket.joinWithHandlers
                channel
                (always (ChatMsg onJoin))
                (always (ChatMsg onLeave))
                model

        Leave channel ->
            Socket.leave channel model

        NoAction ->
            ( model, Cmd.none )
