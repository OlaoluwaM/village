-- To massage our Api definition into an application we can execute
{-# LANGUAGE ScopedTypeVariables #-}

module Village.App (runApp) where

import Village.Api
import Village.Configuration

import Blammo.Logging (Logger, logInfo, (.=))
import Blammo.Logging.Setup (newLoggerEnv, runSimpleLoggingT)
import Control.Monad.Trans.Class (lift)
import Control.Monad.Trans.Except (ExceptT (..))
import Data.Text (Text)
import Database.Persist.Postgresql (ConnectionPool, withPostgresqlPool)
import Effectful (runEff)
import Effectful.Error.Static (runErrorNoCallStack)
import Effectful.Reader.Static (runReader)
import Network.Wai (Application)
import Network.Wai.Handler.Warp (
    defaultSettings,
    runSettings,
    setPort,
 )
import Network.Wai.Middleware.Logging (addThreadContext, requestLogger)
import Servant (
    Handler (Handler),
    hoistServer,
    serve,
 )
import Village.Effects.DB (runDB)

data Settings = Settings
    { dbConnPool :: ConnectionPool
    , logger :: Logger
    , appCtx :: AppCtx
    }

runApp :: IO ()
runApp = do
    AppConfig{port, dbConnStr, dbConnPoolSize, appCtx} <- loadAppConfig
    logger <- newLoggerEnv

    runSimpleLoggingT . withPostgresqlPool dbConnStr dbConnPoolSize $ \pool -> do
        let settings = setPort port defaultSettings
        logInfo "Starting Village API"
        let middleware = addThreadContext ["app" .= ("village-api" :: Text)] . requestLogger logger
        let appSettings = Settings pool logger appCtx
        lift $ runSettings settings . middleware $ mkApi appSettings

mkApi :: Settings -> Network.Wai.Application
mkApi settings = serve api $ hoistServer api (effToHandler settings) handler

effToHandler :: forall a. Settings -> ApiEff a -> Handler a
effToHandler Settings{dbConnPool, logger, appCtx} = Handler . ExceptT . runEff . runReader appCtx . runDB logger dbConnPool . runErrorNoCallStack
