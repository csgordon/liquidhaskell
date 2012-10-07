module Array where

import Language.Haskell.Liquid.Prelude

{-@ set :: forall a <p :: x0: Int -> x1: a -> Bool, r :: x0: Int -> Bool>.
             i: Int<r> ->
             x: a<p i> ->
             a: (j: {v: Int<r> | v != i} -> a<p j>) ->
             (k: Int<r> -> a<p k>) @-}
set :: Int -> a -> (Int -> a) -> (Int -> a)
set i x a = \k -> if k == i then x else a k

{-@ zero ::
      i: {v: Int | v >= 0} ->
      n: Int ->
      a: (j: {v: Int | (0 <= v && v < i)} -> {v: Int | v = 0}) ->
      (k: {v: Int | (0 <= v && v < n)} -> {v: Int | v = 0}) @-}
zero :: Int -> Int -> (Int -> Int) -> (Int -> Int)
zero i n a = if i >= n then a
                       else zero (i + 1) n (set i 0 a)

create x = \i -> x

{-@ tenZeroes :: i: {v: Int | (0 <= v && v < 10)} -> {v: Int | v = 0} @-}
tenZeroes = zero 0 10 (create 1)

{-@ zeroBackwards ::
      i: Int ->
      n: {v: Int | v > i} ->
      a: (j: {v: Int | (i < v && v < n)} -> {v: Int | v = 0}) ->
      (k: {v: Int | (0 <= v && v < n)} -> {v: Int | v = 0}) @-}
zeroBackwards :: Int -> Int -> (Int -> Int) -> (Int -> Int)
zeroBackwards i n a = if i < 0 then a
                               else zeroBackwards (i - 1) n (set i 0 a)

{-@ tenZeroes' :: i: {v: Int | (0 <= v && v < 10)} -> {v: Int | v = 0} @-}
tenZeroes' = zeroBackwards 9 10 (create 1)

{-@ zeroEveryOther ::
      i: {v: Int | (v >= 0 && v mod 2 = 0)} ->
      n: Int ->
      a: (j: {v: Int | (0 <= v && v < i && v mod 2 = 0)} -> {v: Int | v = 0}) ->
      (k: {v: Int | (0 <= v && v < n && v mod 2 = 0)} -> {v: Int | v = 0}) @-}
zeroEveryOther :: Int -> Int -> (Int -> Int) -> (Int -> Int)
zeroEveryOther i n a = if i >= n then a
                       else zeroEveryOther (i + 2) n (set i 0 a)

{-@ stridedZeroes ::
      j: {v: Int | (v mod 2 = 0 && 0 <= v && v < 10)} -> {v: Int | v = 0} @-}
stridedZeroes = zeroEveryOther 0 10 (create 1)