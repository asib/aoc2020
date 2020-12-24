module Main where

import System.IO

walk :: [String] -> (Int, Int) -> Int -> Int -> Int
walk matrix p@(right, down) step trees
  | length matrix <= (step*down) = trees
  | otherwise = walk matrix p (step+1) trees'
  where
    (row:ys) = drop (step*down) matrix
    trees' = case (head . drop (step*right) $ row) of '#' -> trees+1
                                                      otherwise -> trees

main :: IO ()
main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle
  let matrix = map (concat . repeat) $ lines contents
  putStrLn . show . product $ map (\x -> walk matrix x 1 0) [ (3, 1)
                                                            , (1, 1)
                                                            , (5, 1)
                                                            , (7, 1)
                                                            , (1, 2)
                                                            ]
