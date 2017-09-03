module Channels.Channel exposing (..)

import App.Model exposing (Msg(..), Socket)
import Json.Encode as JE
import Phoenix.Push
import Phoenix.Channel
import Phoenix.Socket


init channel =
    -- We will need a port to communicate with location storage
    -- for the user tokens.
    Phoenix.Channel.init channel
        --|> Phoenix.Channel.withPayload userData
        |> Phoenix.Channel.onJoin (always (JoinedChannel channel))
        |> Phoenix.Channel.onClose (always (LeftChannel channel))



join model channel =
    let
        ( phxSocket, phxCmd ) =
            Phoenix.Socket.join (init channel) model.phxSocket
    in
        ( { model | phxSocket = phxSocket}, Cmd.map PhoenixMsg phxCmd )


on socket event channel handler =
    socket
      |> Phoenix.Socket.on event channel handler


send model event channel message =
    let
        token =
            Maybe.withDefault "" model.user.token

        payload =
            (JE.object [ ( "token", JE.string token ), message ])

        push_ =
            Phoenix.Push.init event channel
                |> Phoenix.Push.withPayload payload

        ( phxSocket, phxCmd ) =
            Phoenix.Socket.push push_ model.phxSocket

        nextModel =
            { model | newMessage = "", phxSocket = phxSocket }
    in
        ( nextModel, Cmd.map PhoenixMsg phxCmd )



leave model channel =
    let
        ( phxSocket, phxCmd ) =
            Phoenix.Socket.leave channel model.phxSocket
    in
        ( { model | phxSocket = phxSocket }, Cmd.map PhoenixMsg phxCmd )


joined model channel =
    let
        messages =
            ("Joined channel " ++ channel) :: model.messages
    in
        { model | messages = messages } ! []


left model channel =
    let
        messages =
            ("Left channel " ++ channel) :: model.messages
    in
        { model | messages = messages } ! []
