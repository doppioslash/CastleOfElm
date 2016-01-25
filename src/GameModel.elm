module GameModel where

import List exposing (map, concat, indexedMap, head, drop)
import Graphics.Element exposing (..)
import Graphics.Collage exposing (..)

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
    | WallOver WallTile
    | Wall
    | Water

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
    , gridSide: Float
    , pc : Character
}

ffff : WallTile
ffff = { r = Flat, u = Flat, l = Flat, d = Flat }
efef : WallTile
efef = { r = Empty, u = Flat, l = Empty, d = Flat }
feef : WallTile
feef = { r = Flat, u = Empty, l = Empty, d = Flat }
eeff : WallTile
eeff = { r = Empty, u = Empty, l = Flat, d = Flat }
fefe : WallTile
fefe = { r = Flat, u = Empty, l = Flat, d = Empty }
ffee : WallTile
ffee = { r = Flat, u = Flat, l = Empty, d = Empty }
effe : WallTile
effe = { r = Empty, u = Flat, l = Flat, d = Empty }
feee : WallTile
feee = { r = Flat, u = Empty, l = Empty, d = Empty }
eefe : WallTile
eefe = { r = Empty, u = Empty, l = Flat, d = Empty }
efff : WallTile
efff = { r = Empty, u = Flat, l = Flat, d = Flat }
ffef : WallTile
ffef = { r = Flat, u = Flat, l = Empty, d = Flat }
efee : WallTile
efee = { r = Empty, u = Flat, l = Empty, d = Empty }
fffe : WallTile
fffe = { r = Flat, u = Flat, l = Flat, d = Empty }

mainGrid : Grid
mainGrid = [BackGround (WallOver ffee), BackGround (WallOver efef), BackGround (WallOver efef), BackGround (WallOver efef),
            BackGround (WallOver efef), BackGround (WallOver efef), --first line
            BackGround (WallOver efef), BackGround (WallOver efef), BackGround (WallOver efef), BackGround (WallOver efef),
            BackGround (WallOver efef), BackGround (WallOver efef),
            BackGround (WallOver efef), BackGround (WallOver efef), BackGround (WallOver effe),

            BackGround (WallOver fefe), BackGround Wall, BackGround Wall, -- second line
            BackGround Wall, BackGround Wall, BackGround Wall, BackGround Wall, BackGround Wall, BackGround Wall,
            BackGround Wall, BackGround Wall, BackGround Wall, BackGround Wall, BackGround Wall, BackGround (WallOver fefe),

            BackGround (WallOver fefe), BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor,
            BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor,
            BackGround Floor, BackGround Floor, BackGround (WallOver fefe),

            BackGround (WallOver fefe), BackGround Floor, BackGround Floor,
            BackGround Floor, BackGround Floor, BackGround Floor, BackGround (WallOver fffe), BackGround Floor, BackGround Floor,
            BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor, BackGround (WallOver fefe),

            BackGround (WallOver fefe), BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor,
            BackGround (WallOver fefe), BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor,
            BackGround Floor, BackGround Floor, BackGround (WallOver fefe),

            BackGround (WallOver feee), BackGround (WallOver efef), BackGround (WallOver efef),
            BackGround (WallOver efee), BackGround (WallOver efef), BackGround (WallOver efef), BackGround (WallOver eeff), BackGround Floor, BackGround Floor,
            BackGround Floor, BackGround (WallOver ffef), BackGround (WallOver efef), BackGround (WallOver efef),
            BackGround (WallOver efef), BackGround (WallOver eefe),

            BackGround (WallOver fefe), BackGround Wall, BackGround Wall, BackGround (WallOver fefe), BackGround Wall,
            BackGround Wall,
            BackGround Wall, BackGround Floor, BackGround Floor, BackGround Floor, BackGround Wall, BackGround Wall,
            BackGround Wall, BackGround Wall, BackGround (WallOver fefe),

            BackGround (WallOver fefe), BackGround Floor, BackGround Floor,
            BackGround (WallOver fefe), BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor,
            BackGround Floor,
            BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor, BackGround (WallOver fefe),

            BackGround (WallOver fefe), BackGround Floor, BackGround Floor, BackGround (WallOver fefe),
            BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor,
            BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor, BackGround (WallOver fefe),

            BackGround (WallOver fefe), BackGround Floor, BackGround Floor, BackGround (WallOver feef), BackGround (WallOver efef),
            BackGround (WallOver efff),
            BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor,
            BackGround Floor, BackGround Floor, BackGround (WallOver fefe),

            BackGround (WallOver fefe), BackGround Floor, BackGround Floor,
            BackGround Wall, BackGround Wall, BackGround Wall, BackGround Floor, BackGround Floor, BackGround Floor,
            BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor, BackGround (WallOver fefe),

            BackGround (WallOver fefe), BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor,
            BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor, BackGround Floor,
            BackGround Floor, BackGround Floor, BackGround (WallOver fefe),

            BackGround (WallOver feef), BackGround (WallOver efef), BackGround (WallOver efef),  BackGround (WallOver efef),
            BackGround (WallOver efef), BackGround (WallOver efef), BackGround (WallOver efef), BackGround (WallOver efef),
            BackGround (WallOver efef), BackGround (WallOver efef), BackGround (WallOver efef), BackGround (WallOver efef),
            BackGround (WallOver efef), BackGround (WallOver efef), BackGround (WallOver eeff),

            BackGround Wall, BackGround Wall, BackGround Wall, BackGround Wall, BackGround Wall, BackGround Wall, --last line
            BackGround Wall, BackGround Wall, BackGround Wall, BackGround Wall, BackGround Wall, BackGround Wall,
            BackGround Wall, BackGround Wall, BackGround Wall,

            BackGround Water, BackGround Water, BackGround Water, BackGround Water, BackGround Water, BackGround Water, --last line
            BackGround Water, BackGround Water, BackGround Water, BackGround Water, BackGround Water, BackGround Water,
            BackGround Water, BackGround Water, BackGround Water]

gridSize = 15
tileSize = 64

getListIdx: Int -> Grid -> Maybe Tile
getListIdx idx list =
    head (drop idx list)

{----------------------------------------------------
                    Tile Functions
-----------------------------------------------------}

checkWallImg walltype =
  let
    getsrc side =
      case side of
        Flat ->
          "flat"
        Empty ->
          "empty"
    r = getsrc walltype.r
    l = getsrc walltype.l
    u = getsrc walltype.u
    d = getsrc walltype.d
  in
    "img/walls/" ++ r ++ "-" ++ u ++ "-" ++ l ++ "-" ++ d ++ ".png"


checkBgImg bgtype =
  case bgtype of
    Floor -> "img/floor/floor_01.png"
    Wall  -> "img/walls/wall.png"
    Water -> "img/water/water_01.png"
    WallOver tile -> checkWallImg tile

displayTile : Tile -> Element
displayTile tile =
    let
      src =
        case tile of
          BackGround tiletype ->
            checkBgImg tiletype
          _ ->""
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

getTileIdxFromPosition : (Float, Float) -> Int
getTileIdxFromPosition (x, y) =
    let
      x_tile = (round x) + 7
      y_tile = 8 - (round y)
    in
      (y_tile - 1) * gridSize + x_tile

displayGrid : (Int, Int) -> (Float, Float) -> Grid -> List Form -- display a grid
displayGrid frame pcCoords g =
    let
      tiles = indexedMap displayTileAtIndex g
    in
      tiles

-- collisions : all except floor
