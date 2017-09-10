module Chat.Channel exposing (..)

import App.JsonHelpers exposing (encodeChatMessage, decodeChatMessage)
import App.Model exposing (Msg(ChatMsg), Socket, SocketMsg)
import Chat.Model exposing (..)
import Dict exposing (Dict)
import Json.Decode exposing (Value)
import Phoenix.Channel
import Phoenix.Socket
import Phoenix.Push
import Auth


type alias UpdateReturn =
    ( ( Model, Cmd App.Model.SocketMsg ), App.Model.Socket )


getCurrent : Model -> Channel
getCurrent model =
    Maybe.withDefault (Channel []) (Dict.get model.currentChannel model.channels)


updateMessages : List String -> String -> Model -> Channels
updateMessages messages channelName model =
    Dict.insert channelName (Channel messages) model.channels


join : Socket -> Model -> UpdateReturn
join socket model =
    let
        channel =
            Phoenix.Channel.init model.currentChannel
                -- this is where the user token should get attached
                -- |> Phoenix.Channel.withPayload userParams
                |> Phoenix.Channel.onJoin (always (ChatMsg (ShowJoinedMessage model.currentChannel)))
                |> Phoenix.Channel.onClose (always (ChatMsg (ShowLeftMessage model.currentChannel)))

        ( phxSocket, phxCmd ) =
            Phoenix.Socket.join channel socket
    in
        ( ( model, phxCmd ), phxSocket )


leave : Socket -> Model -> UpdateReturn
leave socket model =
    let
        ( phxSocket, phxCmd ) =
            Phoenix.Socket.leave model.currentChannel socket
    in
        ( ( model, phxCmd ), phxSocket )


send : Auth.Model -> Socket -> Model -> UpdateReturn
send auth socket model =
    let
        token =
            Maybe.withDefault "" auth.token

        payload =
            encodeChatMessage token model.newMessage

        push_ =
            Phoenix.Push.init newChatMsgEvent model.currentChannel
                |> Phoenix.Push.withPayload payload

        ( phxSocket, phxCmd ) =
            Phoenix.Socket.push push_ socket
    in
        ( ( { model | newMessage = "" }, phxCmd ), phxSocket )


addMessage : String -> String -> Model -> Channels
addMessage msg channelName model =
    let
        currentChannel =
            Maybe.withDefault (Channel []) (Dict.get channelName model.channels)

        nextMessages =
            msg :: currentChannel.messages

        nextChannels =
            updateMessages nextMessages channelName model
    in
        nextChannels


showJoinedMessage : String -> Model -> Model
showJoinedMessage channelName model =
    let
        nextChannels =
            addMessage ("Joined channel " ++ channelName) channelName model
    in
        { model | channels = nextChannels }


showLeftMessage : String -> Model -> Model
showLeftMessage channelName model =
    let
        nextChannels =
            addMessage ("Left channel " ++ channelName) channelName model
    in
        { model | channels = nextChannels }


processChatMessage : Value -> Model -> Model
processChatMessage raw model =
    case decodeChatMessage raw of
        Ok chatMessage ->
            let
                currentChannel =
                    Maybe.withDefault (Channel []) (Dict.get model.currentChannel model.channels)

                nextMessages =
                    (chatMessage.user ++ ": " ++ chatMessage.body) :: currentChannel.messages

                nextChannels =
                    Dict.insert model.currentChannel (Channel nextMessages) model.channels
            in
                { model | channels = nextChannels }

        Err error ->
            model
