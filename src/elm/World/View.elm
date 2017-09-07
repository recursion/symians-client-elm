module World.View exposing (view)

import Dict exposing (Dict)
import Svg exposing (..)
import Svg.Attributes exposing (..)


-- import Html.Events exposing (onClick)


baseSize =
    "63"
overlayTileSize =
    "64"


view model =
    let
        locations =
            (Dict.toList model.world.locations)
                |> List.filter onZLevel
                |> (List.map (\loc -> renderLocation loc model))
    in
        svg
            [ viewBox "0 0 1366 768"
            , class "world level"
            ]
            [g [ ] locations
            ]


renderLocation ( coords, loc ) model =
    let
        ( getX, getY, getZ ) =
            extractCoords coords

        ( positionx, positiony ) =
            positionFromCoords ( getX, getY )
    in
        createLocation positionx positiony


createLocation positionx positiony =
    g [] 
      [ use
        [ xlinkHref "#grass"
        , x positionx
        , y positiony
        , width baseSize
        , height baseSize
        , transform "translate(-528, -10)"
        ]
        []
      , rect [ fill "rgba(0, 255, 0, 0.2)"
             , x positionx
             , y positiony
             , class "location"
             , width overlayTileSize
             , height overlayTileSize
             ] []
      ]

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

