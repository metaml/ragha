module Db.Query.Journal where

import Data.Text (Text)
import Data.Time (LocalTime)
import Data.UUID (UUID)
import Database.Beam ( (<.)
                     , all_
                     , currentTimestamp_
                     , default_
                     , desc_
                     , filter_
                     , insertExpressions
                     , limit_
                     , orderBy_
                     , runInsert
                     , runSelectReturningList
                     , select
                     , val_
                     )
import Database.Beam.Postgres (runBeamPostgres)
import Database.PostgreSQL.Simple (Connection)
import Db.Db
import Db.Entity.Journal
import qualified Database.Beam as Db

type Entry = Text
type Email = Text
type Rows  = Integer

insert :: Connection -> UUID -> Entry -> IO ()
insert c guid entry = do
  let q = Db.insert raghaDb.journal
          $ insertExpressions [ Journal default_
                                        (val_ guid)
                                        (val_ entry)
                                        currentTimestamp_
                              ]
  runBeamPostgres c $ runInsert q

list :: Connection -> LocalTime -> Rows -> IO [Journal]
list c t r = do
  let query = select $ limit_ r
                     $ orderBy_ (desc_ . _created_at)
                     $ filter_ (\j -> j._created_at <. val_ t)
                               (all_ raghaDb.journal)
  runBeamPostgres c $ runSelectReturningList query
