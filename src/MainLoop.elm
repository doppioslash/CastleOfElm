import Color (..)
import Text (..)
import Debug
import Graphics.Collage (..)
import Graphics.Element (..)
import Keyboard
import Signal (Signal, (<~), map, merge, map2, foldp)
import Time (..)
import Window
--import Tiles (..)

type alias Model =
    { x : Float
    , y : Float
    , dir: Direction
    }

type alias WallTile = { r: WallJunction, l: WallJunction, u: WallJunction, d: WallJunction }

type alias Keys = { x:Int, y:Int }

type WallJunction
    = Flat
    | Empty

type Direction 
    = Left 
    | Right
    | Up
    | Down
    | None

type Action
    = NoOp
    | Move Direction

type Tiles
    = Door
    | SmallChest
    | BigChest
    | SmallDoor
    | Floor
    | Water

pc : Model
pc =
    { x = 0
    , y = 0 
    , dir = Right
    }

mainGrid : List Tiles
mainGrid = [ Floor, Floor, Floor, Floor, Floor, Floor, Floor]

-- UPDATE

update : Direction -> Model -> Model
update dir pc = 
    pc
        |> movepc dir
        -- if into monster slash


movepc : Direction -> Model -> Model
movepc dir pc =
    case dir of
        Up -> { pc | y <- pc.y + 1, dir <- Up }
        Down -> { pc | y <- pc.y - 1, dir <- Down }
        Left -> { pc | x <- pc.x - 1, dir <- Left }
        Right -> { pc | x <- pc.x + 1, dir <- Right }
        None -> pc

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

        src = "../img/pc/" ++ dir ++".png" -- Hardcoded
        pcImage = image 64 64 src
        groundY = 62 - h/2
    in
        -- drawGrid mainGrid
        collage w' h'
            [ pcImage
              |> toForm
              |> Debug.trace "pc"
              |> move (pc.x * 64, (64 * pc.y) + groundY)
            ]


-- SIGNALS

main : Signal Element
main =
  map2 view Window.dimensions (foldp update pc input)

inputDir : Signal Direction
inputDir = let dir ds  = 
                      if | ds == {x=0,y=1} -> Up
                         | ds == {x=0,y=-1} -> Down
                         | ds == {x=1,y=0} -> Right
                         | ds == {x=-1,y=0} -> Left
                         | otherwise -> None
    in merge (dir <~ Keyboard.arrows) (dir <~ Keyboard.wasd)

-- samples arrows when fps tick
input : Signal Direction
input =
    map (Debug.watch "direction") inputDir
