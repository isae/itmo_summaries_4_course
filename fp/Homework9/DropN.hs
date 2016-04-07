module DropN where

import Language.Haskell.TH
import Control.Monad

dropN :: Int -> Int -> Q Exp
dropN n m = do
  listNames <- mapM newName $ ('x':) <$> show <$> [1..n]
  return $ let list = map VarP listNames in
    LamE [TupP $ map VarP listNames] (TupE $ drop m $ map VarE listNames)

