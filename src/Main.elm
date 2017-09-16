module Main exposing (..)

import Html exposing (Html, div)
import App.Model exposing (Model, Msg(UIMsg), Flags)
import UI.Model as UI
import App.Update exposing (update)
import App.Socket as Socket
import App.Init exposing (init)
import App.View exposing (root)

main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = root
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Socket.listen model
        , Sub.map UIMsg (UI.subscriptions model.ui)
        ]
