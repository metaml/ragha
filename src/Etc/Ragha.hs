module Etc.Ragha where

import Datum.DukDukGo

run :: IO ()
run = query "haskell" >>= \case
  l@(Left _) -> print l
  Right r    -> print r
