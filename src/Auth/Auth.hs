module Auth.Auth where

import Data.Aeson (FromJSON, ToJSON)
import Data.Text (Text)
import Data.UUID (UUID)
import GHC.Generics (Generic)
import Servant.Auth.Server (FromJWT, ToJWT)

data User = User { guid :: Text
                 , email :: UUID
                 } deriving (Eq, Generic, Show, ToJSON, FromJSON, ToJWT, FromJWT)
