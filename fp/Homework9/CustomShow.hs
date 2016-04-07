{-# LANGUAGE TemplateHaskell, QuasiQuotes #-}
module CustomShow where

import Language.Haskell.TH
import Language.Haskell.TH.Syntax
import Data.List

listFields :: Name -> Q [Dec]
listFields name = do
  TyConI (DataD _ _ _ ((RecC ctr fields):xs) _) <- reify name
  let names = map (\(name,_,_) -> name) fields
  let ctrName = showName ctr
  let showField :: Name -> Q Exp
      showField name = [|\x -> s ++ " = " ++ show ($(varE name) x)|]
        where s = nameBase name
  let showFields :: Q Exp
      showFields = listE $ map showField names
  [d|instance Show $(conT name) where
          show x = (ctrName) ++ ": " ++ (intercalate ", "
                          (map ($ x) $showFields))|]

data MyData = MD
  { foo :: String
  , bar :: Int
  }
