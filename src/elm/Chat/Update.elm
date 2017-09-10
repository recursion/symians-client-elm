module Chat.Update exposing (update)

import Chat.Model exposing (..)
import Chat.Channel as Channel
import Phoenix.Socket
import App.Model
import Auth


type alias UpdateReturn =
    ( ( Model, Cmd App.Model.SocketMsg ), App.Model.Socket )


update : Msg -> Auth.Model -> Phoenix.Socket.Socket App.Model.Msg -> Model -> UpdateReturn
update msg auth socket model =
    case msg of
        SendMessage ->
            Channel.send auth socket model

        JoinChannel ->
            Channel.join socket model

        LeaveChannel ->
            Channel.leave socket model

        SetNewMessage str ->
            ( ( { model | newMessage = str }, Cmd.none ), socket )

        ReceiveChatMessage raw ->
            ( ( Channel.processChatMessage raw model, Cmd.none ), socket )

        ShowJoinedMessage channelName ->
            ( ( Channel.showJoinedMessage channelName model, Cmd.none ), socket )

        ShowLeftMessage channelName ->
            ( ( Channel.showLeftMessage channelName model, Cmd.none ), socket )

        NoOp ->
            ( ( model, Cmd.none ), socket )
