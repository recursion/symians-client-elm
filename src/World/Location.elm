module World.Location exposing (get, render)

import Html exposing (Html)
import Svg.Attributes exposing (width, height, fill, stroke, x, y, class)
import Svg.Events exposing (onMouseOver, onClick)
import Svg exposing (svg, rect, text)
import App.Model exposing (Msg(..))
import World.Model exposing (Locations, Location, Coordinates, CoordHash)
import World.Coordinates as Coordinates
import Dict exposing (Dict)
import UI.Model as UI
import UI.Camera as Camera

{-| looks up a location by a coordinates hash
returns a maybe tuple (coords, location)
-}
get : Locations -> CoordHash -> Maybe ( CoordHash, Location )
get locations key =
    case Dict.get key locations of
        Nothing -> Nothing
        Just loc -> Just (key, loc)


{-| renders an svg rect for locations or empty text for nothing
-}
render : Maybe ( CoordHash, Location ) -> UI.Model -> Html Msg
render maybeLoc ui =
    case maybeLoc of
        Just (coords, loc)->
            rect (configureTile coords loc ui) []

        Nothing ->
            Svg.text ""


{-| set up the properties for a tile
-}
configureTile : CoordHash -> Location -> UI.Model -> List (Svg.Attribute Msg)
configureTile coordinates loc ui =
    let
        coords =
            Coordinates.extract coordinates

        ( screenX, screenY ) =
            Camera.translate coords ui.camera
    in
        [ x <| toString screenX
        , y <| toString screenY
        , fill "green"
        , stroke "green"
        , width <| toString <| Camera.tileSize
        , height <| toString <| Camera.tileSize
        , onMouseOver (UIMsg (UI.SetInspected coords loc))
        , onClick (UIMsg (UI.ToggleSelected coords))
        , class <| applySelection coords ui.selected
        ]


{-| Sets a color based on whether or not these coordinates have been selected
-}
applySelection : Coordinates -> List Coordinates -> String
applySelection coords selected =
    if List.member coords selected then
        "location-selected"
    else
        "location"
