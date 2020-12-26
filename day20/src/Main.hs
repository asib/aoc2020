{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE TupleSections #-}
module Main where

import System.IO
import Data.List (transpose, sort)
import Data.List.Split (splitOn)
import Data.List.Extra (groupOn, sortOn)
import Control.Monad (guard)

data Tile = Tile { ix :: Int, top :: String, right :: String, bottom :: String, left :: String }
              deriving (Show, Eq, Ord)

edges Tile{top,left,bottom,right} =
  let n = [top,left,bottom,right] in n ++ map reverse n

tilefy :: Int -> [[Char]] -> Tile
tilefy ix rows = Tile{ix, top=head rows, right=last cols, bottom=last rows, left=head cols}
  where cols = transpose rows

main :: IO ()
main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle

  let tiles' = map ((\x -> uncurry tilefy (read . takeWhile (/=':') . drop 5 $ head x, drop 1 x)) . lines) $ splitOn "\n\n" contents
      tuplefy t@Tile{ix} = map (ix,) $ edges t
  putStrLn . show . product . map head . filter ((==4) . length) . groupOn id . sort . map (fst . head) . filter ((==1) . length) . groupOn snd . sortOn snd $ concatMap tuplefy tiles'
