module World.View exposing (render)

{-| module for rendering the world data
-}

import Html exposing (Html)
import Svg.Attributes exposing (width, height, fill, stroke, x, y, class)
import Svg.Events exposing (onMouseOver, onClick)
import Svg exposing (svg, rect, text)
import Dict exposing (Dict)
import App.Model exposing (Msg(..), Model, State(..))
import UI.Model as UI exposing (Camera)
import World.Model as World exposing (Location, initLocation, Locations)
import World.Coordinates exposing (Coordinates, extract, hash)
import UI.Model
import UI.Camera as Camera
import UI.View exposing (loadingScreen)


{-| renders the world or the loading screen when no world data is loaded
-}
render : Model -> Html Msg
render model =
    case model.world of
        Loading ->
            Html.map UIMsg loadingScreen

        Loaded world ->
            renderWorld world model


{-| looks up the locations currently in the cameras view and renders them
-}
renderWorld : World.Model -> Model -> Html Msg
renderWorld world model =
    svg
        [ class "fullscreen world" ]
        (Camera.getScreenLocations model.ui.camera
            |> List.map (\( x, y ) -> Coordinates x y model.ui.camera.position.z)
            |> List.map (getLocation world.locations)
            |> List.map (\loc -> renderLocation loc model.ui)
        )


{-| looks up a location by coordinates
returns a tuple with the coords and a maybe location
-}
getLocation : Locations -> Coordinates -> ( String, Maybe Location )
getLocation locations coords =
    let
        key =
            hash coords
    in
        ( key, Dict.get key locations )


{-| renders an svg rect for locations or empty text for nothing
-}
renderLocation : ( String, Maybe Location ) -> UI.Model.Model -> Html Msg
renderLocation ( coords, maybeLoc ) ui =
    case maybeLoc of
        Just loc ->
            rect (configureTile coords loc ui) []

        Nothing ->
            Svg.text ""


{-| set up the properties for a tile
-}
configureTile : String -> Location -> UI.Model.Model -> List (Svg.Attribute Msg)
configureTile coordinates loc ui =
    let
        coords =
            extract coordinates

        ( screenX, screenY ) =
            Camera.translate coords ui.camera
    in
        [ x screenX
        , y screenY
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
