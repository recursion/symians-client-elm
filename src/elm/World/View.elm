module World.View exposing (render)

import Html exposing (Html)
import Svg.Attributes exposing (x, y, xlinkHref, viewBox, transform, width, height, fill, stroke)
import Svg.Events exposing (onMouseOver, onMouseDown)
import Svg exposing (svg, use, g, rect, text)
import App.Model exposing (Msg(..), Model)
import World.Model exposing (Location)
import World.Location
import UI.Model as UI exposing (Camera, TileData)
import UI.Camera
import Dict exposing (Dict)


-- world rendering


render : Dict String Location -> Camera -> Html Msg
render locations camera =
    let
        locations_ =
            Dict.toList locations
                |> List.map (\loc -> renderLocation loc camera)
    in
        svg
            [ Svg.Attributes.class "world"
            ]
            locations_


renderLocation : ( String, Location ) -> Camera -> Html Msg
renderLocation ( coords, location ) camera =
    let
        class_ =
            if location.selected then
                "location-selected"
            else
                "location"

        ( x_, y_, z_ ) =
            World.Location.extractCoords coords

        ( ogX, ogY, ogZ ) =
            ( toString x_, toString y_, toString z_ )

        locationProperties = 
            [ Svg.Attributes.class class_
            , fill "green"
            , stroke "black"
            , width <| toString <| UI.Camera.tileSize
            , height <| toString <| UI.Camera.tileSize
            , onMouseOver (SetInspected ogX ogY ogZ location)
            ]
    in
        UI.Camera.render rect locationProperties x_ y_ z_ camera
