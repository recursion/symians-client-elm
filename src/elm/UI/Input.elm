module UI.Input exposing (..)

import UI.Camera as Camera


processKeypress code inputIgnored =
    if not inputIgnored then
        case code of
            82 ->
                -- r - move up z level
                Just Camera.moveZLevelUp

            70 ->
                -- f - move down z level
                Just Camera.moveZLevelDown

            87 ->
                Just Camera.moveUp

            83 ->
                Just Camera.moveDown

            65 ->
                Just Camera.moveLeft

            68 ->
                Just Camera.moveRight

            _ ->
               Nothing 
    else
        Nothing
