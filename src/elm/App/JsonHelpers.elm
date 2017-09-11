module App.JsonHelpers exposing (..)

import Chat.Model exposing (ChatMessage)
import App.Model exposing (..)
import Json.Decode as JD exposing (field, maybe, int, string, float, nullable, Decoder)
import Dict exposing (Dict)
import Json.Encode as JE
import Auth


coordinatesDecoder : Decoder Coordinates
coordinatesDecoder =
    JD.map3 Coordinates
        (field "x" JD.int)
        (field "y" JD.int)
        (field "z" JD.int)


dimensionsDecoder : Decoder Dimensions
dimensionsDecoder =
    JD.map3 Dimensions
        (field "length" JD.int)
        (field "width" JD.int)
        (field "height" JD.int)


locationDecoder : Decoder Location
locationDecoder =
    JD.map2 Location
        (field "entities" (JD.list JD.string))
        (field "type_" JD.string)


locationsDecoder : Decoder (Dict String Location)
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


decodeTokenMessage : JD.Value -> Result String Auth.Model
decodeTokenMessage =
    JD.decodeValue tokenMessageDecoder


encodeChatMessage : String -> String -> JE.Value
encodeChatMessage token msg =
    (JE.object [ ( "token", JE.string token ), ( "body", JE.string msg ) ])


decodeChatMessage : JD.Value -> Result String ChatMessage
decodeChatMessage =
    JD.decodeValue chatMessageDecoder


decodeWorldData : JD.Value -> Result String WorldData
decodeWorldData =
    JD.decodeValue worldDataDecoder
