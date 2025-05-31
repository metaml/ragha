module Datum.OpenFda where

import Haxl.Core (GenHaxl, dataFetch)
import qualified Datum.OpenFdaApi as Api
import qualified Datum.OpenFdaSrc as Src

search :: Api.Limit -> (GenHaxl () a) Api.Body
search l = dataFetch (Src.Query l)
