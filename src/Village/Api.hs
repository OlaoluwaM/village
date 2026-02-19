module Village.Api (villageApi) where

import Data.Data (Proxy (..))

import Network.Wai qualified
import Servant (serve)
import Village.Endpoints.Ping.Handler (PingAPI, pingServer)

type VillageAPI = PingAPI

villageApi :: Network.Wai.Application
villageApi = serve (Proxy :: Proxy VillageAPI) pingServer
