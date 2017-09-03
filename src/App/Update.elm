module App.Update exposing (update)

import Phoenix.Socket
import App.Model exposing (..)
import Messages.Handlers as Msgs
import App.Channels as Channel


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PhoenixMsg msg ->
            Msgs.phoenix model msg

        SetNewMessage str ->
            { model | newMessage = str } ! []

        SendMessage ->
            Msgs.send model

        ReceiveJoinMessage raw ->
            Msgs.join model raw

        ReceiveChatMessage raw ->
            Msgs.chat model raw

        JoinChannel channel ->
            Channel.join model channel

        LeaveChannel channel ->
            Channel.leave model channel

        JoinedChannel channelName ->
            Channel.joined model channelName

        LeftChannel channelName ->
            Channel.left model channelName

        Subscribe event channel handler ->
            let
                socket =
                    model.phxSocket
                        |> Phoenix.Socket.on event channel handler
            in
                { model | phxSocket = socket } ! []

        NoOp ->
            model ! []
