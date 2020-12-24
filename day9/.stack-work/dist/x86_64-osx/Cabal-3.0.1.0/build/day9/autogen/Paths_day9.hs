{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_day9 (
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

bindir     = "/Users/jacobfenton/Desktop/advent_of_code/2020/day9/.stack-work/install/x86_64-osx/d45ad721f8f91716dae3af9c18a9eff2d7a21718ff4e34769ca4962d45bbe396/8.8.4/bin"
libdir     = "/Users/jacobfenton/Desktop/advent_of_code/2020/day9/.stack-work/install/x86_64-osx/d45ad721f8f91716dae3af9c18a9eff2d7a21718ff4e34769ca4962d45bbe396/8.8.4/lib/x86_64-osx-ghc-8.8.4/day9-0.1.0.0-FmIMAfUAMJRCXg9qsMGoGP-day9"
dynlibdir  = "/Users/jacobfenton/Desktop/advent_of_code/2020/day9/.stack-work/install/x86_64-osx/d45ad721f8f91716dae3af9c18a9eff2d7a21718ff4e34769ca4962d45bbe396/8.8.4/lib/x86_64-osx-ghc-8.8.4"
datadir    = "/Users/jacobfenton/Desktop/advent_of_code/2020/day9/.stack-work/install/x86_64-osx/d45ad721f8f91716dae3af9c18a9eff2d7a21718ff4e34769ca4962d45bbe396/8.8.4/share/x86_64-osx-ghc-8.8.4/day9-0.1.0.0"
libexecdir = "/Users/jacobfenton/Desktop/advent_of_code/2020/day9/.stack-work/install/x86_64-osx/d45ad721f8f91716dae3af9c18a9eff2d7a21718ff4e34769ca4962d45bbe396/8.8.4/libexec/x86_64-osx-ghc-8.8.4/day9-0.1.0.0"
sysconfdir = "/Users/jacobfenton/Desktop/advent_of_code/2020/day9/.stack-work/install/x86_64-osx/d45ad721f8f91716dae3af9c18a9eff2d7a21718ff4e34769ca4962d45bbe396/8.8.4/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "day9_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "day9_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "day9_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "day9_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "day9_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "day9_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
