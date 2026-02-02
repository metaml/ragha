module Api.Api where

type Api = account :> Account
           :<|> "journal" :> Journal
