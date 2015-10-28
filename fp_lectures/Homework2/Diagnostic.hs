module Diagnostic where 

type Range = (Int, Int)

data Diagnostic t = D Range String deriving (Show, Eq)

data Warning = Warning deriving (Show, Eq)
data Error  = Error deriving (Show, Eq)

warningT = undefined :: Warning
errorT   = undefined :: Error

createDiagnostic :: t -> Range -> String -> Diagnostic t
createDiagnostic _ r s = D r s

d1 = createDiagnostic warningT (1, 2) "This is warning"
d2 = D (3, 4) "This is error" :: Diagnostic Error

overlaps :: Diagnostic t -> Diagnostic t -> Range
overlaps (D (a, b) msg1) (D (c, d) msg2) = (l,r) where 
    l = max a c
    r = min b d
