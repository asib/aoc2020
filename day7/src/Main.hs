module Main where

import Text.Regex.Posix
import System.IO
import Data.List (nub, delete, intersect)
import Data.List.Split (splitOn)
import Data.Map (Map, fromList, findWithDefault, keys)

retrieveBagWithNumber :: String -> (String, Int)
retrieveBagWithNumber s = (s', read n)
  where
    (_, _, _, (n:s':_)) =
      s =~ "([0-9]+) ([a-z]+ [a-z]+) bags?" :: (String, String, String, [String])

parseRule :: String -> (String, [(String, Int)])
parseRule line
  | noSubBags = (mainBag, [])
  | otherwise = (mainBag, subBagStrs)
  where
    (_, _, _, [mainBag, subBagsStr]) =
      line =~ "([a-z]+ [a-z]+) bags contain (.+)\\." :: (String, String, String, [String])
    noSubBags = subBagsStr =~ "no other bags" :: Bool
    subBagStrs = map retrieveBagWithNumber . splitOn ", " $ subBagsStr

-- Search for val in the map by following paths starting at keys in ks.
searchByDescent :: (Eq k, Ord k) => k -> Map k [k] -> [k] -> Bool
searchByDescent _   _ [] = False
searchByDescent val m (k:ks)
  | val `elem` subBags = True
  | otherwise          = searchByDescent val m (subBags ++ ks)
  where
    subBags = findWithDefault [] k m

productByDescent :: (Eq k, Ord k) => Map k [(k, Int)] -> [(k, Int)] -> Int -> Int
productByDescent _ [] n = n
productByDescent m ((k, n):ks) accum
  | subBags == [] = productByDescent m ks (accum+n)
  | otherwise     = productByDescent m (factoredSubBags ++ ks) (accum+n)
  where
    subBags = findWithDefault [] k m
    factoredSubBags = map (\(x, m) -> (x, n*m)) subBags


main :: IO ()
main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle
  let unparsedRules = lines contents
      parsedRules = map parseRule unparsedRules
      ruleMap = fromList . map (\(a,b) -> (a, map fst b)) $ parsedRules
      ruleMap' = fromList parsedRules
      canContainShinyGold = map (searchByDescent "shiny gold" ruleMap . return) $ keys ruleMap

  putStrLn . show . length . filter id $ canContainShinyGold
  putStrLn . show . subtract 1 $ productByDescent ruleMap' [("shiny gold", 1)] 0
