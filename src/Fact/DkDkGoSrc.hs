module Fact.DkDkGoSrc where

import Control.Concurrent.Async (async)
import Control.Concurrent.QSem (QSem, newQSem, signalQSem, waitQSem)
import Control.Exception (bracket_)
import Control.Monad (void)
import Data.Hashable (Hashable, hashWithSalt)
import Haxl.Core ( BlockedFetch(..), DataSource(..), DataSourceName(..)
                 , Flags, PerformFetch(..), State, StateKey, ShowP(..)
                 , putFailure, putSuccess
                 )
import Network.HTTP.Client (Manager)
import Servant.Client.Core (ClientError)
import qualified Fact.DkDkGoApi as Api

type Threads = Int

data QueryReq a where
  Query :: Api.Query -> QueryReq Api.Body

deriving instance Eq (QueryReq a)
deriving instance Show (QueryReq a)

instance ShowP QueryReq where showp = show

-- cache
instance Hashable (QueryReq a) where
  hashWithSalt s (Query q) = hashWithSalt s (0 :: Int, q :: Api.Query)

instance StateKey QueryReq where
  data State QueryReq = QueryState { manager :: Manager
                                   , semaphore :: QSem
                                   }

instance DataSourceName QueryReq where
  dataSourceName _ = "DkDkGo"

instance DataSource u QueryReq where
  fetch = queryFetch

initGlobalState :: Threads -> Manager -> IO (State QueryReq)
initGlobalState thrds mng = do
  sem <- newQSem thrds
  pure QueryState { manager = mng
                  , semaphore = sem
                  }

queryFetch :: State QueryReq -> Flags -> u -> PerformFetch QueryReq
queryFetch QueryState{..} _ _ = BackgroundFetch $ mapM_ (fetchAsync manager semaphore)

fetchAsync :: Manager -> QSem -> BlockedFetch QueryReq -> IO ()
fetchAsync mng sem (BlockedFetch req rvar) =
  void $ async $ bracket_ (waitQSem sem) (signalQSem sem) $ do
    fetchQueryReq mng req >>= \case
      Left  err -> putFailure rvar err
      Right res -> putSuccess rvar res

fetchQueryReq :: Manager -> QueryReq a -> IO (Either ClientError a)
fetchQueryReq mng (Query q) = Api.query' mng q
