module Main where

import Etc.Ragha (port, run)

-- @todo: daemonize this process
main :: IO ()
main = do
  putStrLn ("listening on port: " <> show port)
  run
