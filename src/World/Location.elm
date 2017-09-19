module World.Location exposing (get, render)

import Html exposing (Html)
import Svg.Attributes exposing (width, height, fill, stroke, x, y, class)
import Svg.Events exposing (onMouseOver, onClick, onMouseDown)
import Svg exposing (rect, text)
import Dict exposing (Dict)
import UI.Selector.Model as Selector
import World.Models exposing (Locations, Location, Coordinates, CoordHash)
import World.Coordinates as Coordinates
import UI.Model as UI
import UI.Camera.Utils as Camera


{-| looks up a location by a coordinates hash
returns a maybe tuple (coords, location)
-}
get : Locations -> CoordHash -> Maybe ( CoordHash, Location )
get locations key =
    case Dict.get key locations of
        Nothing ->
            Nothing

        Just loc ->
            Just ( key, loc )


{-| renders an svg rect for locations or empty text for nothing
-}
render : Maybe ( CoordHash, Location ) -> UI.Model -> Html UI.Msg
render maybeLoc ui =
    case maybeLoc of
        Just ( coords, loc ) ->
            rect (configure coords loc ui) []

        Nothing ->
            text ""


{-| set up the properties for a tile
-}
configure : CoordHash -> Location -> UI.Model -> List (Svg.Attribute UI.Msg)
configure coordinates loc ui =
    let
        coords =
            Coordinates.extract coordinates

        ( screenX, screenY ) =
            Camera.translate coords ui.camera

        color =
            case ui.selector.mode of
                Selector.Designate ->
                    if List.member coords (ui.selector.selected ++ ui.selector.buffer) then
                        "#383"
                    else
                        "green"

                Selector.Undesignate ->
                    if List.member coords (ui.selector.buffer) then
                        "green"
                    else if List.member coords (ui.selector.selected) then
                        "#383"
                    else
                        "green"
    in
        [ x <| toString screenX
        , y <| toString screenY
        , fill color
        , stroke color
        , width <| toString <| ui.camera.tileSize
        , height <| toString <| ui.camera.tileSize
        , onMouseOver (UI.MouseOver coords loc)
        , onMouseDown (UI.SelectorMsg (Selector.StartSelection coords))
        ]
