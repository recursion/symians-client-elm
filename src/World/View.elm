module World.View exposing (render)

{-| module for rendering the world data
-}

import Html exposing (Html)
import Svg.Attributes exposing (class)
import Svg exposing (svg)

import App.Model exposing (Msg(..), Model, State(..))
import World.Model exposing (Coordinates)
import World.Coordinates exposing (hash)
import World.Location as Location
import World.Model as World
import UI.Camera as Camera
import UI.Model as UI


{-| looks up the locations currently in the cameras view and renders them
-}
render : World.Model -> UI.Model -> Html Msg
render world ui =
    svg
        [ class "fullscreen world" ]
        (Camera.getScreenLocations ui.camera
            |> List.map (\(x, y) -> Coordinates x y ui.camera.position.z)
            |> List.map hash
            |> List.map (Location.get world.locations)
            |> List.map (\loc -> Location.render loc ui)
        )
