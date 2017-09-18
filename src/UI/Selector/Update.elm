module UI.Selector.Update exposing (update)

import World.Models exposing (Coordinates)
import UI.Selector.Model exposing (Model, Mode(..), Msg(..))


update msg model =
    case msg of
        Select coords ->
            updateSelection coords { model | start = Just coords }

        MouseOver coords ->
            if model.enabled then
                updateSelection coords model
            else
                model

        ChangeMode mode ->
            { model | mode = mode, start = Nothing }

        Enable ->
            { model | enabled = True }

        Disable ->
            { model | enabled = False, selected = (model.buffer ++ model.selected), buffer = [] }


updateSelection coords model =
    case model.mode of
        Designate ->
            add coords model

        Undesignate ->
            remove coords model

        SelectRect ->
            let
                selected =
                    createSelection coords model
            in
                case model.selected of
                    [] ->
                        { model | start = Just coords, buffer = selected }

                    _ ->
                        { model | buffer = selected }


createSelection coords model =
    let
        start =
            case model.start of
                Nothing ->
                    coords

                Just coords_ ->
                    coords_

        width =
            if start.x > coords.x then
                start.x - coords.x
            else
                coords.x - start.x

        height =
            if start.y > coords.y then
                start.y - coords.y
            else
                coords.y - start.y

        generateCoords x =
            let
                range =
                    if start.y > coords.y then
                        (List.range (start.y - height) start.y)
                    else
                        (List.range start.y (start.y + height))
            in
                List.map (wrapCoords x) range

        wrapCoords x y =
            (Coordinates x y coords.z)
    in
        let
            range =
                if start.x > coords.x then
                    List.range (start.x - width) start.x
                else
                    List.range start.x (width + start.x)
        in
            List.concatMap generateCoords range


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
    { model | selected = model.selected ++ [ coords ] }
