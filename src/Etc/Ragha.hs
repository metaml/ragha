module Etc.Ragha where

import Datum.DkDkGo (search)
import Datum.DkDkGoSrc (Threads, initGlobalState)
import Haxl.Core (Env, initEnv, runHaxl, stateSet, stateEmpty)
import Network.HTTP.Client (newManager)
import Network.HTTP.Client.TLS (tlsManagerSettings)

run :: Threads -> IO ()
run threads = do
  manager <- newManager tlsManagerSettings
  stateDuck <- initGlobalState threads manager
  let state = stateSet stateDuck stateEmpty
  -- type sig. needed otherwise "ambiguous type variable ‘w0’ arising from a use of ‘initEnv’"
  env <- initEnv state () :: IO (Env () ())
  -- runs concurrently courtesy of Haxl
  runHaxl env (mapM search ["haskell", "purescript"]) >>= \r -> putStrLn ("😃😃😃" <> (show r))
  -- caching too courtexy of Haxl
  runHaxl env (mapM search ["haskell", "purescript"]) >>= print
  runHaxl env (mapM search ["haskell", "purescript"]) >>= print
