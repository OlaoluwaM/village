module Village.Api (villageApi) where

import Data.Proxy (Proxy (..))

import Network.Wai qualified
import Servant (serve)
import Village.Ping.Handler (PingAPI, pingServer)

type VillageAPI = PingAPI

villageApi :: Network.Wai.Application
villageApi = serve (Proxy :: Proxy VillageAPI) pingServer
