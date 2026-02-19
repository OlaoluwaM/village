module Main (main) where

import Network.Wai.Handler.Warp
import Network.Wai.Logger (withStdoutLogger)
import Text.Pretty.Simple (pPrint)
import Village.Api (villageApi)

main :: IO ()
main = withStdoutLogger $ \logger -> do
    let settings = setPort 8080 $ setLogger logger defaultSettings
    pPrint "Starting Village API" -- TODO: Replace with something more professional
    runSettings settings villageApi
