module Main where

import Data.ByteString.Char8 (pack)
import Data.List (intercalate)
import Database.PostgreSQL.Simple (connectPostgreSQL)
import Database.PostgreSQL.Simple.Migration (MigrationCommand(..), defaultOptions, runMigration)
import System.Environment (getEnv)

data DbCreds = DbCreds { db :: String
                       , user :: String
                       , password :: String
                       , host :: String
                       }

main :: IO ()
main = do
  initMig
  u <- dbUrl
  c <- connectPostgreSQL (pack u)
  r <- runMigration c defaultOptions $ MigrationDirectory "."
  print r

initMig :: IO ()
initMig = do
  u <- dbUrl
  c <- connectPostgreSQL (pack u)
  r <- runMigration c defaultOptions MigrationInitialization
  print r

dbUrl :: IO String
dbUrl = do
  c <- dbCreds
  pure $ intercalate " " [ "host=" <> c.host
                         , "dbname=" <> c.db
                         , "user=" <> c.user
                         , "password=" <> c.password
                         ]

dbCreds :: IO DbCreds
dbCreds = do
  user'     <- getEnv "PGUSER"
  password' <- getEnv "PGPASSWORD"
  host'     <- getEnv "PGHOST"
  pure $ DbCreds user' user' password' host'
