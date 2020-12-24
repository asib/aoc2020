module Main where

import System.IO
import Data.List (sort)

path :: Int -> [Int] -> Int -> Int -> (Int, Int)
path _ [] one three = (one, three)
path joltage (a:as) one three
  | a-joltage == 1 = path a as (one+1) three
  | otherwise = path a as one (three+1)

main :: IO ()
main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle
  let nums = sort . map read $ lines contents :: [Int]

  let (a, a') = path 0 nums 0 0
  putStrLn . show $ (a, a'+1)
  putStrLn . show $ a*(a'+1)
