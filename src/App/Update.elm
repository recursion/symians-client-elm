module App.Update exposing (update)

import App.Model exposing (..)
import Messages.Handlers as Msgs
import Channels.Channel as Channel


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
            Channel.subscribe event channel handler model

        SendMessage ->
            Msgs.send model

        JoinChannel channel ->
            Channel.join model channel

        LeaveChannel channel ->
            Channel.leave model channel

        JoinedChannel channelName ->
            Channel.joined model channelName

        LeftChannel channelName ->
            Channel.left model channelName

        NoOp ->
            model ! []
