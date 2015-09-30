import Text.Regex
import Text.Read
import Control.Exception.Base
import CachedSumList

-- task 1 --
toIntArray :: [String] -> [Int]
toIntArray a = map read a
toMaybeIntArray a = map readMaybe a
sumInts :: [Int] -> Int
sumInts t = foldl (+) 0 t
splitByWhitespace s = splitRegex 
            (mkRegex "[\t\n\r ]+")
             s
toIntArrayFromString s = toIntArray (filter (/= "") (splitByWhitespace s))
toMaybeIntArrayFromString :: String -> [Maybe Int]
toMaybeIntArrayFromString s = toMaybeIntArray (filter (/= "") (splitByWhitespace s))
sumIntsFromString s = sumInts (toIntArrayFromString s)

tests = ["1", "1 2 3", " 1", "1 ", "\t1\t", "\t12345\t", "010 020 030", 
         " 123 456 789 ", "-1", "-1 -2 -3", "\t-12345\t", " -123 -456 -789 ", 
         "\n1\t\n3   555  -1\n\n\n-5", "123\t\n\t\n\t\n321 -4 -40"]
testResults = [1, 6, 1, 1, 1, 12345, 60, 1368, -1, -6, -12345, -1368, 553, 400]

testSumIntFromString =  assert 
        (map (sumIntsFromString) tests == testResults) 
        "1: Positive tests passed" 

mustFail = ["asd", "1-1", "1.2", "--2", "+1", "1+"]
testAllBad = foldl (&&) True 
    (map
        (== Nothing)
        (concat 
            (map 
                (toMaybeIntArrayFromString)
                 mustFail
            )
        ) 
    ) 

testSumIntFromStringFailure =  assert 
        testAllBad
        "1: Negative tests passed" 
-- end of task 1 --
















main = do 
    putStrLn testSumIntFromString
    putStrLn testSumIntFromStringFailure 
