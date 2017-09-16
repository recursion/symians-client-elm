module App.Update exposing (update)

import App.Processors as Processors
import App.Model exposing (..)
import App.Socket


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UIMsg message ->
            Processors.ui message model

        ChatMsg message ->
            Processors.chat message model

        PhoenixMsg msg ->
            App.Socket.processPhoenixMsg msg model

        ReceiveToken raw ->
            Processors.token raw model

        ReceiveWorldData raw ->
            Processors.world raw model

        Connected ->
            model ! []

        Disconnected ->
            model ! []

        NoOp ->
            model ! []
