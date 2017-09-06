module Chat.Update exposing (update)

import Chat.Model exposing (..)
import Chat.Channel as Channel
import Phoenix.Socket
import Auth


update : Msg -> Model -> Auth.Model -> ( Model, Cmd Msg )
update msg model auth =
    case msg of
        SetNewMessage str ->
            { model | newMessage = str } ! []

        PhoenixMsg msg ->
            processPhoenixMsg msg model

        ReceiveChatMessage raw ->
            Channel.processChatMessage raw model

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



processPhoenixMsg msg model =
    let
        ( phxSocket, phxCmd ) =
            Phoenix.Socket.update msg model.phxSocket
    in
        ( { model | phxSocket = phxSocket }
        , Cmd.map PhoenixMsg phxCmd
        )
