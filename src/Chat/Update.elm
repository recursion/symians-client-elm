module Chat.Update exposing (update)

import Chat.Chat as Chat
import Chat.Model exposing (..)
import Chat.Channel as Channel
import Dict exposing (Dict)
import Auth


update : Msg -> Model -> Auth.Model -> ( Model, Cmd Msg )
update msg model auth =
    case msg of
        SetNewMessage str ->
            { model | newMessage = str } ! []

        PhoenixMsg msg ->
            Chat.processPhoenixMsg msg model

        ReceiveChatMessage raw ->
            Chat.processChatMessage raw model

        SendMessage ->
            Channel.send auth model

        JoinChannel ->
            Channel.join model

        LeaveChannel ->
            Channel.leave model

        ShowJoinedMessage channelName ->
            Channel.showJoinedMessage channelName model

        ShowLeftMessage channelName ->
            Channel.showLeftMessage channelName model

        NoOp ->
            ( model, Cmd.none )
