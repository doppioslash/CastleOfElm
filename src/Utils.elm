{--
Utils mostly by Josh Kirklin
from https://github.com/ScrambledEggsOnToast/2048-elm
--}

module Utils where

import List (head, (::), tail, map)

infixl 9 !
(!) : List a -> Int -> a -- the nth element of a list
l ! n = case (l,n) of
    (l,0) -> head l
    ((x::xs),n) -> xs ! (n-1)

transpose : List (List a) -> List (List a) -- transposes a list of lists
transpose ll = case ll of
    ((x::xs)::xss) -> (x :: (map head xss)) :: transpose (xs :: (map tail xss))
    otherwise -> []
