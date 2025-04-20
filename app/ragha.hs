module Main where

import Etc.Ragha (run)

-- @todo: daemonize this process
main :: IO ()
main = let threads = 8 in run threads
