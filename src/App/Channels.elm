module App.Channels exposing (..)
import Phoenix.Channel
import Phoenix.Socket
import Json.Encode as JE
import App.Model exposing (Msg(..))

userParams : JE.Value
userParams =
  JE.object [ ( "user_id", JE.string "123" ) ]

init channel =
  -- We will need a port to communicate with location storage
  -- for the user tokens.
  Phoenix.Channel.init channel
    |> Phoenix.Channel.withPayload userParams
    |> Phoenix.Channel.onJoin (always (JoinedChannel channel))
    |> Phoenix.Channel.onClose (always (LeftChannel channel))

join model channel =
  let
    ( phxSocket, phxCmd ) = Phoenix.Socket.join (init channel) model.phxSocket
  in
    ( { model | phxSocket = phxSocket }, Cmd.map PhoenixMsg phxCmd)

leave model channel =
  let
    ( phxSocket, phxCmd ) =
        Phoenix.Socket.leave channel model.phxSocket
  in
    ( { model | phxSocket = phxSocket }, Cmd.map PhoenixMsg phxCmd)

joined model channel =
  let
    messages = ("Joined channel " ++ channel) :: model.messages
  in
    { model | messages = messages } ! []

left model channel = 
  let
    messages = ("Left channel " ++ channel) :: model.messages
  in
    { model | messages = messages } ! []
