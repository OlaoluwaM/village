module Village.Effects.Log where

import Blammo.Logging qualified as Blammo
import Effectful.TH qualified as Eff

import Blammo.Logging.Simple qualified as Blammo
import Effectful (Eff, Effect, IOE, MonadIO (liftIO), (:>))
import Effectful.Dispatch.Dynamic qualified as Eff
import Effectful.Dispatch.Static qualified as Eff

data Log :: Effect where
    LogInfo :: Blammo.Message -> Log m ()
    LogDebug :: Blammo.Message -> Log m ()
    LogWarn :: Blammo.Message -> Log m ()
    LogError :: Blammo.Message -> Log m ()

Eff.makeEffect ''Log

runLog :: (IOE :> es) => Blammo.Logger -> Eff (Log ': es) a -> Eff es a
runLog logger = Eff.interpret_ $ \case
    LogInfo msg -> Blammo.runLoggerLoggingT logger $ Blammo.logInfo msg
    LogDebug msg -> Blammo.runLoggerLoggingT logger $ Blammo.logDebug msg
    LogWarn msg -> Blammo.runLoggerLoggingT logger $ Blammo.logWarn msg
    LogError msg -> Blammo.runLoggerLoggingT logger $ Blammo.logError msg
