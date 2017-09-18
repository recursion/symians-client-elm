module UI.Styles exposing (..)

import Css exposing (..)
import Css.Namespace exposing (namespace)
-- import Css.Elements exposing (..)


type CssClasses
    = Block
    | Button
    | Button__Selected


type CssIds
    = Controls


css =
    (stylesheet << namespace "hud")
        [ class Block
              [ backgroundColor primaryBackgroundColor
              ]
        , class Button
            [ flexGrow (int 1)
            , padding (px 2)
            , hover
                  [ backgroundColor secondaryColor ]
            ]
        , class Button__Selected
            [ backgroundColor primaryAccentColor
            ]
        , id Controls
            [ position fixed
            , left (px 1)
            , top (pct 25)
            , flexDirection column
            , displayFlex
            ]
        ]

primaryBackgroundColor =
    rgba 50 100 50 0.25

primaryAccentColor =
    rgba 100 150 100 0.8
 
secondaryColor =
    rgba 75 200 75 0.25
