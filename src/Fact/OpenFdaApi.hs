module Fact.OpenFdaApi where

import Data.Aeson (Object)
import Data.Proxy (Proxy(..))
import Data.Text (Text)
import Network.HTTP.Client (Manager)
import Servant.Client ( BaseUrl(..), ClientM, Scheme(..)
                      , client, mkClientEnv, runClientM
                      )
import Servant.Client.Core (ClientError)
import Servant.API ((:>), Get, JSON, QueryParam)

type Query = Text
type Limit = Int
type Body = Object
type Error = Text

-- https://api.fda.gov/food/event.json?search=date_started:[20240101+TO+20251231]&limit=10
type OpenFdaApi = "event.json"
                  :> QueryParam "search" Query
                  :> QueryParam "limit" Limit
                  :> Get '[JSON] Body

openFdaApi :: Proxy OpenFdaApi
openFdaApi = Proxy

search :: Maybe Query -> Maybe Limit -> ClientM Body
search = client openFdaApi

-- works: ghci> query
--        Right (fromList [("meta",Object ...
query :: Manager -> Limit -> IO (Either ClientError Body)
query mng lim = do
  let url  = "api.fda.gov"
      port = 443
      baseUrl = BaseUrl Https url port "food"
      q = Just "date_started:[20240101 TO 20251231]"
  runClientM (search q (Just lim)) (mkClientEnv mng baseUrl)
