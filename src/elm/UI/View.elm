module UI.View exposing (render)

import Html exposing (Html, text, div, label, span, button, table, tr, td)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import App.Model exposing (Msg(ChatMsg, ToggleInfo, ToggleChatView), Model)
import UI.Model as UI exposing (Camera, TileData)
import Chat.View


-- hud rendering


render : Model -> Html Msg
render model =
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
    table [ class "hud hud-tiledata" ]
        [ renderTileData "type: " [ text model.loc.type_ ]
        , renderTileData "x: " [ text model.x ]
        , renderTileData "y: " [ text model.y ]
        , renderTileData "z: " [ text model.z ]
        , renderTileData "entities:" (List.map renderEntity model.loc.entities)
        ]


renderTileData : String -> List (Html Msg) -> Html Msg
renderTileData key value =
    tr [ class "tiledata" ]
        [ td [ class "tiledata-label" ] [ text key ]
        , td [ class "tiledata-value" ] value
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
