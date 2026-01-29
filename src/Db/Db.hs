module Db.Db where

import Data.Text (unpack)
import Database.Beam (Database, Generic, TableEntity)
import Database.Beam.Postgres (Postgres)
import Database.Beam.Schema.Tables (DatabaseSettings, defaultDbSettings)
import Database.PostgreSQL.Simple (ConnectInfo(..), Connection, connect)
import Db.Entity.Account (AccountT)
import Db.Entity.Journal (JournalT)
import Etc.Context (dbDatabase, dbHost, dbUser, dbPassword)

data RaghaDb f = RaghaDb { account :: f (TableEntity AccountT)
                         , journal :: f (TableEntity JournalT)
                         } deriving (Generic, Database be)

raghaDb :: DatabaseSettings Postgres RaghaDb
raghaDb = defaultDbSettings

connection :: IO Connection
connection = connectionInfo >>= connect

connectionInfo :: IO ConnectInfo
connectionInfo = do
  database <- dbDatabase
  host     <- dbHost
  password <- dbPassword
  user     <- dbUser
  pure $ ConnectInfo { connectDatabase = unpack database
                     , connectHost     = unpack host
                     , connectPort     = 5432
                     , connectUser     = unpack user
                     , connectPassword = unpack password
                     }
