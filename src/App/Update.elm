module App.Update exposing (update)

import App.Model exposing (..)
import Messages.Handlers as Msgs
import Sockets.Socket as Socket


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetNewMessage str ->
            { model | newMessage = str } ! []

        ReceiveJoinMessage raw ->
            Msgs.join model raw

        ReceiveChatMessage raw ->
            Msgs.chat model raw

        PhoenixMsg msg ->
            Msgs.phoenix model msg

        Subscribe event channel handler ->
            Socket.subscribe event channel handler model

        SendMessage ->
            Msgs.send model

        JoinChannel channel ->
            Socket.join model channel

        LeaveChannel channel ->
            Socket.leave model channel

        JoinedChannel channelName ->
            Socket.joined model channelName

        LeftChannel channelName ->
            Socket.left model channelName

        NoOp ->
            model ! []
