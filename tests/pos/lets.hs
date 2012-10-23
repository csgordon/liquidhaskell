module Foo where

import Language.Haskell.Liquid.Prelude

foo :: Int -> (Int, Int)
foo z = (z, z + 1)

baz :: Int -> (Int, Int)
baz z = if z < 10 
          then (0, 1) 
          else let (i, j) = foo z in
               (i, j + 1)

{-@ prop :: Int -> Bool @-}
prop x = let (a, b) = baz x in
         liquidAssertB (a < b)