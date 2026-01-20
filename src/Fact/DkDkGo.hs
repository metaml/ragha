module Fact.DkDkGo where

import Haxl.Core (GenHaxl, dataFetch)
import qualified Fact.DkDkGoApi as Api
import qualified Fact.DkDkGoSrc as Src

-- type Haxl a = GenHaxl () a

search :: Api.Query -> (GenHaxl () a) Api.Body
search q = dataFetch (Src.Query q)
