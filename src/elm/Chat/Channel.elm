module Chat.Channel exposing (..)

import App.JsonHelpers exposing (encodeChatMessage, decodeChatMessage)
import App.Model exposing (Msg(ChatMsg), Socket, SocketMsg)
import Chat.Model exposing (..)
import Dict exposing (Dict)
import Phoenix.Channel
import Phoenix.Socket
import Phoenix.Push
import App.Auth as Auth


{-| holds the shape of updates return value
-}
type alias UpdateReturn =
    ( ( Model, Cmd App.Model.SocketMsg ), App.Model.Socket )


type alias ParentMsg =
    Chat.Model.Msg -> App.Model.Msg


type alias Socket =
    Phoenix.Socket.Socket App.Model.Msg


{-| Initialize our default chat channel with an existing socket
-}
initWithSocket : String -> String -> ParentMsg -> Socket -> UpdateReturn
initWithSocket event channelName parentMsg socket =
    let
        nextSocket =
            socket
                |> Phoenix.Socket.on event channelName (parentMsg << ReceiveChatMessage)

        channels =
            Dict.insert channelName (Channel []) Dict.empty
    in
        channels
            |> Model "" False channelName
            |> join nextSocket


{-| Get the current Channel
-}
getCurrent : Model -> Channel
getCurrent model =
    Maybe.withDefault (Channel []) (Dict.get model.currentChannel model.channels)


{-| Joins the current channel
TODO: Allow joining other channels
-}
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


{-| Leave the current channel
-}
leave : Socket -> Model -> UpdateReturn
leave socket model =
    let
        ( phxSocket, phxCmd ) =
            Phoenix.Socket.leave model.currentChannel socket
    in
        ( ( model, phxCmd ), phxSocket )


{-| Send a message over sockets
-}
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
