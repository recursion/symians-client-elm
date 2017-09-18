module World.Decoders exposing (..)

import World.Models as World exposing (Location, Dimensions, Coordinates, CoordHash)
import Json.Decode as JD exposing (field, maybe, int, string, float, nullable, Decoder)
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
    JD.map2 Location
        (field "entities" (JD.list JD.string))
        (field "type_" JD.string)


locationsDecoder : Decoder (Dict CoordHash Location)
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
