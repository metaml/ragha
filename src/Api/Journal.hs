module Api.Journal where

import Data.Aeson (FromJSON, ToJSON)
import Data.ByteString
import Data.Text (Text)
import GHC.Generics (Generic)
import Servant.Server ()

newtype Token = Token ByteString

data Journal = Journal { entry :: Text }
  deriving (Eq, Generic, Show, ToJSON, FromJSON)



-- type JournalApi = Header "Authorization" Token :>
--                   ( "append" :>

-- journalServer :: Server JournalApi
-- journalServer = undefined


-- import Control.Monad.State.Strict (liftIO)
-- import Data.Aeson (FromJSON, ToJSON)
-- import Data.Time.Clock (UTCTime, getCurrentTime)
-- import GHC.Generics (Generic)
-- import Servant ((:>), (:-), Application, Get, JSON, Proxy(..), NamedRoutes, serve)
-- import Servant.Server.Internal (AsServerT, Handler)

-- newtype Ping = Ping { pong :: UTCTime }
--   deriving stock (Eq, Generic, Show)
--   deriving newtype (ToJSON, FromJSON)

-- type PingRoutes = NamedRoutes PingApi

-- data PingApi mode = PingApi
--   { ping :: mode :- "ping" :> Get '[JSON] Ping
--   } deriving Generic

-- pingApi :: PingApi (AsServerT Handler)
-- pingApi = PingApi { ping = ping' }

-- ping' :: Handler Ping
-- ping' = do
--   t <- liftIO getCurrentTime
--   pure (Ping { pong = t })

-- pingApp :: Application
-- pingApp = serve (Proxy @PingRoutes) pingApi
