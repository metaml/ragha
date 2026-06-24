module Auth.Auth where

import Prelude hiding (lookup)
import Data.Aeson (FromJSON, ToJSON)
import Data.ByteString (ByteString)
import Data.Map (Map, fromList, lookup)
import Data.Text (Text)
import Data.UUID (UUID)
import Data.UUID.V4 (nextRandom)
import GHC.Generics (Generic)
import Servant.Auth
import Servant.Auth.Server ( AuthResult(..), BasicAuthCfg, BasicAuthData(..), FromBasicAuthData, FromJWT, ToJWT
                           , fromBasicAuthData
                           )

data User = User { guid :: UUID
                 , email :: Text
                 } deriving (Eq, Generic, Show, ToJSON, FromJSON, ToJWT, FromJWT)

type Login      = ByteString
type Password   = ByteString
type DB         = Map (Login, Password) User
type Connection = DB
type Pool a     = a

-- @todo: replace with DB connection pool
initConnPool :: IO (Pool Connection)
initConnPool = do
  u0 <- nextRandom
  u1 <- nextRandom
  pure $ fromList [ (("user0", "pass0"), User u0 "apple@pi.com")
                  , (("user1", "pass1"), User u1 "cherry@pi.com")
                  ]

authenticate :: Pool Connection -> BasicAuthData -> IO (AuthResult User)
authenticate connPool (BasicAuthData login password) = pure $
  maybe Indefinite Authenticated $ lookup (login, password) connPool

type instance BasicAuthCfg = BasicAuthData -> IO (AuthResult User)

instance FromBasicAuthData User where
  fromBasicAuthData authData authCheckFunction = authCheckFunction authData
