module Paths_Notebook (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/iisaev/.cabal/bin"
libdir     = "/Users/iisaev/.cabal/lib/x86_64-osx-ghc-7.10.3/Notebook-0.1.0.0-Fj6U8bMAMV0EXBycppeVv8"
datadir    = "/Users/iisaev/.cabal/share/x86_64-osx-ghc-7.10.3/Notebook-0.1.0.0"
libexecdir = "/Users/iisaev/.cabal/libexec"
sysconfdir = "/Users/iisaev/.cabal/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "Notebook_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "Notebook_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "Notebook_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "Notebook_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "Notebook_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
