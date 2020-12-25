module Main where

import System.IO
import Text.ParserCombinators.ReadP
import Data.Char (isDigit)

data Expr = Lit Int
          | Add Expr Expr
          | Mul Expr Expr
          | Parens Expr
          deriving (Show)

token :: ReadP a -> ReadP a
token p = do
  a <- p
  skipSpaces
  return a

keyword :: String -> ReadP String
keyword = token . string

infixOp :: String -> (a -> a -> a) -> ReadP (a -> a -> a)
infixOp s f = keyword s >> return f

op :: ReadP (Expr -> Expr -> Expr)
op = infixOp "+" Add +++ infixOp "*" Mul

number :: ReadP Int
number = return . read =<< munch1 isDigit

litExpr :: ReadP Expr
litExpr = token $ number >>= return . Lit

term :: ReadP Expr
term = litExpr +++ parenExpr

term' :: ReadP Expr
term' = litExpr +++ token (do
  char '('
  e <- expr'
  char ')'
  return $ Parens e
  )

opExpr :: ReadP Expr
opExpr = do
  e1 <- term
  o <- op
  e2 <- expr
  return $ o e1 e2

addOp = infixOp "+" Add
mulOp = infixOp "*" Mul

parenExpr :: ReadP Expr
parenExpr = token $ do
  char '('
  e <- expr
  char ')'
  return $ Parens e

expr :: ReadP Expr
expr = term `chainl1` op

expr' = (term' `chainl1` addOp) `chainl1` mulOp

run :: ReadP Expr -> String -> Expr
run p = fst . last . readP_to_S p

eval :: Expr -> Int
eval e =
  case e of
    Lit n -> n
    Add e e' -> eval e + eval e'
    Mul e e' -> eval e * eval e'
    Parens e -> eval e

calculate :: String -> Int
calculate = eval . run expr

calculate' = eval . run expr'

main :: IO ()
main = do
  handle <- openFile "input" ReadMode
  contents <- hGetContents handle

  {-mapM_ (putStrLn . show . calculate) $ lines contents-}
  putStrLn . show . sum . map calculate $ lines contents
  putStrLn . show . sum . map calculate' $ lines contents
