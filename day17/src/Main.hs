module Main where

import System.IO
import Control.Monad (guard)
import qualified Data.Set as M

type Idx3 = (Int, Int, Int)
type Idx4 = (Int, Int, Int, Int)
type Universe ix = M.Set ix
type NeighboursFn ix = ix -> [ix]

-- return list of live neighbour indices
neighbours :: Idx3 -> [Idx3]
neighbours (x,y,z) = do
  x' <- [x-1..x+1]
  y' <- [y-1..y+1]
  z' <- [z-1..z+1]
  guard (x /= x' || y /= y' || z /= z')
  pure (x',y',z')

neighbours' :: Idx4 -> [Idx4]
neighbours' (x,y,z,w) = do
  x' <- [x-1..x+1]
  y' <- [y-1..y+1]
  z' <- [z-1..z+1]
  w' <- [w-1..w+1]
  guard (x /= x' || y /= y' || z /= z' || w /= w')
  pure (x',y',z',w')

liveNeighbours :: Ord ix => Universe ix -> [ix] -> [ix]
liveNeighbours u ixs = do
  ix' <- ixs
  if M.member ix' u
     then pure ix'
     else []

-- We only need to check active cubes and their neighbours - all others are
-- guaranteed to remain inactive.
needToCheck :: Ord ix => NeighboursFn ix -> Universe ix -> [ix]
needToCheck neighbours = concatMap neighbours . M.elems

step' :: Ord ix => NeighboursFn ix -> ix -> Universe ix -> Bool
step' neighbours ix u = if M.member ix u
                           then alive `elem` [2,3]
                           else (alive == 3)
  where alive = length . liveNeighbours u $ neighbours ix

step :: Ord ix => NeighboursFn ix -> Universe ix -> Universe ix
step neighbours u = M.fromList . filter (flip (step' neighbours) u) $ needToCheck neighbours u

main :: IO ()
main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle

  let universe = M.fromList . map fst . filter ((/='.') . snd) . concatMap (\(y, row) -> zip [(x,y,0) | x <- [0..]] row) . zip [0..] $ lines contents
  let universe' = M.fromList . map fst . filter ((/='.') . snd) . concatMap (\(y, row) -> zip [(x,y,0,0) | x <- [0..]] row) . zip [0..] $ lines contents

  putStrLn . show . M.size $ foldr (.) id (replicate 6 $ step neighbours) $ universe
  putStrLn . show . M.size $ foldr (.) id (replicate 6 $ step neighbours') $ universe'
