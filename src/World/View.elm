module World.View exposing (render)

import Html exposing (Html)
import Svg.Attributes exposing (width, height, fill, stroke, x, y, class)
import Svg.Events exposing (onMouseOver, onClick)
import Svg exposing (svg, rect, text)
import Dict exposing (Dict)
import App.Model exposing (Msg(..), Model, State(..))
import UI.Model as UI exposing (Camera)
import World.Model as World exposing (Location)
import World.Coordinates exposing (Coordinates, extract)
import UI.Model
import UI.Camera
import UI.View exposing (loadingScreen)


render : Model -> Html Msg
render model =
    case model.world of
        Loading ->
            Html.map UIMsg loadingScreen

        Loaded world ->
            renderWorld world model


renderWorld : World.Model -> Model -> Html Msg
renderWorld world model =
    svg
        [ class "fullscreen world" ]
            --TODO: what we should do here is:
            -- calculate all the current positions on screen
            -- get only those tiles for rendering
        (Dict.toList
            world.locations
            |> List.map (\loc -> renderLocation loc model.ui)
        )


renderLocation : ( String, Location ) -> UI.Model.Model -> Html Msg
renderLocation ( coordinates, loc ) ui =
    let
        coords =
            extract coordinates

        ( posX, posY ) =
            UI.Camera.translate coords ui.camera

        tileProperties =
            configureTile loc coords posX posY ui.selected
    in
        if UI.Camera.inBounds coords ui.camera then
            rect tileProperties []
        else
            Svg.text ""


{-| set up the properties for a tile
-}
configureTile :
    Location
    -> Coordinates
    -> String
    -> String
    -> List Coordinates
    -> List (Svg.Attribute Msg)
configureTile loc coords screenX screenY selected =
    [ x screenX
    , y screenY
    , fill "green"
    , stroke "green"
    , width <| toString <| UI.Camera.tileSize
    , height <| toString <| UI.Camera.tileSize
    , onMouseOver (UIMsg (UI.SetInspected coords loc))
    , onClick (UIMsg (UI.ToggleSelected coords))
    , class <| applySelection coords selected
    ]


{-| Sets a color based on whether or not these coordinates have been selected
-}
applySelection : Coordinates -> List Coordinates -> String
applySelection coords selected =
    if List.member coords selected then
        "location-selected"
    else
        "location"
