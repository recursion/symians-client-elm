module UI.View exposing (hudView, controlsView)

import Html exposing (Html, div, nav, a, button, text, span, p, label)
import Html.Attributes exposing (id, class, attribute, href)
import Html.Events exposing (onClick)
import App.Model exposing (..)


--TODO: divide the coordinates by the tilesize so we get raw coords?


hudView : Model -> Html Msg
hudView model =
    div [ class "hud hud-tiledata" ]
        [ renderTileData "type: " [ text model.tileData.loc.type_ ]
        , renderTileData "x: " [ text model.tileData.x ]
        , renderTileData "y: " [ text model.tileData.y ]
        , renderTileData "entities:" (List.map renderEntity model.tileData.loc.entities)
        ]


controlsView : Model -> Html Msg
controlsView model =
    let
        chatClass =
            isActive model.ui.viewChat

        infoClass =
            isActive model.ui.viewInfo

    in
        div [ class "controls" ]
            [ hudButton "Chat" ToggleChatView  chatClass
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


renderTileData : String -> List (Html Msg) -> Html Msg
renderTileData key value =
    label [ class "tilelabel" ]
        [ text key
        , span [ class "tiledata" ] value
        ]


renderEntity : String -> Html Msg
renderEntity entity =
    div [ class "entity-data" ] [ text entity ]
