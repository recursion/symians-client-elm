module World.Location exposing (get, render)

import Html exposing (Html)
import Svg.Attributes exposing (width, height, fill, stroke, x, y, class)
import Svg.Events exposing (onMouseOver, onClick, onMouseDown)
import Svg exposing (rect, text, Svg)
import Dict exposing (Dict)
import UI.Selector.Model as Selector
import World.Models exposing (Locations, Location, Coordinates, CoordHash)
import World.Coordinates as Coordinates
import UI.Model as UI
import UI.Camera.Utils as Camera
import UI.Camera.Model as Camera


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
    in
        [ class "world__location" ]
            |> setPosition ui.camera coords
            |> setSelector ui.selector coords
            |> setSize ui.camera
            |> setEvents coords loc

setEvents : Coordinates -> Location -> List (Svg.Attribute UI.Msg) -> List (Svg.Attribute UI.Msg)
setEvents coords loc props =
    [ onMouseOver (UI.MouseOver coords loc)
    , onMouseDown (UI.SelectorMsg (Selector.StartSelection coords))
    ]
        ++ props


setSize : Camera.Model -> List (Svg.Attribute UI.Msg) -> List (Svg.Attribute UI.Msg)
setSize camera props =
    [ width <| toString <| camera.tileSize
    , height <| toString <| camera.tileSize
    ]
        ++ props

setPosition : Camera.Model -> Coordinates -> List (Svg.Attribute UI.Msg) -> List (Svg.Attribute UI.Msg)
setPosition camera coords props =
    let
        ( screenX, screenY ) =
            Camera.translate coords camera

        position =
            [ x <| toString screenX
            , y <| toString screenY
            ]
    in
        props ++ position



-- draw whats on the tile
-- and then put another transparent tile over it?
-- that when when we are displaying more than
-- just a color, we will still see it, but
-- with a tint over it representing the selection
-- one more reason we need to move to canvas rendering.


setColor loc props =
    let
        existingClass =
            case List.filter (\prop -> prop.realKey == "class") props of
                [] ->
                    ""

                [ prop ] ->
                    prop.value

                _ ->
                    ""

        color =
            case loc.type_ of
                "grass" ->
                    " world__location-grass"

                _ ->
                    " world__location-stone"
    in
        [ class <| existingClass ++ color
        ]


setSelector selector coords props =
    let
        color =
            case selector.mode of
                Selector.Designate ->
                    if List.member coords (selector.selected ++ selector.buffer) then
                        "#383"
                    else
                        "green"

                Selector.Undesignate ->
                    if List.member coords (selector.buffer) then
                        "green"
                    else if List.member coords (selector.selected) then
                        "#383"
                    else
                        "green"
    in
        [ fill color
        , stroke color
        ]
            ++ props
