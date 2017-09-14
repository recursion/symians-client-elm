module App.Socket exposing (..)
{-| This module contains constants, init, and helper functions for working with phoenix-websocket
-}
import App.Model exposing (..)
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Json.Encode as JE
import Chat.Model as Chat

type alias Encoder = (String -> JE.Value)
type alias Decoder = (JE.Value -> Msg)

type SocketCmdMsg
    = Join String
    | JoinWithHandlers String Chat.Msg Chat.Msg
    | Leave String
    | Send String String Encoder
    | NoOp

-- Constants


socketServer : String
socketServer =
    "ws:/192.168.88.29:4000/socket/websocket"


worldDataEvent : String
worldDataEvent =
    "world"


authDataEvent : String
authDataEvent =
    "token"


systemChannel : String
systemChannel =
    "system:"

-- Init socket/channels


initPhxSocket : Socket
initPhxSocket =
    Phoenix.Socket.init socketServer
        -- |> Phoenix.Socket.withDebug
        |> Phoenix.Socket.on authDataEvent systemChannel ReceiveToken
        |> Phoenix.Socket.on worldDataEvent systemChannel ReceiveWorldData


initChatChannel : Model -> (Model, Cmd Msg)
initChatChannel model =
    let
        ( chatOnJoin, chatOnLeave, ( event, channel, receiveChatMsgHandler ) ) =
            Chat.init Chat.defaultChannel
    in
      model
          |> subscribe event channel (ChatMsg << receiveChatMsgHandler)
          |> joinWithHandlers
              channel
              (always (ChatMsg chatOnJoin))
              (always (ChatMsg chatOnLeave))


initSystemChannel : Model -> ( Model, Cmd Msg )
initSystemChannel model =
    let
        channel =
            Phoenix.Channel.init systemChannel
                -- this is where the user token should get attached
                -- |> Phoenix.Channel.withPayload userParams
                |> Phoenix.Channel.onJoin (always (Connected))
                |> Phoenix.Channel.onClose (always (Disconnected))

        ( socket, phxCmd ) =
            Phoenix.Socket.join channel model.socket
    in
        ( { model | socket = socket }
        , Cmd.map PhoenixMsg phxCmd
        )

processPhoenixMsg : SocketMsg -> Model -> (Model, Cmd Msg)
processPhoenixMsg msg model =
    let
        ( phxSocket, phxCmd ) =
            Phoenix.Socket.update msg model.socket
    in
        ( { model | socket = phxSocket }
        , Cmd.map PhoenixMsg phxCmd
        )

join : String -> Model -> (Model, Cmd Msg)
join channelName model =
    let
        channel =
            Phoenix.Channel.init channelName

        ( phxSocket, phxCmd ) =
            Phoenix.Socket.join channel model.socket
    in
        ( {model | socket = phxSocket}, Cmd.map PhoenixMsg phxCmd )

{-| Joins the current channel
-}
joinWithHandlers : String -> Decoder -> Decoder -> Model -> (Model, Cmd Msg)
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
        ( {model | socket = phxSocket}, Cmd.map PhoenixMsg phxCmd )


{-| Leave the current channel
-}
leave : String -> Model -> (Model, Cmd Msg)
leave channelName model =
    let
        ( phxSocket, phxCmd ) =
            Phoenix.Socket.leave channelName model.socket
    in
        ( {model | socket = phxSocket}, Cmd.map PhoenixMsg phxCmd )


{-| Send a message over sockets
an encoder is a partially applied function
it takes a token and returns an encoded object with the token attached
-}
send : String -> String -> Encoder -> Model -> (Model, Cmd Msg)
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
         ({ model | socket = phxSocket }, Cmd.map PhoenixMsg phxCmd )

subscribe : String -> String -> Decoder -> Model -> Model
subscribe event channel handler model =
    let
        nextSocket = 
            model.socket
              |> Phoenix.Socket.on event channel handler
    in
        { model | socket = nextSocket }


externalMsg :  SocketCmdMsg -> Model -> (Model, Cmd Msg)
externalMsg msg model =
    case msg of
        Send event channel encoder ->
            send event channel encoder model

        Join channel ->
            join channel model

        JoinWithHandlers channel onJoin onLeave ->
            joinWithHandlers
                channel
                (always (ChatMsg onJoin))
                (always (ChatMsg onLeave))
                model

        Leave channel ->
            leave channel model

        NoOp ->
            ( model, Cmd.none )
