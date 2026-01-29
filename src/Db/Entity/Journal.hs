module Db.Entity.Journal where

import Data.Int (Int32)
import Data.Text (Text)
import Data.Time (LocalTime)
import Database.Beam (Identity)
import Database.Beam.Schema (Beamable, Columnar, PrimaryKey, Table (primaryKey))
import GHC.Generics (Generic)

data JournalT f = Journal { _id         :: Columnar f Int32
                          , _entry      :: Columnar f Text
                          , _email      :: Columnar f Text
                          , _created_at :: Columnar f LocalTime
                          } deriving (Beamable, Generic)


type Journal = JournalT Identity
type JournalId = PrimaryKey JournalT Identity

deriving instance Eq Journal
deriving instance Show Journal

instance Table JournalT where
  data PrimaryKey JournalT f = JournalId (Columnar f Int32)
    deriving (Beamable, Generic)
  primaryKey = JournalId . _id
