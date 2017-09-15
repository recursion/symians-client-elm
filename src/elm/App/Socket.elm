module App.Socket exposing (..)

{-| This module contains constants, init, and helper functions for working with phoenix-websocket
-}

import App.Model exposing (..)
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push


socketServer : String
socketServer =
    "ws:/192.168.88.29:4000/socket/websocket"



-- Init socket/channels


listen : Model -> Sub Msg
listen model =
    Phoenix.Socket.listen model.socket PhoenixMsg


initPhxSocket : Socket
initPhxSocket =
    Phoenix.Socket.init socketServer



-- |> Phoenix.Socket.withDebug


processPhoenixMsg : SocketMsg -> Model -> ( Model, Cmd Msg )
processPhoenixMsg msg model =
    let
        ( phxSocket, phxCmd ) =
            Phoenix.Socket.update msg model.socket
    in
        ( { model | socket = phxSocket }
        , Cmd.map PhoenixMsg phxCmd
        )


join : String -> Model -> ( Model, Cmd Msg )
join channelName model =
    let
        channel =
            Phoenix.Channel.init channelName

        ( phxSocket, phxCmd ) =
            Phoenix.Socket.join channel model.socket
    in
        ( { model | socket = phxSocket }, Cmd.map PhoenixMsg phxCmd )


{-| Joins the current channel
-}
joinWithHandlers : String -> Decoder -> Decoder -> Model -> ( Model, Cmd Msg )
joinWithHandlers channelName onJoin onClose model =
    let
        channel =
            Phoenix.Channel.init channelName
                -- this is where the user token should get attached
                -- |> Phoenix.Channel.withPayload userParams
                |> Phoenix.Channel.onJoin onJoin
                |> Phoenix.Channel.onClose onClose

        ( phxSocket, phxCmd ) =
            Phoenix.Socket.join channel model.socket
    in
        ( { model | socket = phxSocket }, Cmd.map PhoenixMsg phxCmd )


{-| Leave the current channel
-}
leave : String -> Model -> ( Model, Cmd Msg )
leave channelName model =
    let
        ( phxSocket, phxCmd ) =
            Phoenix.Socket.leave channelName model.socket
    in
        ( { model | socket = phxSocket }, Cmd.map PhoenixMsg phxCmd )


{-| Send a message over sockets
an encoder is a partially applied function
it takes a token and returns an encoded object with the token attached
-}
send : String -> String -> Encoder -> Model -> ( Model, Cmd Msg )
send event channel encoder model =
    let
        token =
            Maybe.withDefault "" model.auth.token

        payload =
            encoder token

        push_ =
            Phoenix.Push.init event channel
                |> Phoenix.Push.withPayload payload

        ( phxSocket, phxCmd ) =
            Phoenix.Socket.push push_ model.socket
    in
        ( { model | socket = phxSocket }, Cmd.map PhoenixMsg phxCmd )


subscribe : String -> String -> Decoder -> Model -> Model
subscribe event channel handler model =
    let
        nextSocket =
            model.socket
                |> Phoenix.Socket.on event channel handler
    in
        { model | socket = nextSocket }
