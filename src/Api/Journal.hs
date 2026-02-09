module Api.Journal where

import Data.ByteString
import Data.Text (Text)
import Servant.Server ()

newtype Token = Token ByteString

newtype Journal = Journal { entry :: Text }
  deriving (Eq, Show)

-- type JournalApi = Header "Authorization" Token :>
--                   ( "append" :>

-- journalServer :: Server JournalApi
-- journalServer = undefined
