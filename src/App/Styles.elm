module App.Styles exposing (..)

import Css exposing (..)
import Css.Namespace exposing (namespace)
-- import Css.Elements exposing (..)


type CssClasses
    = ClassEmpty


type CssIds
    = WorldRenderer


css =
    (stylesheet << namespace "symians")
    [ everything
          [ padding (px 0)
          , margin (px 0)
          , boxSizing borderBox
          ]
    , id WorldRenderer
        [ position absolute
        ]
    ]

primaryAccentColor =
    hex "ccffaa"
