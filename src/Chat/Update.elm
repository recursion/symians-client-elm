module Chat.Update exposing (update)

import Chat.Model exposing (..)
import Chat.Messages as Messages
import App.Model exposing (SocketAction(..))


update msg model =
    case msg of
        JoinChannel ->
            ( ( model, Cmd.none ), Join model.name)

        LeaveChannel ->
            ( ( model, Cmd.none ), Leave model.name)

        ReceiveChatMessage raw ->
            ( ( Messages.process raw model, Cmd.none ), NoAction )

        ShowJoinedMessage ->
            ( ( Messages.showJoined model, Cmd.none ), NoAction )

        ShowLeftMessage ->
            ( ( Messages.showLeft model, Cmd.none ), NoAction )
