{-# LANGUAGE TemplateHaskell #-}

import DropN

main =
  if ($(dropN 4 2) ("hello", 1, [4,3], 2)) == ([4,3], 2)
     then putStrLn "Test Passed"
     else putStrLn "Test Failed"
