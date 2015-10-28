import System.IO
import System.Environment

main = do 
    (filename:args) <- getArgs
    file <- readFile filename
    putStrLn $ processFile file

convert :: String -> String
convert x:y:z:xs 
    | x == '-' = x:y:'.':xs
    | otherwise = x:'.':z:xs


processFile :: String -> String
processFile input = show list where 
    list = map ((read::Double) . convert) $ map words $ drop 1 $ lines input
