module Api.Api where

import Api.Ping (PingApi, pingApi)
import GHC.Generics (Generic)
import Network.Wai.Middleware.Cors (simpleCors)
import Servant ( (:>), (:-)
               , Application, Proxy(..), NamedRoutes
               , serve
               )

type ApiRoutes = NamedRoutes Api

data Api mode = Api
  { ops     :: mode :- "ops"    :> NamedRoutes PingApi
  } deriving Generic

apiApp :: Application
apiApp = simpleCors $ serve (Proxy @ApiRoutes) api
  where api = Api { ops     = pingApi
                  }
