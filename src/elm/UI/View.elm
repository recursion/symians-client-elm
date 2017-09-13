module UI.View exposing (renderHud)

import Html exposing (Html, div, nav, a, button, text, span, p, label, canvas)
import Html.Attributes exposing (id, class, attribute, href)
import Html.Events exposing (onClick)
import App.Model exposing (Msg(..), Model)
import UI.Model as UI exposing (Camera, TileData)
import Chat.View


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
