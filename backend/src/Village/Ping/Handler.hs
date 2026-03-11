module Village.Ping.Handler (PingApi, pingHandler) where

import Database.Esqueleto.Experimental
import Servant

import Effectful qualified as Eff
import Effectful.Error.Static qualified as Eff
import Effectful.Exception qualified as Eff

import Control.Exception (displayException)
import Data.Functor (($>))
import Data.String (fromString)
import Data.Text (Text)
import Effectful (Eff)
import Village.Effects.DB (DB, db)

type PingEff es = (Eff.IOE Eff.:> es, Eff.Error ServerError Eff.:> es, DB Eff.:> es)

type PingApi = RootApi :<|> ("ping" :> Get '[JSON] Text)
type RootApi = Get '[JSON] Text

pingHandler :: (PingEff es) => ServerT PingApi (Eff es)
pingHandler = ping :<|> ping

ping :: (PingEff es) => Eff es Text
ping = do
    let dbCheck = db (rawSql @(Single Int) "SELECT 1" []) $> "Ok"
    -- TODO We probably should have a less transparent error for prod
    dbCheck `Eff.catchSync` (\err -> Eff.throwError $ err500{errBody = "Error " <> fromString (displayException err)})
