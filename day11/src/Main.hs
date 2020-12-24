module Main where

import System.IO
import Control.Monad (guard)
import Data.List (intersperse)

type Board = [String]
type GetPos = Board -> Int -> Int -> Char
type Neighbours = Board -> Int -> Int -> [Char]
type Step = Board -> Int -> Int -> Char

getPos :: Board -> Int -> Int -> Char
getPos b@(a:as) x y
  | x < 0 || x > length a - 1 || y < 0 || y > length b - 1 = '.'
  | otherwise = head . drop x . head . drop y $ b

getPos' :: Board -> Int -> Int -> Char
getPos' b@(a:as) x y
  | x < 0 || x > length a - 1 || y < 0 || y > length b - 1 = 'O'
  | otherwise = head . drop x . head . drop y $ b

neighbours :: Board -> Int -> Int -> [Char]
neighbours b x y = do
  x' <- [x-1..x+1]
  y' <- [y-1..y+1]
  guard (x' /= x || y' /= y)
  return $ getPos b x' y'

firstVisible :: Board -> Int -> Int -> Int -> Int -> Char
firstVisible b x y dx dy
  | v == 'O'  = '.'
  | v == '.'  = firstVisible b x' y' dx dy
  | otherwise = v
  where
    v = getPos' b x' y'
    x' = x+dx
    y' = y+dy

visibleNeighbours :: Board -> Int -> Int -> [Char]
visibleNeighbours b x y = do
  dx <- [-1..1]
  dy <- [-1..1]
  guard (dx /= 0 || dy /= 0)
  return $ firstVisible b x y dx dy

step :: GetPos -> Neighbours -> Int -> Board -> Int -> Int -> Char
step getPos neighbours threshold b x y
  | v == 'L' && all (/='#') ns = '#'
  | v == '#' && length (filter (=='#') ns) >= threshold = 'L'
  | otherwise = v
  where
    v = getPos b x y
    ns = neighbours b x y

annotate :: Board -> Int -> [[(Char, Int, Int)]]
annotate [] _ = []
annotate (r:rs) row =
  (zipWith (\p (x, y) -> (p, x, y)) r [(x', row) | x' <- [0..]]) : (annotate rs (row+1))

equillibrium :: Step -> Board -> Board
equillibrium step b
  | b' == b = b
  | otherwise = equillibrium step b'
  where
    b' = map (map (\(c, x, y) -> step b x y)) $ annotate b 0

main :: IO ()
main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle
  let board = lines contents

  mapM_ (putStrLn . intersperse ' ' . show) board

  let eq = equillibrium (step getPos neighbours 4) board
  putStrLn . show . length . filter (=='#') $ concat eq

  let eq = equillibrium (step getPos' visibleNeighbours 5) board
  putStrLn . show . length . filter (=='#') $ concat eq
