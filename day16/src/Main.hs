module Main where

import System.IO
import Text.Regex.Posix
import Data.List.Split (splitOn)
import Data.List (transpose, partition, isPrefixOf, nub)
import Control.Monad (guard)
import qualified Data.Map as M
import qualified Data.Set as S
import Control.Monad.CSP

type Field = String
type Range = [Int]
type Rule = (Field, Range)
type Ticket = [Int]
type InvalidValues = [Int]

parseRule :: String -> Rule
parseRule s = (field, [read min1..read max1]++[read min2..read max2])
  where (_, _, _, [field, min1, max1, min2, max2]) = s =~ "(.+): ([0-9]+)-([0-9]+) or ([0-9]+)-([0-9]+)" :: (String, String, String, [String])

adheres :: Int -> Rule -> Bool
adheres n (_, range) = n `elem` range

adheresToRules :: Int -> [Rule] -> Bool
adheresToRules n = any (adheres n)

matchingFields :: Int -> [Rule] -> [Field]
matchingFields n = map fst . filter (adheres n)

matchingFields' :: Ticket -> [Rule] -> S.Set Field
matchingFields' t rules = foldl1 S.intersection $ map (S.fromList . flip matchingFields rules) t

validate :: Ticket -> [Rule] -> InvalidValues
validate t rules = filter (not . flip adheresToRules rules) t

solve :: [[Field]] -> [Field]
solve fields = oneCSPSolution $ do
  dvs <- mapM mkDV fields
  mapAllPairsM_ (constraint2 (/=)) dvs
  return dvs

mapAllPairsM_ :: Monad m => (a -> a -> m b) -> [a] -> m ()
mapAllPairsM_ f []     = return ()
mapAllPairsM_ f (_:[]) = return ()
mapAllPairsM_ f (a:l) = mapM_ (f a) l >> mapAllPairsM_ f l

main :: IO ()
main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle
  let [rawRules, rawTicket, rawTickets] = map lines $ splitOn "\n\n" contents
      rules = map parseRule rawRules
      ticket = map read . splitOn "," $ rawTicket !! 1 :: [Int]
      tickets = map (map read . splitOn ",") $ drop 1 rawTickets :: [[Int]]

  putStrLn . show . sum . concat . map (flip validate rules) $ tickets

  let fieldVecs = transpose $ filter (foldl1 (&&) . map (flip adheresToRules rules)) tickets
      possibleFields = map (S.toList . flip matchingFields' rules) fieldVecs
      fields = filter (isPrefixOf "departure" . snd) . zip [0..] $ solve possibleFields
  putStrLn . show . product $ map (\(i, _) -> ticket !! i) fields
