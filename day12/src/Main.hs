module Main where

import System.IO

type Waypoint = (Int, Int)
type State' = (Waypoint, Int, Int)
type State = (Int, Int, Int)
type Action = Char
type Value = Int
data Direction = L | R

evalStep :: State -> (Action, Value) -> State
evalStep (o, x, y) ('N', v) = (o, x, y+v)
evalStep (o, x, y) ('S', v) = (o, x, y-v)
evalStep (o, x, y) ('E', v) = (o, x+v, y)
evalStep (o, x, y) ('W', v) = (o, x-v, y)
evalStep (o@0,   x, y) ('F', v) = (o, x, y+v)
evalStep (o@180, x, y) ('F', v) = (o, x, y-v)
evalStep (o@90,  x, y) ('F', v) = (o, x+v, y)
evalStep (o@270, x, y) ('F', v) = (o, x-v, y)
evalStep (o, x, y) ('R', v) = ((o+v) `mod` 360, x, y)
evalStep (o, x, y) ('L', v) = ((o-v) `mod` 360, x, y)
evalStep s a = error $ show s ++ " " ++ show a

-- rotate 90 degrees in direction
rot :: Waypoint -> Direction -> Waypoint
rot (x, y) R  = (y, -x)
rot (x, y) L = (-y, x)

rot' :: Waypoint -> Direction -> Value -> Waypoint
rot' (wx, wy) d v = foldl (flip $ const $ flip rot d) (wx, wy) $ replicate ((abs v) `div` 90) 90

evalStep' :: State' -> (Action, Value) -> State'
evalStep' ((wx, wy), x, y) ('E', v) = ((wx+v, wy), x, y)
evalStep' ((wx, wy), x, y) ('W', v) = ((wx-v, wy), x, y)
evalStep' ((wx, wy), x, y) ('N', v) = ((wx, wy+v), x, y)
evalStep' ((wx, wy), x, y) ('S', v) = ((wx, wy-v), x, y)
evalStep' (w, x, y) ('L', v) = (rot' w L v, x, y)
evalStep' (w, x, y) ('R', v) = (rot' w R v, x, y)
evalStep' ((wx, wy), x, y) ('F', v) = ((wx, wy), x', y')
  where x' = x + wx*v
        y' = y + wy*v

main :: IO ()
main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle
  let moves = lines contents

  let (_, x, y) = foldl evalStep (90, 0, 0) $ map (\l -> (head l, read $ drop 1 l)) moves
  putStrLn . show $ abs x + abs y

  let (_, x, y) = foldl evalStep' ((10, 1), 0, 0) $ map (\l -> (head l, read $ drop 1 l)) moves
  putStrLn . show $ abs x + abs y
