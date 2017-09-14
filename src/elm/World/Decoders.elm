module World.Decoders exposing (..)

import World.Model as World exposing (Coordinates, Location, Dimensions)
import Json.Decode as JD exposing (field, maybe, int, string, float, nullable, Decoder)
import Json.Decode.Pipeline exposing (decode, optional, required)
import Dict exposing (Dict)
import Json.Decode as JD


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
    decode Location
        |> required "entities" (JD.list JD.string)
        |> required "type_" JD.string
        |> optional "selected" JD.bool False


locationsDecoder : Decoder (Dict String Location)
locationsDecoder =
    JD.dict locationDecoder


worldDataDecoder : JD.Decoder World.Model
worldDataDecoder =
    JD.map2 World.Model
        (field "locations" locationsDecoder)
        (field "dimensions" dimensionsDecoder)


decodeWorldData : JD.Value -> Result String World.Model
decodeWorldData =
    JD.decodeValue worldDataDecoder
