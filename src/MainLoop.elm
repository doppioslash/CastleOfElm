import Window
import Debug exposing (watch, log)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (image, Element)
import Keyboard
import Signal exposing (Signal, map, merge, map2, foldp)
import GameModel exposing (..)

pcState : Character
pcState = { x = 0, y = 0, dir = Right } -- tiredness strenght blabla

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

-- get window dimensions signal
-- calculate what tiles to draw:
-- how many fit vertically
-- how many fit horizontally
-- what is the center (PC)


-- VIEW
matchToSide : (Int, Int) -> Int -> (Int, Int)
matchToSide frame side =
  let
    ( w, h ) = frame
    tW =  w // side 
    tH =  h // side 
  in
    ((log "tW" tW) , (log "tH" tH) )

view : (Int, Int) -> Model -> Element
view frame model =
    let
      tileSide = 64
      dir =
        case model.pc.dir of
          Left -> "left"
          Right -> "right"
          Up -> "up"
          Down -> "down"
          _ -> "none"
      src = "img/pc/" ++ dir ++".png" -- Hardcoded
      pcImage = image tileSide tileSide src
      (tW, tH) = matchToSide (log "win" frame) tileSide
      tWSide = (tW * tileSide)
      tHSide = (tH * tileSide)
    in
      collage tWSide tHSide ((displayGrid (10, 10) mainGrid) ++ [pcImage
                                                                   |> toForm
                                                                   |> Debug.trace "pc"
                                                                   |> move (model.pc.x * tileSide, (tileSide * model.pc.y))])
            
-- SIGNALS

main : Signal Element
main =
  map2 view Window.dimensions (foldp update model input) 

-- INPUTS: CONTROLS
inputDir : Signal Direction
inputDir =
  let dir { x, y }  = 
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
