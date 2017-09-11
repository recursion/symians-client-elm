module App.Update exposing (update)

import App.JsonHelpers exposing (decodeTokenMessage, decodeWorldData)
import App.Model exposing (..)
import Chat.Update
import Phoenix.Socket


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleChatView ->
            let
                ui = model.ui
                nextUI = { ui | chatView = not ui.chatView }
            in
              { model | ui = nextUI } ! []

        ChatMsg message ->
            let
                (( chatModel, chatCommand ), nextSocket) =
                    Chat.Update.update message  model.auth model.socket model.chat

                nextModel = { model | socket = nextSocket }
            in
                ( { nextModel | chat = chatModel }, Cmd.map PhoenixMsg chatCommand )

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

        ReceiveWorldData raw ->
            case decodeWorldData raw of
                Ok world ->
                    {model | world = world} ! []

                Err error ->
                    ( model, Cmd.none )

        ActivateNav ->
            let
                ui = model.ui
                nav = ui.nav
                nextNav = { nav | isActive = not nav.isActive }
                nextUI = { ui | nav = nextNav }
            in
                { model | ui = nextUI } ! []

        Connected ->
            model ! []

        Disconnected ->
            model ! []
