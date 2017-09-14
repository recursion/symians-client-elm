module Chat.Update exposing (update)

import Chat.Model exposing (..)
import Chat.Messages as Messages
import Chat.Decoders exposing (encodeChatMessage)
import App.Socket exposing (SocketCmdMsg(..))

newMessageEvent = "new:msg"

update msg model =
    case msg of
        SendMessage ->
            let
                encoder =
                    (encodeChatMessage model.newMessage)

                externalMsg =
                    Send newMessageEvent model.currentChannel encoder
            in
                ( ( {model| newMessage = ""}, Cmd.none ), externalMsg )

        JoinChannel ->
            ( ( model, Cmd.none ), Join model.currentChannel)

        LeaveChannel ->
            ( ( model, Cmd.none ), Leave model.currentChannel)

        SetNewMessage str ->
            ( ( { model | newMessage = str }, Cmd.none ), NoOp )

        ReceiveChatMessage raw ->
            ( ( Messages.process raw model, Cmd.none ), NoOp )

        ShowJoinedMessage channelName ->
            ( ( Messages.showJoined channelName model, Cmd.none ), NoOp )

        ShowLeftMessage channelName ->
            ( ( Messages.showLeft channelName model, Cmd.none ), NoOp )

        ToggleChatInputFocus ->
            ( ( { model | inputHasFocus = not model.inputHasFocus }, Cmd.none ), NoOp )
