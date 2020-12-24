module Main where

import System.IO
import Data.List (isPrefixOf)
import Data.Map (Map, insert, empty, keys, elems)
import Data.List.Split (splitOn)
import Numeric (showIntAtBase, readInt)
import Data.Char (intToDigit, digitToInt)

type Mask = String
type Loc = Integer
type Value = Integer
type Memory = Map Loc Value
type State = (Mask, Memory)

data Command = SetMask Mask
             | SetMem Loc Value
             deriving (Show)

maskify :: Value -> Mask
maskify v = pad ++ v'
  where pad = replicate (36 - length v') '0'
        v' = showIntAtBase 2 intToDigit v ""

readBin :: Integral a => String -> a
readBin = fst . head . readInt 2 (`elem` "01") digitToInt

unmaskify :: Mask -> Value
unmaskify = readBin

combine :: Mask -> Value -> Value
combine mask = unmaskify . zipWith combine' mask . maskify
  where
    combine' 'X' v = v
    combine'  m  v = m

expand :: Mask -> [Loc]
expand m = map unmaskify $ expand' [m]

expand' :: [Mask] -> [Mask]
expand' [] = []
expand' (m:ms)
  | not ('X' `elem` m) = m : expand' ms
  | otherwise          = expand' $ (rep 'X' '1' m) : (rep 'X' '0' m) : ms
  where
    rep :: Eq a => a -> a -> [a] -> [a]
    rep _ _ [] = []
    rep a b (x:xs) = if x == a then b:xs else x:rep a b xs

combine2 :: Mask -> Value -> [Loc]
combine2 mask = expand . zipWith combine' mask . maskify
  where
    combine' '0' v = v
    combine'  m  v = m

parse :: String -> Command
parse v
  | "mask" `isPrefixOf` v = SetMask $ drop (length "mask = ") v
  | otherwise           = SetMem loc val
  where
    loc = read . takeWhile (flip elem ['0'..'9']) $ drop (length "mem[") v
    val = read . last $ splitOn " = " v

eval :: State -> Command -> State
eval (mask, mem) (SetMask m) = (m, mem)
eval (mask, mem) (SetMem loc val) = (mask, insert loc v mem)
  where v = combine mask val

eval' :: State -> Command -> State
eval' (mask, mem) (SetMask m) = (m, mem)
eval' (mask, mem) (SetMem loc val) = (mask, foldl (\m x -> insert x val m) mem locs)
  where locs = combine2 mask loc

main :: IO ()
main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle
  let moves = lines contents

  let (_, mem)= foldl eval (replicate 36 'X', empty) $ map parse moves
  putStrLn . show . sum $ elems mem

  let (_, mem)= foldl eval' (replicate 36 'X', empty) $ map parse moves
  putStrLn . show . sum $ elems mem
