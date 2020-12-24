module Main where
{-# LANGUAGE OverloadedStrings #-}


import System.IO
import Data.Char (digitToInt)
import Data.List (group, sort)
import Data.List.Index (indexed)
import Text.Regex.Posix

parseLine :: String -> (Int, Int, Char, String)
parseLine s = (read min, read max, head c, pass)
  where
    (_, _, _, [min, max, c, pass]) =
      s =~ "([0-9]+)-([0-9]+) ([a-z]): ([a-z]+)" :: (String, String, String, [String])

conforms :: (Int, Int, Char, String) -> Bool
conforms (min, max, c, s) = count >= min && count <= max
  where
    count = maybe 0 id $ lookup c $ map (\x -> (head x, length x)) $ group $ sort s

conforms' :: (Int, Int, Char, String) -> Bool
conforms' (i, j, c, s) = (f i) /= (f j)
  where
    f n = maybe False (\x -> x == c) $ lookup (n-1) $ indexed s

main :: IO ()
main = do
  handle <- openFile "resources/input" ReadMode
  contents <- hGetContents handle
  {-putStrLn . show . map parseLine $ lines contents-}
  let conformMap = map (\x -> (x, conforms x)) $ map parseLine $ lines contents
  let conforming = filter snd $ conformMap
  putStrLn . show . length $ conforming

  let conformMap = map (\x -> (x, conforms' x)) $ map parseLine $ lines contents
  let conforming = filter snd $ conformMap
  putStrLn . show . length $ conforming
