module Chat.Chat exposing (..)

--where

import App.JsonHelpers exposing (encodeChatMessage, decodeChatMessage)
import Chat.Model exposing (..)
import Phoenix.Socket
import Phoenix.Push
import Dict exposing (Dict)


init : ( Model, Cmd Msg )
init =
    ( initModel "system:chat", Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Phoenix.Socket.listen model.phxSocket PhoenixMsg
        