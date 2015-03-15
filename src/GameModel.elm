module GameModel where

import Utils ((!), transpose)
import List (map, concat, indexedMap)
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

tileSize : Int
tileSize = 64

{----------------------------------------------------
                    Tile Functions
-----------------------------------------------------}
displayTile : Tile -> Element
displayTile tile =
    let src =
            case tile of
              BackGround tiletype -> "../img/floor/floor_01.png"
    in
        image tileSize tileSize src

displayTileAtCoordinates : (Tile, Int, Int) -> Form
displayTileAtCoordinates (t,i,j) = 
    let position = 
          ( (toFloat tileSize) * (toFloat i - (toFloat gridSize - 1)/2)
        , (-1) * (toFloat tileSize) * (toFloat j - (toFloat gridSize - 1)/2))
    in 
        move position <| toForm <| displayTile t

displayTileAtIndex : Int -> Tile -> Form
displayTileAtIndex index tile =
    let
        y =  index // gridSize
        x =  index % gridSize
    in 
        displayTileAtCoordinates (tile, x, y)

gridWidth : Float -- the width of the entire game grid
gridWidth = (toFloat gridSize) * (toFloat tileSize)

displayGrid : Grid -> Element -- display a grid
displayGrid g = 
    let
        tiles = indexedMap displayTileAtIndex g
    in 
        collage (round gridWidth) (round gridWidth) tiles

-- collisions : all except floor