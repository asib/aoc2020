module Main where

import System.IO
import Data.Set (Set, insert, member)
import qualified Data.Set as S

evalInstr :: String -> String -> Int -> Int -> (Int, Int)
evalInstr "nop" _ i a = (i+1, a)
evalInstr "acc" ('+':arg) ip acc = (ip+1, acc+(read arg))
evalInstr "acc" ('-':arg) ip acc = (ip+1, acc-(read arg))
evalInstr "jmp" ('+':arg) ip acc = (ip+(read arg), acc)
evalInstr "jmp" ('-':arg) ip acc = (ip-(read arg), acc)

eval :: Int -> [String] -> Set Int -> Int -> (Int, Bool)
eval ip is visitedIps acc
  | ip > length is         = (acc, True)
  | ip `member` visitedIps = (acc, False)
  | otherwise              = eval ip' is (ip `insert` visitedIps) acc'
  where
    instr = head $ drop (ip-1) is
    op = takeWhile (/= ' ') instr
    arg = dropWhile (\x -> not $ x `elem` "+-") instr
    (ip', acc') = evalInstr op arg ip acc

changeInstr :: [String] -> Int -> [String]
changeInstr is target
  | targetOp == "jmp" = priorInstrs ++ ["nop" ++ targetArg] ++ drop target is
  | targetOp == "nop" = priorInstrs ++ ["jmp" ++ targetArg] ++ drop target is
  | otherwise         = is
  where
    priorInstrs = take (target - 1) is
    targetInstr = head $ drop (target - 1) is
    targetOp = take 3 targetInstr
    targetArg = drop 3 targetInstr

main :: IO ()
main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle
  let instructions = lines contents
  putStrLn . show $ eval 1 instructions S.empty 0

  putStrLn . show . filter snd . map (\is -> eval 1 is S.empty 0) . map (changeInstr instructions) $ [1..(length instructions)]
