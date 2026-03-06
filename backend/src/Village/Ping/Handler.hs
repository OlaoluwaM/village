module Village.Ping.Handler (PingAPI, pingServer) where

import Servant

type PingAPI = RootAPI :<|> ("ping" :> Get '[JSON] NoContent)
type RootAPI = Get '[JSON] NoContent

-- TODO: Extend this to also check DB status with a dummy query, something like SELECT 1
pingServer :: Server PingAPI
pingServer = ping :<|> ping

ping :: Handler NoContent
ping = pure NoContent
