module Main where

import Text.Regex.Posix
import System.IO
import Data.Char (digitToInt)
import Numeric    (readInt)
import Data.List ((\\), sort)

readBin :: Integral a => String -> a
readBin = fst . head . readInt 2 (`elem` "01") digitToInt

main :: IO ()
main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle
  let repl 'F' = '0'
      repl 'B' = '1'
      repl 'L' = '0'
      repl 'R' = '1'
      ids = map (\(r,c) -> r*8+c) . map (\v -> (readBin $ take 7 v, readBin $ drop 7 v)) . map (map repl) . lines $ contents
      maxId = maximum ids
  putStrLn $ show maxId
  putStrLn . show $ [0..maxId] \\ sort ids
