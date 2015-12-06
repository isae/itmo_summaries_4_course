import System.Environment
import System.IO
import System.IO.Error
import System.Directory
import GHC.IO.Handle
import Control.Exception
import Data.List
import Data.Array.IO
import Data.Maybe
import qualified Data.HashTable.IO as H

interactStr = "Edit(E Number), Write to file(W OutputFileName), Quit(Q) ?"
type HashTable k v = H.BasicHashTable k v

writeArrayToFile :: (IOArray Int String) -> HashTable Int Bool -> Handle -> IO ()
writeArrayToFile arr ht handle = do
    (i,r) <- getBounds arr
    write i arr ht handle where 
        write :: Int -> (IOArray Int String) -> HashTable Int Bool -> Handle -> IO ()
        write i arr ht handle = do 
            (left,right) <- getBounds arr
            if (i > right) then do return ()
                else do 
                    entry <- H.lookup ht i 
                    if(isJust entry) then
                        do 
                            str <- readArray arr i
                            hPutStrLn handle str
                    else do return()
                    write (i+1) arr ht handle

doSome :: String -> (IOArray Int String) -> HashTable Int Bool -> IO ()
doSome command arr ht
    | (isPrefixOf "E" command) = do 
        let lineNumber = (read (tail command) :: Int) in do
            newLine <- getLine
            writeArray arr lineNumber newLine :: IO()
            H.insert ht lineNumber True
            return ()
    | (isPrefixOf "W" command) = let filename = (tail $ tail command) in do 
        fileExist <- doesFileExist filename
        handle <- openFile filename AppendMode 
        writeArrayToFile arr ht handle
        if not fileExist then do 
            putStrLn $ "File `" ++ filename ++ "`created, all changes saved"
        else putStrLn "Changes appended to existing file"
        hClose handle
        return ()
    | (command == "Q") = do return ()
    | otherwise = do putStrLn "unknown command" >> return ()

interactWithUser arr ht = do
    putStrLn interactStr
    command <- getLine
    doSome command arr ht
    if (command == "Q") then do putStrLn "Bye" >> return ()
        else interactWithUser arr ht

toTry = do
    args <- getArgs
    if (length args /= 2)
        then do
            putStrLn "Correct call: grep <string> <path>"
            return ()
        else do 
            handle <- openFile (args !! 1) ReadMode 
            contents <- filter (isInfixOf (args !! 0 )) 
                <$> lines 
                <$> hGetContents handle 
            mapM_ (\(n, line) -> putStrLn $ (show n) ++ ". " ++ line) $ zip [1..] contents
            arr <- newListArray (1,length(contents)) contents :: IO (IOArray Int String)
            ht <- H.new
            interactWithUser arr ht
            hClose handle  

main = toTry `catch` handler 

handler :: IOError -> IO ()  
handler e 
    | isAlreadyInUseError e = putStrLn "File is already in use" 
    | isDoesNotExistError e = putStrLn "File does not exist"
    | isPermissionError e = putStrLn "Permision denied"
