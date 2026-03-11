-- To put together the API

module Village.Api (ApiEff, Api, api, handler) where

import Data.Proxy (Proxy (..))
import Effectful (Eff, IOE)
import Effectful.Error.Static (Error)
import Effectful.Reader.Static (Reader)
import Servant (
    ServerError,
    ServerT,
 )
import Village.Configuration (AppCtx)
import Village.Effects.DB (DB)
import Village.Effects.Log (Log)
import Village.Ping.Handler (PingApi, pingHandler)

type ApiEff = Eff '[Log, Error ServerError, DB, Reader AppCtx, IOE]

type Api = PingApi

api :: Proxy Api
api = Proxy

handler :: ServerT Api ApiEff
handler = pingHandler
