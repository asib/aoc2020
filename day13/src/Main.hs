module Main where

import Data.List.Split (splitOn)

eGCD :: Integral a => a -> a -> (a, a, a)
eGCD 0 b = (b, 0, 1)
eGCD a b = let (g, s, t) = eGCD (b `mod` a) a
           in (g, t - (b `div` a) * s, s)

scheduleRaw  = "23,x,x,x,x,x,x,x,x,x,x,x,x,41,x,x,x,x,x,x,x,x,x,647,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,13,19,x,x,x,x,x,x,x,x,x,29,x,557,x,x,x,x,x,37,x,x,x,x,x,x,x,x,x,x,17"
schedule :: [(Integer, Integer)]
schedule = map (\(i,s) -> (i, read s)) . filter ((/="x") . snd) . zip [0..] . splitOn "," $ scheduleRaw

calc =
  flip foldl1 schedule $ \(a1, n1) (a2, n2) ->
    let
      (_, m1, m2) = eGCD n1 n2
      n'          = n1*n2
      a'          = a1*m2*n2 + a2*m1*n1
     in
      (a' `mod` n', n')

main :: IO ()
main = do
  -- Now we have a, n s.t. x = a (mod n), so to get x, we do n - a `mod` n
  let (a, n) = calc
  putStrLn . show $ (n - a) `mod` n
