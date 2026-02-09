module Main where

import Etc.Ragha (port, run)

main :: IO ()
main = do
  putStrLn ("listening on port: " <> show port)
  run
