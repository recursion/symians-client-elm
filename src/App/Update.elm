module App.Update exposing (update)

import App.MsgHandlers as MsgHandlers
import App.Model exposing (..)
import App.Socket


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UIMsg message ->
            MsgHandlers.ui message model

        ChatMsg message ->
            MsgHandlers.chat message model

        PhoenixMsg msg ->
            App.Socket.processPhoenixMsg msg model

        ReceiveToken raw ->
            MsgHandlers.token raw model

        ReceiveWorldData raw ->
            MsgHandlers.world raw model

        Connected ->
            model ! []

        Disconnected ->
            model ! []

        NoOp ->
            model ! []
