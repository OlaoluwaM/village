module Village.Ping.Handler (PingApi, pingHandler) where

import Servant

import Effectful qualified as Eff
import Effectful.Error.Static qualified as Eff
import Effectful.Exception qualified as Eff
import Village.Effects.DB qualified as VEff
import Village.Effects.Log qualified as VEff

import Blammo.Logging (Message (..), (.=))
import Control.Exception (displayException)
import Data.Functor (($>))
import Data.Text (Text)
import Database.Esqueleto.Experimental (Single, rawSql)
import Effectful (Eff)

type PingEff es = (VEff.Log Eff.:> es, Eff.Error ServerError Eff.:> es, VEff.DB Eff.:> es)

type PingApi = RootApi :<|> ("ping" :> Get '[JSON] Text)
type RootApi = Get '[JSON] Text

pingHandler :: (PingEff es) => ServerT PingApi (Eff es)
pingHandler = ping :<|> ping

ping :: (PingEff es) => Eff es Text
ping = do
    let dbCheck = VEff.db (rawSql @(Single Int) "SELECT 1" []) $> "Ok"
    dbCheck
        `Eff.catchSync` ( \err -> do
                            VEff.logError $ "Error occurred while trying to reach the DB" :# ["Error" .= displayException err]
                            Eff.throwError $ err500{errBody = "Unable to connect to DB"}
                        )
