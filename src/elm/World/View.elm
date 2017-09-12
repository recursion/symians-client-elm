module World.View exposing (view)

import App.Model exposing (Model, Msg, Msg(DisplayTile))
import World.Model exposing (Location)
import Svg.Attributes exposing (..)
import Svg.Events exposing (onMouseOver)
import Html exposing (Html)
import Dict exposing (Dict)
import Svg exposing (..)


smallTile : String
smallTile =
    "32"


baseSize : String
baseSize =
    "63"


overlayTileSize : String
overlayTileSize =
    "62"


view : Model -> Html Msg
view model =
    let
        locations =
            (Dict.toList model.world.locations)
                |> (List.map (\loc -> renderLocation loc))
    in
        svg
            [ class "world level"
            ]
            locations


renderLocation : ( String, Location ) -> Html Msg
renderLocation ( coords, loc ) =
    let
        ( x, y, z ) =
            extractCoords coords

        ( positionx, positiony ) =
            positionFromCoords ( x, y )
    in
        createLocation positionx positiony loc


createLocation : String -> String -> Location -> Html Msg
createLocation posX posY loc =
        g []
            [ use
                [ xlinkHref ("#" ++ loc.type_)
                , x posX
                , y posY
                , class "location"
                , stroke "#000"
                ]
                []
            , rect
                [ class "location"
                , fill "rgba(255, 255, 255, 0.01)"
                , x posX
                , y posY
                , width overlayTileSize
                , height overlayTileSize
                , onMouseOver (DisplayTile posX posY loc)
                ]
                []
            ]


onZLevel : ( String, Location ) -> Bool
onZLevel ( coords, loc ) =
    let
        ( x, y, z ) =
            extractCoords coords
    in
        case z of
            "0" ->
                True

            _ ->
                False


extractCoords : String -> ( String, String, String )
extractCoords asString =
    let
        coords_ =
            String.split "|" asString

        x =
            Maybe.withDefault "0" (List.head coords_)

        y =
            Maybe.withDefault "0" (List.head (List.drop 1 coords_))

        z =
            Maybe.withDefault "0" (List.head (List.drop 2 coords_))
    in
        ( x, y, z )


positionFromCoords : ( String, String ) -> ( String, String )
positionFromCoords ( getX, getY ) =
    let
        asNumber =
            \s -> Result.withDefault 0 (String.toInt s)

        positionx =
            toString ((asNumber getX) * (asNumber baseSize))

        positiony =
            toString ((asNumber getY) * (asNumber baseSize))
    in
        ( positionx, positiony )
