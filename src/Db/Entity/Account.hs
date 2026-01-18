module Db.Entity.Account where

import Data.Int (Int32)
import Data.Text (Text)
import Data.Time (UTCTime)
import Data.UUID (UUID)
import Database.Beam (Identity)
import Database.Beam.Schema (Beamable, Columnar, PrimaryKey, Table (primaryKey))
import GHC.Generics (Generic)

data AccountT f = AccountT { _id         :: Columnar f Int32
                           , _email      :: Columnar f Text
                           , _password   :: Columnar f Text
                           , _active     :: Columnar f Bool
                           , _guid       :: Columnar f UUID
                           , _created_at :: Columnar f UTCTime
                           } deriving (Beamable, Generic)

type Account = AccountT Identity
type AccountId = PrimaryKey AccountT Identity

deriving instance Eq Account
deriving instance Show Account

instance Table AccountT where
  data PrimaryKey AccountT f = AccountId (Columnar f Int32)
    deriving (Beamable, Generic)
  primaryKey = AccountId . _id
