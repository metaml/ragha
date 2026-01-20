module Db.Db where

import Database.Beam (Database, Generic, TableEntity)
import Db.Entity.Account (AccountT)
import Db.Entity.Journal (JournalT)

data RaghaDb f = RaghaDb { _account :: f (TableEntity AccountT)
                         , _journal :: f (TableEntity JournalT)
                         } deriving (Generic, Database be)
