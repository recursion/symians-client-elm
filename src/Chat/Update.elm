module Chat.Update exposing (update)

import Chat.Model exposing (..)
import Chat.Messages as Messages
import Chat.Decoders exposing (encodeChatMessage)
import App.Model exposing (SocketAction(..))


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
            ( ( { model | newMessage = str }, Cmd.none ), NoAction )

        ReceiveChatMessage raw ->
            ( ( Messages.process raw model, Cmd.none ), NoAction )

        ShowJoinedMessage ->
            ( ( Messages.showJoined model, Cmd.none ), NoAction )

        ShowLeftMessage ->
            ( ( Messages.showLeft model, Cmd.none ), NoAction )

        ToggleChatInputFocus ->
            ( ( { model | inputHasFocus = not model.inputHasFocus }, Cmd.none ), NoAction )
