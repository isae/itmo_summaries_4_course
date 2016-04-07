{-# LANGUAGE TemplateHaskell #-}

import CustomShow

listFields ''MyData
main = print $ MD { foo = "bar", bar = 5 }
