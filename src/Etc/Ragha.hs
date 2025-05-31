module Etc.Ragha where

import Datum.DkDkGoSrc (Threads)
import Haxl.Core (Env, initEnv, runHaxl, stateSet, stateEmpty)
import Network.HTTP.Client (newManager)
import Network.HTTP.Client.TLS (tlsManagerSettings)
import qualified Datum.DkDkGo as Dk
import qualified Datum.DkDkGoSrc as Dk
import qualified Datum.OpenFda as Fda
import qualified Datum.OpenFdaSrc as Fda

run :: Threads -> IO ()
run threads = do
  manager <- newManager tlsManagerSettings
  putStrLn "begin DuckDuckGo queries"
  stateDuck <- Dk.initGlobalState threads manager
  let state = stateSet stateDuck stateEmpty
  -- type sig. needed otherwise "ambiguous type variable ‘w0’ arising from a use of ‘initEnv’"
  env <- initEnv state () :: IO (Env () ())
  -- runs concurrently courtesy of Haxl
  runHaxl env (mapM Dk.search ["haskell", "purescript"]) >>= \r -> putStrLn ("😃😃😃" <> (show r))
  -- caching too courtexy of Haxl
  runHaxl env (mapM Dk.search ["haskell", "purescript"]) >>= print
  runHaxl env (mapM Dk.search ["haskell", "purescript"]) >>= print
  putStrLn "end DuckDuckGo queries"
  putStrLn "begin OpenFda queries"
  stateFda <- Fda.initGlobalState threads manager
  let state' = stateSet stateFda stateEmpty
  -- type sig. needed otherwise "ambiguous type variable ‘w0’ arising from a use of ‘initEnv’"
  env' <- initEnv state' () :: IO (Env () ())
  -- runs concurrently courtesy of Haxl
  runHaxl env' (mapM Fda.search [8, 16]) >>= \r -> putStrLn ("😃😃😃" <> (show r))
  -- caching too courtexy of Haxl
  runHaxl env' (mapM Fda.search [8, 16]) >>= print
  runHaxl env' (mapM Fda.search [8, 16]) >>= print
  putStrLn "end OpenFda queries"
