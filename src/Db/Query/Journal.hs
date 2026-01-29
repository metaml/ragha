module Db.Query.Journal where

import Data.Text
import Database.Beam ( currentTimestamp_, default_, val_
                     , runInsert, insert, insertExpressions
                     )
import Database.Beam.Postgres (runBeamPostgres)
import Database.PostgreSQL.Simple (Connection)
import Db.Db
import Db.Entity.Journal

type Entry = Text
type Email = Text

append :: Connection -> Entry -> Email -> IO ()
append c entry email = do
  let query = insert (journal raghaDb)
              $ insertExpressions [ Journal default_
                                            (val_ entry)
                                            (val_ email)
                                            currentTimestamp_
                                  ]
  runBeamPostgres c $ runInsert query
  pure ()
