module Main where

import System.IO
import Data.List (sort)

validate :: Int -> [Int] -> Either Int ()
validate window ns@(x:xs)
  | length ns <= window       = Right ()
  | length possiblePairs == 0 = Left checkVal
  | otherwise                 = validate window xs
  where
    options = take window ns
    checkVal = head $ drop window ns
    possiblePairs = [(a,b) | a <- options, b <- options, a+b == checkVal]

slidingWindowSum :: Int -> Int -> [Int] -> Either () [Int]
slidingWindowSum target window ns@(x:xs)
  | length ns < window  = Left ()
  | windowSum == target = Right slidingWindow
  | otherwise           = slidingWindowSum target window xs
  where
    slidingWindow = take window ns
    windowSum = sum slidingWindow

findSlidingWindow :: Int -> Int -> [Int] -> [Int]
findSlidingWindow target window ns =
  either (const $ findSlidingWindow target (window+1) ns) id $ slidingWindowSum target window ns

main :: IO ()
main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle
  let nums = map read $ lines contents :: [Int]
      weakness = either id (const 0) $ validate 25 nums

  putStrLn . show $ weakness

  let window = sort $ findSlidingWindow weakness 2 nums
  putStrLn . show $ (head window)+(head . reverse $ window)
