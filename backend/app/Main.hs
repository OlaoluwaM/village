module Main (main) where

import Network.Wai.Handler.Warp
import Network.Wai.Logger (withStdoutLogger)
import Village.Api (villageApi)

main :: IO ()
main = withStdoutLogger $ \apLogger -> do
    let settings = setPort 8080 $ setLogger apLogger defaultSettings
    putStrLn "Starting Village API" -- TODO: Replace with something more professional
    runSettings settings villageApi
