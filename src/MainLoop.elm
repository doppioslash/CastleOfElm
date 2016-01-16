import Color exposing (..)
import Text exposing (..)
import Debug
import Graphics.Collage exposing (..)
import Graphics.Element exposing (image, Element)
import Keyboard
import Signal exposing (Signal, map, merge, map2, foldp)
import Time exposing (..)
import GameModel exposing (..)
import List exposing (repeat)

pcState : Character
pcState =
    { x = 0
    , y = 0 
    , dir = Right
    } -- tiredness strenght blabla

model : Model
model = 
    { grid = mainGrid
    , gridSide = gridWidth
    , pc = pcState }

-- UPDATE

update : Direction -> Model -> Model
update dir model = 
    model
        |> movepc dir
        -- if into monster slash


movepc : Direction -> Model -> Model
movepc dir model =
    let 
        checkPc default pc =
            let 
                x = pc.x |> Debug.watch "pc x"
                y = pc.y |> Debug.watch "pc y"
                idx = getTileIdxFromPosition (pc.x, pc.y) |> Debug.watch "idx"
                tile = getListIdx idx model.grid |> Debug.watch "tile"
            in
              case tile of
                Nothing -> pc
                Just tilet -> if tilet == BackGround Floor then pc else default 
        updatePc pc dir = 
            case dir of
                Up ->  { pc |  y = pc.y + 1, dir = Up }
                Down -> { pc | y = pc.y - 1, dir = Down }
                Left -> { pc | x = pc.x - 1, dir = Left }
                Right -> { pc | x = pc.x + 1, dir = Right }
                None -> pc
    in 
        { model | pc = (checkPc model.pc (updatePc model.pc dir)) }

-- on which tile it ends up
-- which other tiles become visible
-- which mosters are in range to attack
-- or be attacked
-- update monsters paths and spawn them
-- update time ticking

-- VIEW
view : Model -> Element
view model =
    let
        dir =
            case model.pc.dir of
              Left -> "left"
              Right -> "right"
              Up -> "up"
              Down -> "down"
              _ -> "none"
        src = "../img/pc/" ++ dir ++".png" -- Hardcoded
        pcImage = image 64 64 src
    in
        collage (round model.gridSide) (round model.gridSide) ((displayGrid mainGrid) ++
            [pcImage
              |> toForm
              |> Debug.trace "pc"
              |> move (model.pc.x * 64, (64 * model.pc.y))])
            
-- SIGNALS

main : Signal Element
main =
  map view (foldp update model input)

inputDir : Signal Direction
inputDir = let dir { x, y }  = 
                      case (x, y) of
                        (  0,  1 ) -> Up
                        (  0, -1 ) -> Down
                        (  1,  0 ) -> Right
                        ( -1,  0 ) -> Left
                        _ -> None
    in merge (Signal.map dir Keyboard.arrows) (Signal.map dir Keyboard.wasd)

-- samples arrows when fps tick
input : Signal Direction
input =
    map (Debug.watch "direction") inputDir
