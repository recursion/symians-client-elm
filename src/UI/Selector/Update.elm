module UI.Selector.Update exposing (update)

import World.Models exposing (Coordinates)
import UI.Selector.Model exposing (Model, Mode(..), Msg(..))


update msg model =
    case msg of
        StartSelection coords ->
            { model | start = Just coords, buffer = [ coords ] }

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
            case model.mode of
                Designate ->
                    { model
                        | start = Nothing
                        , enabled = False
                        , selected = (model.buffer ++ model.selected)
                        , buffer = []
                    }

                Undesignate ->
                    { model
                        | start = Nothing
                        , enabled = False
                        , selected = removeSelection model.buffer model.selected
                        , buffer = []
                    }


updateSelection coords model =
    case model.mode of
        Designate ->
            { model | buffer = generateSelection coords model }

        Undesignate ->
            { model | buffer = generateSelection coords model }


removeSelection selection selected =
    List.filter (\loc -> not (List.member loc selection)) selected


generateSelection coords model =
    let
        start =
            case model.start of
                Nothing ->
                    coords

                Just coords_ ->
                    coords_

        difference a b =
            if a > b then
                a - b
            else
                b - a

        width =
            difference start.x coords.x

        height =
            difference start.y coords.y

        yRange =
            if start.y > coords.y then
                List.range (start.y - height) start.y
            else
                List.range start.y (start.y + height)

        xRange =
            if start.x > coords.x then
                List.range (start.x - width) start.x
            else
                List.range start.x (width + start.x)

        generateCoords x =
            List.map (wrapCoords x) yRange

        wrapCoords x y =
            (Coordinates x y coords.z)
    in
        List.concatMap generateCoords xRange
