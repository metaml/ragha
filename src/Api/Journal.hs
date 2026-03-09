module Api.Journal where

import Data.Aeson (FromJSON, ToJSON)
import Data.ByteString
import Data.Text (Text)
import Data.Time.Clock (UTCTime)
import GHC.Generics (Generic)
import Servant ( Application, Get, Header, JSON, NamedRoutes, Post, Proxy(..), ReqBody
               , (:>), (:-), serve
               )
import Servant.Server (Handler)
import Servant.Server.Internal (AsServerT)

data Journal = Journal { entry :: Text
                       , timestamp :: UTCTime
                       } deriving (Eq, Generic, Show, ToJSON, FromJSON)

newtype Entry = Entry { entry :: Text
                            } deriving (Eq, Generic, Show, ToJSON, FromJSON)

data List = List { page    :: Int
                 , entries :: Int
                 } deriving (Eq, Generic, Show, ToJSON, FromJSON)

data JournalApi mode = JournalApi
  { append :: mode :- "append" :> ReqBody '[JSON] Entry :> Post '[JSON] Journal
  , list   :: mode :- "list"   :> ReqBody '[JSON] List  :> Post '[JSON] [Journal]
  } deriving Generic

journalApi :: JournalApi (AsServerT Handler)
journalApi = JournalApi
  { append = append'
  , list   = list'
  }

append' :: Entry -> Handler Journal
append' x = do
  pure $ Journal undefined undefined

list' :: List -> Handler [Journal]
list' x = do
  pure [Journal undefined undefined]

type JournalRoutes = NamedRoutes JournalApi

journalApp :: Application
journalApp = serve (Proxy @JournalRoutes) journalApi

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
