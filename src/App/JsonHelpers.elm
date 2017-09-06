module App.JsonHelpers exposing (..)

import Chat.Model exposing (ChatMessage)
import Json.Decode as JD exposing (field, maybe)
import Json.Encode as JE
import Auth


tokenMessageDecoder : JD.Decoder Auth.Model
tokenMessageDecoder =
    JD.map3 Auth.Model
        (maybe (field "id" JD.int))
        (maybe (field "token" JD.string))
        (field "status" JD.string)


chatMessageDecoder : JD.Decoder ChatMessage
chatMessageDecoder =
    JD.map2 ChatMessage
        (field "user" JD.string)
        (field "body" JD.string)


decodeTokenMessage =
    JD.decodeValue tokenMessageDecoder


encodeChatMessage token msg =
    (JE.object [ ( "token", JE.string token ), ( "body", JE.string msg ) ])


decodeChatMessage =
    JD.decodeValue chatMessageDecoder
