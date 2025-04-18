module Etc.Ragha where

import Dat.DukDukGo

run :: IO ()
run = query "haskell" >>= \case
  l@(Left _) -> print l
  Right r    -> print r
