module Village.Effects.DB (DB, db, runDB) where

import Effectful qualified as Eff
import Effectful.Dispatch.Static qualified as Eff

import Blammo.Logging (Logger)
import Blammo.Logging.Setup (LoggingT, runLoggerLoggingT)
import Control.Monad.Trans.Resource (ResourceT, runResourceT)
import Database.Esqueleto.Experimental (ConnectionPool, SqlPersistT, runSqlPool)
import Effectful (Eff, Effect, IOE, (:>))

-- LoggingT enables persistent to emit executed SQL statements to our logger automatically.
-- ResourceT ensures the used connection is checked back into the connection pool when the query finishes, even on exceptions.
type Query a = SqlPersistT (LoggingT (ResourceT IO)) a

{-
    Static dispatch is a final encoding. Interpretation is baked directly into the definition of the effect rather than
    pattern matched in a handler. Since our DB effect only has one meaningful interpretation (run against a real DB),
    this is the right fit. No constructors, No need for different interpreters
-}
data DB :: Effect

type instance Eff.DispatchOf DB = Eff.Static Eff.WithSideEffects

data instance Eff.StaticRep DB = DB ConnectionPool Logger

db :: (DB :> es) => Query a -> Eff es a
db query = do
    DB connPool logger <- Eff.getStaticRep
    Eff.unsafeEff_ . runResourceT . runLoggerLoggingT logger $ runSqlPool query connPool

runDB :: (IOE :> es) => Logger -> ConnectionPool -> Eff (DB : es) b -> Eff es b
runDB logger pool = Eff.evalStaticRep (DB pool logger)
