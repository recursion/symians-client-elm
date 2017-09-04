module Messages.Handlers exposing (..)

import Json.Encode as JE
import App.Model exposing (Msg(..), Model)
import Messages.Decoders exposing (decodeJoinMessage, decodeChatMessage)

import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push


phoenix model msg =
  let
    ( socket, phxCmd ) = Phoenix.Socket.update msg model.socket
  in
    ( { model | socket = socket } , Cmd.map PhoenixMsg phxCmd )

send model =
  let
    -- this is where we will need to attach the token
    payload =
      (JE.object [ ( "auth", JE.string "auth" ), ( "body", JE.string model.newMessage ) ])

    push_ =
      Phoenix.Push.init "new:msg" "chat:lobby"
          |> Phoenix.Push.withPayload payload

    ( socket, phxCmd ) = Phoenix.Socket.push push_ model.socket
    nextModel = { model | newMessage = "", socket = socket }
  in
    (nextModel,  Cmd.map PhoenixMsg phxCmd)

join model raw =
  case decodeJoinMessage raw of
    Ok joinMessage ->
      let
        auth = model.auth
        next_auth = { auth | id = joinMessage.id
                    , token = joinMessage.token
                    , status = joinMessage.status
                    }
      in
        {model | auth = next_auth} ! []

    Err error ->
      model ! []

chat model raw =
  case decodeChatMessage raw of
    Ok chatMessage ->
      ( { model | messages = (chatMessage.user ++ ": " ++ chatMessage.body) :: model.messages }
      , Cmd.none
      )

    Err error ->
      ( model, Cmd.none )
