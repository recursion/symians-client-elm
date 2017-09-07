module App.JsonHelpers exposing (..)

import Chat.Model exposing (ChatMessage)
import App.Model exposing (..)
import Json.Decode as JD exposing (field, maybe, int, string, float, nullable, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Dict exposing (Dict)
import Json.Encode as JE
import Auth

coordinatesDecoder =
    JD.map3 Coordinates
        (field "x" JD.int)
        (field "y" JD.int)
        (field "z" JD.int)

dimensionsDecoder =
    JD.map3 Dimensions
        (field "length" JD.int)
        (field "width" JD.int)
        (field "height" JD.int)

locationDecoder =
    JD.map2 Location
        (field "entities" (JD.list JD.string))
        (field "type" JD.string)

locationsDecoder =
    JD.dict locationDecoder



worldDataDecoder : JD.Decoder WorldData
worldDataDecoder =
    JD.map2 WorldData
        (field "locations" locationsDecoder)
        (field "dimensions" dimensionsDecoder)

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

decodeWorldData =
    JD.decodeValue worldDataDecoder
