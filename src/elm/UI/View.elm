module UI.View exposing (renderHud, renderWorld)

import Html exposing (Html, div, nav, a, button, text, span, p, label, canvas)
import Html.Attributes exposing (id, class, attribute, href)
import Html.Events exposing (onClick)
import Svg.Attributes exposing (x, y, xlinkHref, viewBox, transform, width, height, fill, stroke)
import Svg.Events exposing (onMouseOver, onMouseDown)
import Svg exposing (svg, use, g, rect)
import Dict exposing (Dict)
import App.Model exposing (Msg(..), Model)
import World.Model exposing (Location)
import UI.Model as UI exposing (Camera, TileData)
import UI.Camera
import World.Location
import Chat.View


svgRoot =
    "static/img/vector_tiles_items.svg"



-- world rendering


renderWorld : Dict String Location -> Camera -> Html Msg
renderWorld locations camera =
    let
        locations_ =
            Dict.toList locations
                |> List.map (\loc -> renderLocation loc camera)
    in
        svg
            [ Svg.Attributes.class "world"
            ]
            [ g
                [ transform "scale(1)"
                ]
                locations_
            ]


renderLocation ( coords, location ) camera =
    let
        class_ = if location.selected then
                     "location-selected"
                 else
                     "location"

        ( x_, y_, z_ ) =
            World.Location.extractCoords coords

        ( ogX, ogY, ogZ ) =
            ( toString x_, toString y_, toString z_ )

        ( posX, posY ) =
            UI.Camera.translate ( x_, y_ ) camera
    in
       rect
            [ x posX
            , y posY
            , Svg.Attributes.class class_
            , fill "green"
            , stroke "black"
            , width <| toString <| UI.Camera.tileSize
            , height <| toString <| UI.Camera.tileSize
            , onMouseOver (SetInspected ogX ogY ogZ location)
            ]
            []



-- hud rendering


renderHud : Model -> Html Msg
renderHud model =
    let
        chat =
            if model.ui.viewChat then
                Html.map ChatMsg (Chat.View.root model.chat)
            else
                text ""

        info =
            if model.ui.viewInfo then
                tileInfoView model.ui.currentTile
            else
                text ""
    in
        div []
            [ chat
            , controls model
            , info
            ]



-- tile info


tileInfoView : TileData -> Html Msg
tileInfoView model =
    div [ class "hud hud-tiledata" ]
        [ renderTileData "type: " [ text model.loc.type_ ]
        , renderTileData "x: " [ text model.x ]
        , renderTileData "y: " [ text model.y ]
        , renderTileData "z: " [ text model.z ]
        , renderTileData "entities:" (List.map renderEntity model.loc.entities)
        ]


renderTileData : String -> List (Html Msg) -> Html Msg
renderTileData key value =
    label [ class "tilelabel" ]
        [ text key
        , span [ class "tiledata" ] value
        ]


renderEntity : String -> Html Msg
renderEntity entity =
    div [ class "entity-data" ] [ text entity ]



-- hud controls


controls : Model -> Html Msg
controls model =
    let
        chatClass =
            isActive model.ui.viewChat

        infoClass =
            isActive model.ui.viewInfo
    in
        div [ class "controls" ]
            [ hudButton "Chat" ToggleChatView chatClass
            , hudButton "Info" ToggleInfo infoClass
            ]


isActive : Bool -> String
isActive setting =
    case setting of
        True ->
            "hud-btn-is-active"

        False ->
            ""


hudButton : String -> msg -> String -> Html msg
hudButton name action class_ =
    button
        [ class ("button is-small hud toggle " ++ class_)
        , onClick action
        ]
        [ text name ]
