module Datum.DkDkGo where

import Haxl.Core (GenHaxl, dataFetch)
import qualified Datum.DkDkGoApi as Api
import qualified Datum.DkDkGoSrc as Src

-- type Haxl a = GenHaxl () a

search :: Api.Query -> (GenHaxl () a) Api.Body
search q = dataFetch (Src.Query q)
