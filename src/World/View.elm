module World.View exposing (render)

{-| module for rendering the world data
-}

import Html exposing (Html)
import Svg.Attributes exposing (id, height, width)
import Svg exposing (svg)

import World.Models as World exposing (Coordinates)
import World.Coordinates exposing (hash)
import World.Location as Location
import UI.Camera.Utils as Camera
import UI.Model as UI


{-| looks up the locations currently in the cameras view and renders them
-}
render : World.Model -> UI.Model -> Html UI.Msg
render world ui =
    svg
        [ height "100%", width "100%", id "world"]
        (Camera.getScreenLocations ui.camera
            |> List.map (\(x, y) -> Coordinates x y ui.camera.position.z)
            |> List.map hash
            |> List.map (Location.get world.locations)
            |> List.map (\loc -> Location.render loc ui)
        )
