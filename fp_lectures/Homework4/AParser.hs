module AParser where 

import Data.Char
import Control.Applicative

newtype Parser a
    = Parser { runParser :: String -> Maybe (a, String) }

applyFirst f (a,s) = (f a,s)

instance Functor Parser where
    fmap fun (Parser a) =  Parser f where
        f s = first <$> (a s)
        first (a, s) = (fun a, s) 

instance Applicative Parser where
    pure a = Parser (\_ -> Just (a,[]))
    (Parser alg1) <*> (Parser alg2) = Parser res where
        res str = do
            (f,rem) <- alg1 str 
            (v,rem2) <- alg2 rem
            return (f v,rem2)

type Name = String
data Employee = Emp { name :: Name, phone :: String } deriving (Show)

abParser :: Parser (Char, Char)

abParser = Parser f where
    f ('a':'b':xs) = Just (('a','b'), xs)
    f _ = Nothing

abParser_ :: Parser ()
abParser_ = (\_->()) <$> abParser

posInt :: Parser Integer
posInt = Parser f where
    f xs
        | null ns = Nothing
        | otherwise = Just (read ns, rest)
            where (ns, rest) = span isDigit xs

satisfy :: (Char -> Bool) -> Parser Char
satisfy p = Parser f where 
    f [] = Nothing -- fail on the empty input
    f (x:xs) -- check if x satisfies the predicate
        | p x = Just (x, xs)
        | otherwise = Nothing -- otherwise, fail

skipSpace = Parser f where
    f list@(x:xs) = Just $ if x == ' ' then (id,xs) else (id,list)
    f _ = Nothing

intPair = (,) <$> posInt <*> (skipSpace <*> posInt)


instance Alternative Parser where
    empty = Parser (\_ -> Nothing)
    (Parser p1) <|> (Parser p2) = Parser f where 
        f str = (p1 str) <|> (p2 str) 

ignoreArg p = (\_ -> ()) <$> p

intOrUppercase :: Parser ()
intOrUppercase = (ignoreArg $ satisfy isUpper) <|> (ignoreArg posInt)


