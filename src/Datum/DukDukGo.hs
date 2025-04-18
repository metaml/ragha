module Datum.DukDukGo where

import Data.Aeson (FromJSON, Object, ToJSON, encode, eitherDecode)
import Data.Proxy (Proxy(..))
import Data.Text (Text)
import Network.HTTP.Client (newManager)
import Network.HTTP.Client.TLS (tlsManagerSettings)
import Network.HTTP.Media ((//))
import Servant.Client ( BaseUrl(..), ClientM, Scheme(..)
                      , client, mkClientEnv, runClientM
                      )
import Servant.Client.Core (ClientError)
import Servant.API ((:>), Accept(..), Get, JSON, MimeUnrender, Post, QueryParam)
import Servant.API.ContentTypes (MimeRender(..), MimeUnrender(..))

-- api.duckduckgo.com's content-type="application/x-javascript"
data XJSON

instance Accept JSON => Accept XJSON where
  contentType _ = "application" // "x-javascript"

instance ToJSON a => MimeRender XJSON a where
  mimeRender _ = encode

instance FromJSON a => MimeUnrender XJSON a where
  mimeUnrender _ = eitherDecode

type Query = Text
type Format = Text
type Body = Object
type Pretty = Int
type NoHtml = Int
type SkipDisam = Int
type Error = Text

-- https://api.duckduckgo.com/?q=haskell&format=json&pretty=1&no_html=1&skip_disambig=1
type DkDkGoApi = QueryParam "q" Query
                 :> QueryParam "format" Format
                 :> QueryParam "pretty" Int
                 :> QueryParam "no_html" Int
                 :> QueryParam "skip_disambig" Int
                 :> Get '[XJSON] Body

dkdkGoApi :: Proxy DkDkGoApi
dkdkGoApi = Proxy

search :: Maybe Query -> Maybe Format -> Maybe Pretty -> Maybe NoHtml -> Maybe SkipDisam -> ClientM Body
search = client dkdkGoApi

query :: Query -> IO (Either ClientError Body)
query q = do
  let url  = "api.duckduckgo.com"
      port = 443
      baseUrl = BaseUrl Https url port ""
  manager <- newManager tlsManagerSettings
  runClientM (search (Just q) (Just "json") (Just 0) (Just 1) (Just 1)) (mkClientEnv manager baseUrl)
