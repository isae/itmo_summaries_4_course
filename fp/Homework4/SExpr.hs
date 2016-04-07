module SExpr where 

import AParser
import Control.Applicative
import Data.Char

--1
zeroOrMore :: Parser a -> Parser [a]
oneOrMore :: Parser a -> Parser [a]

doNothing = Parser (\xs -> Just ([], xs))

oneOrMore p = (:) <$> p <*> zeroOrMore p
zeroOrMore p = oneOrMore p <|> doNothing 

--2
spaces = zeroOrMore (satisfy isSpace)
ident = (:) <$> (satisfy isAlpha) <*> zeroOrMore (satisfy isAlphaNum)
char c = satisfy (==c)

--3
type Ident = String
data Atom = N Integer | I Ident
    deriving Show
data SExpr = A Atom | Comb [SExpr] deriving Show

parseSExpr :: Parser SExpr
parseSExpr = spaces *> ((A <$> parseAtom) <|> (Comb <$> parseComb)) <* spaces

parseAtom :: Parser Atom
parseAtom = (N <$> posInt) <|> (I <$> ident)

parseComb :: Parser [SExpr]
parseComb = (char '(') *> oneOrMore parseSExpr <* (char ')')
