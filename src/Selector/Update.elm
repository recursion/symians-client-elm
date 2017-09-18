module Selector.Update exposing (update)

import World.Models exposing (Coordinates)
import Selector.Model exposing (Model, Mode(..), Msg(..))


remove : Coordinates -> Model -> Model
remove coords model =
    let
        notCoords =
            (\n -> n /= coords)

        nextSelected =
            List.filter notCoords model.selected
    in
        { model | selected = nextSelected }


add : Coordinates -> Model -> Model
add coords model =
    { model | selected = coords :: model.selected }

update msg model =
    case msg of
        Select coords ->
            updateSelection coords model
        MouseOver coords ->
            if model.enabled then
                updateSelection coords model
             else
                model

        ChangeMode mode ->
                { model | mode = mode }

updateSelection coords model =
    case model.mode of
        Designate ->
            add coords model

        Undesignate ->
            remove coords model

        SelectRect ->
            model
