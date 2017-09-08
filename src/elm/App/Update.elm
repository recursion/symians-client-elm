module App.Update exposing (update)

import App.Model exposing (..)
import Chat.Chat as Chat
import Chat.Model
import Chat.Update
import Phoenix.Socket
import App.JsonHelpers exposing (decodeTokenMessage, decodeWorldData)


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChatMsg message ->
              case message of
                  Chat.Model.NoOp ->
                      model ! []
                  _ ->
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

        ChangeView view ->
            let
                ui = model.ui
                nextUI = { ui | viewing = view }
            in
              { model | ui = nextUI } ! []
