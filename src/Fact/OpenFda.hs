module Fact.OpenFda where

import Haxl.Core (GenHaxl, dataFetch)
import qualified Fact.OpenFdaApi as Api
import qualified Fact.OpenFdaSrc as Src

search :: Api.Limit -> (GenHaxl () a) Api.Body
search l = dataFetch (Src.Query l)
