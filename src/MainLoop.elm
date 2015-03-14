import Color (..)
import Debug
import Graphics.Collage (..)
import Graphics.Element (..)
import Keyboard
import Signal
import Time (..)
import List (..)
import Window
import Signal.Extra

type alias Attributes = -- PC and NPC
    { str: Int, int: Int, con: Int, dex: Int }

type alias Character = 
    { x: Int
    , y: Int
    , hp: Int
    , sprite: Int
    , attributes: Attributes
    }

type alias Tile = 
    { x: Int
    , y: Int
    , tileCode: TileCode
    , things: List Thing 
    }

type KeyMapping = {}

type alias Grid = List Tile -- made of tiles

type alias MainGrid = List Grid

type Character
    = PC
    | NPC

type Thing
    = None
    | PC
    | NPC
    | Door
    | Item
    | Empty

type TileCode 
    = Terrain   
    | Stone
    | Blah
    | Door
    | Roof

type Direction 
    = Left 
    | Right
    | Up
    | Down

type Action
    = NoOp
    | Move Direction
    | Use (Thing, Tile) -- thing is like potion or weapon, tile is the target
    | Open Thing
    | Close Thing
    | Rest
    | Disarm Trap
    | Search Tile
    | Get Tile
    | FreeHand
    | ShowMap
    | ShowInventory
    | TakeStairs Tile
    | MoveMoveOver Tile

type Reactions
    = Spawn Character
    | Hit Character
    | Activate Trap
    | Show Tile

-- UPDATE

-- something needs to parse an input and get an action out of it

update : Action -> Model -> Model
update action model =
    case action of
        Reset -> ""

-- random generation of dungeon

randomGeneration : (Int, Int) -> Grid

-- user input 
-- on which tile it ends up
-- which other tiles become visible
-- which mosters are in range to attack
-- or be attacked
-- update monsters paths and spawn them
-- update time ticking
-- consume mana if used magic

-- VIEW
--- draw the tiles
--- and the sprites

-- SIGNALS
--- the Player moving makes everything go on one step


main = 
