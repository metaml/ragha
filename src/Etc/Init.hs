module Etc.Init where

import System.Environment (lookupEnv, setEnv)

-- only setEnv when an env var doesn't exist
setEnvs :: [(String, String)] -> IO ()
setEnvs = mapM_ (uncurry setEnv')
  where setEnv' :: String -> String -> IO ()
        setEnv' e v = lookupEnv e >>= \case
          Nothing -> setEnv e v
          _       -> pure ()
