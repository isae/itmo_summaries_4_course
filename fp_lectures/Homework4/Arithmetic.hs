import SExpr hiding (Atom, parseAtom, N)
import AParser
import Control.Applicative
import Data.Char

data Expr = Plus Term Expr | Minus Term Expr | Ex Term deriving (Show)
data Term = Mul Factor Term | Div Factor Term | Te Factor deriving (Show)
data Factor = Pow Atom Factor | At Atom deriving (Show)
data Atom = Par Expr | N Integer deriving (Show)

parseExpr :: Parser Expr
-- parseExpr = undefined
parseExpr = --spaces *> (
        (Plus <$> parseTerm <*> ((char '+') *> parseExpr )) <|>
        (Minus <$> parseTerm <*> ((char '-') *> parseExpr )) <|>
        (Ex <$> parseTerm)
    --) <* spaces

parseTerm :: Parser Term
parseTerm = 
        (Mul <$> parseFactor <*> ((char '*') *> parseTerm )) <|>
        (Div <$> parseFactor <*> ((char '/') *> parseTerm )) <|>
        (Te <$> parseFactor)

parseFactor :: Parser Factor
parseFactor =
        (Pow <$> parseAtom <*> ((char '^') *> parseFactor )) <|>
        (At <$> parseAtom)

parseAtom :: Parser Atom
parseAtom = spaces *> (
        (Par <$> ((char '(') *> parseExpr <* (char ')')) )<|>
        (N <$> posInt)
    ) <* spaces

evaluateE :: Expr -> Integer
evaluateE (Plus t e) = (evaluateT t) + (evaluateE e)
evaluateE (Minus t e) = (evaluateT t) - (evaluateE e)
evaluateE (Ex t) = (evaluateT t)

evaluateT (Mul f t) = (evaluateF f) * (evaluateT t)
evaluateT (Div f t) = (evaluateF f) `div` (evaluateT t)
evaluateT (Te f) = (evaluateF f)

evaluateF (Pow a f) = (evaluateA a) ^ (evaluateF f)
evaluateF (At a) = (evaluateA a)

evaluateA (Par e) = (evaluateE e)
evaluateA (N n) = n

evaluate :: String -> Maybe Integer
evaluate s = evaluateE <$> fst <$> (runParser parseExpr s)

