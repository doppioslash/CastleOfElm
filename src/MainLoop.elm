import Color (..)
import Text (..)
import Debug
import Graphics.Collage (..)
import Graphics.Element (..)
import Keyboard
import Signal
import Time (..)
import List (..)
import Window
import Set
--import Tiles (..)

type alias Model =
    { x : Float
    , y : Float
    , dir: Direction
    }

type alias Keys = { x:Int, y:Int }

type Direction 
    = Left 
    | Right
    | Up
    | Down

type Action
    = NoOp
    | Move Direction

pc : Model
pc =
    { x = 0
    , y = 0 
    , dir = Right
    }

-- UPDATE

update : Keys -> Model -> Model
update keys pc = 
    pc
        |> vertical keys
        |> horizontal keys

vertical : Keys -> Model -> Model
vertical keys pc =
    if  | keys.y > 0 -> { pc | y <- pc.y + 1, dir <- Up }
        | keys.y < 0 -> { pc | y <- pc.y - 1, dir <- Down }
        | otherwise -> pc

horizontal : Keys -> Model -> Model
horizontal keys pc =
    if  | keys.x > 0 -> { pc | x <- pc.x + 1, dir <- Right }
        | keys.x < 0 -> { pc | x <- pc.x - 1, dir <- Left }
        | otherwise -> pc

-- user input 
-- on which tile it ends up
-- which other tiles become visible
-- which mosters are in range to attack
-- or be attacked
-- update monsters paths and spawn them
-- update time ticking

-- VIEW
view : (Int, Int) -> Model -> Element
view (w',h') pc =
    let (w,h) = (toFloat w', toFloat h')
        dir =
            case pc.dir of
              Left -> "left"
              Right -> "right"
              Up -> "up"
              Down -> "down"

        src = "../img/pc/" ++ dir ++".png"
        pcImage = image 64 64 src
        groundY = 62 - h/2
    in
        collage w' h'
            [ pcImage
              |> toForm
              |> Debug.trace "pc"
              |> move (pc.x * 64, (64 * pc.y) + groundY)
            ]

-- SIGNALS

main : Signal Element
main =
  Signal.map2 view Window.dimensions (Signal.foldp update pc input)

-- samples arrows when fps tick
input : Signal Keys
input =
    Signal.map (Debug.watch "arrows") Keyboard.arrows