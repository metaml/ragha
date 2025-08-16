module Main where

import Etc.Dot as Dot

-- @todo: daemonize this process
main :: IO ()
main = Dot.run threads where threads = 8
