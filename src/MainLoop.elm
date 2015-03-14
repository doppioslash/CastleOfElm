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
    , dir : Direction
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

update : (Float, Keys) -> Keys
update (dt, keys) = keys
    {--
    case action of
        Move dir ->
            case dir of
                Right -> { model | x <- model.x + 1 }
                Left -> { model | x <- model.x - 1 }
                Up -> { model | y <- model.y + 1 }
                Down -> { model | y <- model.y - 1 }--}
        

-- user input 
-- on which tile it ends up
-- which other tiles become visible
-- which mosters are in range to attack
-- or be attacked
-- update monsters paths and spawn them
-- update time ticking

-- VIEW


-- SIGNALS


main : Signal Element
main =
  Signal.map asText input

-- samples arrows when fps tick
input : Signal (Float, Keys)
input =
  let delta = Signal.map (\t -> t/20) (fps 60)
      deltaArrows =
          Signal.map2 (,) delta (Signal.map (Debug.watch "arrows") Keyboard.arrows)
  in
      Signal.sampleOn delta deltaArrows