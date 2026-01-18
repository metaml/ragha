module Db.Db where

import Database.Beam (Database, Generic, TableEntity)
import Db.Entity.Account

data RaghaDb f = RaghaDb { _account :: f (TableEntity AccountT)
                         } deriving (Generic, Database be)
