module GameModel where

import Utils ((!), transpose)
import List (map)
import Graphics.Element (..)
import Graphics.Collage (..)

type Direction 
    = Left 
    | Right
    | Up
    | Down
    | None

type Action
    = NoOp
    | Move Direction


type alias Character =
    { x : Float
    , y : Float
    , dir: Direction
    }

type BackGroundTile
    = Floor --random floor tile
    | Wall WallTile

type ShadowTile
    = Main

type Tile
    = Door Size
    | Chest Size
    | Skull
    | Key
    | Money
    | Box
    | Lever
    | Flag Condition
    | Column
    | BackGround BackGroundTile
    | Shadow ShadowTile

type Size
    = Small
    | Big

type Condition
    = Ruined
    | Fine

type WallJunction
    = Flat
    | Empty


type alias WallTile = { r: WallJunction, l: WallJunction, u: WallJunction, d: WallJunction }

type Progress
    = InProgress 
    | GameOver 
    | Won

type alias Grid = List Tile --more than 1 layer

type alias Model = 
    { grid: Grid
    , pc : Character
}

gridSize : Int
gridSize = 15


{----------------------------------------------------
                    Tile Functions
-----------------------------------------------------}
drawTile : Tile -> Form
drawTile tile =
    let src = "../img/floor/floor_01.png" -- Hardcoded
    in
        toForm (image 64 64 src)

drawGrid : Grid -> Element
drawGrid grid = collage gridSize gridSize (map drawTile grid)

-- collisions : all except floor