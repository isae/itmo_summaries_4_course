{-# LANGUAGE TemplateHaskell #-}

import LocaltimeTemplate

main = putStrLn $ "Localtime: " ++ $(localtimeTemplate)
