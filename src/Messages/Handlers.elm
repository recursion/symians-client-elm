module Messages.Handlers exposing (..)

import Json.Encode as JE
import App.Model exposing (Msg(..), Model)
import Messages.Decoders exposing (decodeJoinMessage, decodeChatMessage)

import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push


phoenix model msg =
  let
    ( phxSocket, phxCmd ) = Phoenix.Socket.update msg model.phxSocket
  in
    ( { model | phxSocket = phxSocket } , Cmd.map PhoenixMsg phxCmd )

send model =
  let
    -- this is where we will need to attach the token
    payload =
      (JE.object [ ( "user", JE.string "user" ), ( "body", JE.string model.newMessage ) ])

    push_ =
      Phoenix.Push.init "new:msg" "rooms:lobby"
          |> Phoenix.Push.withPayload payload

    ( phxSocket, phxCmd ) = Phoenix.Socket.push push_ model.phxSocket
    nextModel = { model | newMessage = "", phxSocket = phxSocket }
  in
    (nextModel,  Cmd.map PhoenixMsg phxCmd)

join model raw =
  case decodeJoinMessage raw of
    Ok joinMessage ->
      let
        user = model.user
        next_user = { user | id = joinMessage.id
                    , token = joinMessage.token
                    , status = joinMessage.status
                    }
      in
        {model | user = next_user} ! []

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
