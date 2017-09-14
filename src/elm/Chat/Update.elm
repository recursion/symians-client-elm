module Chat.Update exposing (update)

import Chat.Model exposing (..)
import Chat.Messages as Messages
import Chat.Decoders exposing (encodeChatMessage)
import App.Socket exposing (SocketCmdMsg(..))


update msg model =
    case msg of
        SendMessage ->
            let
                externalMsg =
                    Send newChatMsgEvent model.name (encodeChatMessage model.newMessage)
            in
                ( ( {model| newMessage = ""}, Cmd.none ), externalMsg )

        JoinChannel ->
            ( ( model, Cmd.none ), Join model.name)

        LeaveChannel ->
            ( ( model, Cmd.none ), Leave model.name)

        SetNewMessage str ->
            ( ( { model | newMessage = str }, Cmd.none ), NoOp )

        ReceiveChatMessage raw ->
            ( ( Messages.process raw model, Cmd.none ), NoOp )

        ShowJoinedMessage ->
            ( ( Messages.showJoined model, Cmd.none ), NoOp )

        ShowLeftMessage ->
            ( ( Messages.showLeft model, Cmd.none ), NoOp )

        ToggleChatInputFocus ->
            ( ( { model | inputHasFocus = not model.inputHasFocus }, Cmd.none ), NoOp )
