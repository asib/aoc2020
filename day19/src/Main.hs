module Main where

import System.IO
import Text.ParserCombinators.ReadP
import Data.Char (isDigit)
import Data.Maybe (mapMaybe, isJust)
import Data.List.Split (splitOn)
import qualified Data.Map as M

data Rule = Recursive [[Int]]
          | Ground Char
          deriving (Show)

token :: ReadP a -> ReadP a
token p = do
  a <- p
  skipSpaces
  return a

number :: ReadP Int
number = return . read =<< munch1 isDigit

ruleNumber :: ReadP Int
ruleNumber = number <* string ": "

ground :: ReadP Rule
ground = fmap Ground $ char '"' *> get <* char '"'

numList :: ReadP [Int]
numList = many1 $ token number

recursive :: ReadP Rule
recursive = Recursive <$> numList `sepBy1` string "| "

rule :: ReadP (Int, Rule)
rule = do
  n <- ruleNumber
  r <- ground +++ recursive
  return (n, r)

run :: ReadP a -> String -> Maybe a
run p s
  | length result == 0 = Nothing
  | otherwise    = Just $ head result
  where result = [x | (x, "") <- readP_to_S p s]

-- Get a list of ground rules
buildParser ::  M.Map Int Rule -> Int -> ReadP String
buildParser m ix =
  case m M.! ix of
    Ground p -> (:[]) <$> char p
    Recursive options -> choice $ map (foldl1 (>>) . map (buildParser m)) options

main :: IO ()
main = do
  interact' "input"
  interact' "input3"

interact' :: String -> IO ()
interact' filename = do
  handle <- openFile filename ReadMode
  contents <- hGetContents handle
  let [rules, msgs] = map lines $ splitOn "\n\n" contents
      parsedRules = M.fromList $ mapMaybe (run rule) rules
      zero = buildParser parsedRules 0 <* eof

  putStrLn . show . length . filter (isJust . run zero) $ msgs
