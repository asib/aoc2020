module Main where

import Text.Regex.Posix
import System.IO
import Data.List.Split (splitOn, splitOneOf)

keyExists :: Eq a => a -> [(a, b)] -> Bool
keyExists k l = maybe False (const True) $ lookup k l

fs = map keyExists ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

valid :: Eq a => (a, b -> Bool) -> [(a, b)] -> Bool
valid (k, validator) l =
  maybe False validator $ lookup k l

num min max v = v' >= min && v' <= max
  where v' = read v

hgt :: String -> Bool
hgt x
  | hgtCm = n >= 150 && n <= 193
  | hgtIn = n >= 59 && n <= 76
  | otherwise = False
  where
    hgtCm = x =~ "^[0-9]{3}cm$" :: Bool
    hgtIn = x =~ "^[0-9]{2}in$" :: Bool
    nStr = x =~ "^[0-9]+" :: String
    n = read nStr :: Int

col "amb" = True
col "blu" = True
col "brn" = True
col "gry" = True
col "grn" = True
col "hzl" = True
col "oth" = True
col _ = False

hcl :: String -> Bool
hcl v = v =~ "^#[0-9a-f]{6}$" :: Bool

pid :: String -> Bool
pid v =  v =~ "^[0-9]{9}$" :: Bool

fs' = map valid [ ("byr", num 1920 2002)
                , ("iyr", num 2010 2020)
                , ("eyr", num 2020 2030)
                , ("hgt", hgt)
                , ("hcl", hcl)
                , ("ecl", col)
                , ("pid", pid)
                ]


main :: IO ()
main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle
  let passports = map (map (\s -> (takeWhile ((/=) ':') s, tail . dropWhile ((/=) ':') $ s))) . map (splitOneOf "\n ") . splitOn "\n\n" $ contents
  let valid = map (\al -> all id $ map ($ al) fs) passports
  putStrLn . show . length . filter (==True) $ valid

  let valid = map (\al -> all id $ map ($ al) fs') passports
  putStrLn . show . length . filter (==True) $ valid
