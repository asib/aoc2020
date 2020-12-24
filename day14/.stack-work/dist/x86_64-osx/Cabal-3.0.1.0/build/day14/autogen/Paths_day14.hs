{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_day14 (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/jacobfenton/Desktop/advent_of_code/2020/day14/.stack-work/install/x86_64-osx/66bbfd6c7625ae5b2661731da3581f30c0e37a5a68381af578aa3d65d43f410d/8.8.4/bin"
libdir     = "/Users/jacobfenton/Desktop/advent_of_code/2020/day14/.stack-work/install/x86_64-osx/66bbfd6c7625ae5b2661731da3581f30c0e37a5a68381af578aa3d65d43f410d/8.8.4/lib/x86_64-osx-ghc-8.8.4/day14-0.1.0.0-F5hjUdjglJV8Do0xmBPQ00-day14"
dynlibdir  = "/Users/jacobfenton/Desktop/advent_of_code/2020/day14/.stack-work/install/x86_64-osx/66bbfd6c7625ae5b2661731da3581f30c0e37a5a68381af578aa3d65d43f410d/8.8.4/lib/x86_64-osx-ghc-8.8.4"
datadir    = "/Users/jacobfenton/Desktop/advent_of_code/2020/day14/.stack-work/install/x86_64-osx/66bbfd6c7625ae5b2661731da3581f30c0e37a5a68381af578aa3d65d43f410d/8.8.4/share/x86_64-osx-ghc-8.8.4/day14-0.1.0.0"
libexecdir = "/Users/jacobfenton/Desktop/advent_of_code/2020/day14/.stack-work/install/x86_64-osx/66bbfd6c7625ae5b2661731da3581f30c0e37a5a68381af578aa3d65d43f410d/8.8.4/libexec/x86_64-osx-ghc-8.8.4/day14-0.1.0.0"
sysconfdir = "/Users/jacobfenton/Desktop/advent_of_code/2020/day14/.stack-work/install/x86_64-osx/66bbfd6c7625ae5b2661731da3581f30c0e37a5a68381af578aa3d65d43f410d/8.8.4/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "day14_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "day14_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "day14_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "day14_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "day14_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "day14_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
