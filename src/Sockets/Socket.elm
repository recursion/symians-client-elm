module Sockets.Socket exposing (..)

import App.Model exposing (..)
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push


socketServer : String
socketServer =
    "ws://localhost:4000/socket/websocket"


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Phoenix.Socket.listen model.socket PhoenixMsg ]


init =
    Phoenix.Socket.init socketServer
        |> Phoenix.Socket.withDebug


phoenix model msg =
    let
        ( socket, phxCmd ) =
            Phoenix.Socket.update msg model.socket
    in
        ( { model | socket = socket }, Cmd.map PhoenixMsg phxCmd )


send event channel payload model =
    let
        push_ =
            Phoenix.Push.init event channel
                |> Phoenix.Push.withPayload payload

        ( socket, phxCmd ) =
            Phoenix.Socket.push push_ model.socket

        nextModel =
            { model | socket = socket }
    in
        ( nextModel, Cmd.map PhoenixMsg phxCmd )


create channel =
    Phoenix.Channel.init channel
        -- there is an option to pass a payload in here
        -- we could also take in join/leave handlers here
        -- |> Phoenix.Channel.withPayload userParams
        |> Phoenix.Channel.onJoin (always (JoinedChannel channel))
        |> Phoenix.Channel.onClose (always (LeftChannel channel))


join model channel =
    let
        ( socket, phxCmd ) =
            Phoenix.Socket.join (create channel) model.socket
    in
        ( { model | socket = socket }, Cmd.map PhoenixMsg phxCmd )


subscribe event channel handler model =
    let
        socket =
            model.socket
                |> Phoenix.Socket.on event channel handler
    in
        { model | socket = socket } ! []


leave model channel =
    let
        ( socket, phxCmd ) =
            Phoenix.Socket.leave channel model.socket
    in
        ( { model | socket = socket }, Cmd.map PhoenixMsg phxCmd )



-- These are really a per channel handler, rather than for all channels.
-- however they must be used when a channel is created

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
