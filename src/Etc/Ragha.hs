module Etc.Ragha where

import Datum.DkDkGo (search)
import Datum.DkDkGoSrc (initGlobalState)
import Haxl.Core (initEnv, runHaxl, stateSet, stateEmpty)
import Network.HTTP.Client (Manager, newManager)
import Network.HTTP.Client.TLS (tlsManagerSettings)

run :: IO ()
run = do
  let threads = 8 :: Int
  manager <- newManager tlsManagerSettings
  duckstate <- initGlobalState threads manager
  -- let state = (stateSet duckstate stateEmpty) :: _
  -- env <- initEnv state ()
  -- r <- runHaxl env $ mapM search ["haskell"]
  print ""
