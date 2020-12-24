module Main where

import System.IO
import qualified Data.Map as M

type Turn = Int
type LastUttered = Int
type UtteredOn = [Int]
data State = State Turn LastUttered (M.Map Int UtteredOn)
  deriving (Show)

input = [1,0,15,2,10,13]

step' :: State -> UtteredOn -> State
step' (State turn last mem) [n] = State (turn+1) 0 $ M.alter (step'' turn) 0 mem
step' (State turn last mem) (n:m:ms) = State (turn+1) (n-m) $ M.alter (step'' turn) (n-m) mem

step'' :: Turn -> Maybe UtteredOn -> Maybe UtteredOn
step'' turn Nothing   = Just [turn]
step'' turn (Just [t]) = Just [turn, t]
step'' turn (Just [t1,_]) = Just [turn, t1]

step :: State -> State
step state@(State turn last mem) = step' state $ (M.!) mem last

setup :: [Int] -> M.Map Int UtteredOn
setup = M.fromList . flip zip (fmap pure [1..])

untilTurn :: [Int] -> Int -> State
untilTurn ns turn = f state turn
  where
    state = State (1 + length ns) (last ns) (setup ns)
    f :: State -> Turn -> State
    f s@(State turn last mem) t
      | turn == t = step s
      | otherwise = f (step s) t

lastUttered :: State -> LastUttered
lastUttered (State _ l _) = l

main :: IO ()
main = do
  putStrLn . show . lastUttered $ untilTurn input 30000000
