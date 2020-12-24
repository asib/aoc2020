module Main where

import System.IO
import Data.List.Split (splitOn)
import Data.List (nub, delete, intersect)

bigIntersect :: [String] -> String
bigIntersect = foldl intersect ['a'..'z']

main :: IO ()
main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle
  let responses = splitOn "\n\n" $ contents
      unique = map (length . delete '\n' . nub) responses
      grouped = map (splitOn "\n") responses
  putStrLn . show . sum $ unique
  {-mapM_ (putStrLn . show) grouped-}
  putStrLn . show . sum . map (length . bigIntersect) $ grouped
