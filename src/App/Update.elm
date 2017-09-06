module App.Update exposing (update)

import App.Model exposing (..)
import Chat.Chat as Chat
import Chat.Update
import Phoenix.Socket
import App.JsonHelpers exposing (decodeTokenMessage)


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChatMsg message ->
            let
                ( chatModel, chatCommand ) =
                    Chat.Update.update message model.chat model.auth
            in
                ( { model | chat = chatModel }, Cmd.map ChatMsg chatCommand )

        PhoenixMsg msg ->
            let
                ( phxSocket, phxCmd ) =
                    Phoenix.Socket.update msg model.socket
            in
                ( { model | socket = phxSocket }
                , Cmd.map PhoenixMsg phxCmd
                )

        ReceiveToken raw ->
            case decodeTokenMessage raw of
                Ok token ->
                    ( { model | auth = token }
                    , Cmd.none
                    )

                Err error ->
                    ( model, Cmd.none )

        Connected ->
            model ! []

        Disconnected ->
            model ! []
