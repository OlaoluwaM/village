-- To setup the configuration & setting for running the Application

module Village.Configuration (Environment (..), loadAppConfig, AppConfig (..), AppCtx (..)) where

import Configuration.Dotenv qualified as Dotenv
import Env qualified

import Control.Monad ((<=<))
import Data.Char (toLower)
import Database.Persist.Postgresql (ConnectionString)

data AppConfig = AppConfig
    { dbConnStr :: ConnectionString
    , port :: Int
    , dbConnPoolSize :: Int
    , appCtx :: AppCtx
    }

newtype AppCtx = AppCtx
    { env :: Environment
    }

data Environment = DEV | PROD | TEST
    deriving stock (Eq, Show)

loadAppConfig :: IO AppConfig
loadAppConfig = do
    environment <- Env.parse (Env.header "Village API ENV") $ Env.var (Env.eitherReader @Env.Error parseEnvVar) "ENV" (Env.def DEV)

    -- env vars in .env are the vars our application needs to run. These are the prod env vars. Everything prod related is required and must be defined within it
    -- dev and test should provide appropriate mock/default values for each of these. We can have the `.env` file service both dev and prod environments because we can just modify the env vars depending on the environment we're running in. Swap in values for prod at deploy time
    -- Ensure that everything listed in .env.example is defined in .env and .env.test
    let dotenvConfig = Dotenv.defaultConfig{Dotenv.configExamplePath = [".env.example"]}

    case environment of
        TEST -> Dotenv.loadFile dotenvConfig{Dotenv.configPath = [".env.test"]}
        -- We list .env.dev here so we don't have to define, in the code, additional env vars that aren't relevant to prod.
        -- With this approach, all those can just go into .env.dev
        DEV -> Dotenv.loadFile dotenvConfig{Dotenv.configPath = [".env", ".env.dev"]}
        -- All prod env vars should be in .env DEV should have defaults for all of them
        PROD -> Dotenv.loadFile dotenvConfig

    Env.parse (Env.header "Village API") $
        do
            AppConfig <$> Env.var (Env.str <=< Env.nonempty) "DATABASE_URL" (Env.help "Database connection url")
            <*> Env.var Env.auto "PORT" (Env.def 8080 <> Env.help "Server port")
            <*> Env.var Env.auto "DATABASE_CONNECTION_POOL_SIZE" (Env.def 3 <> Env.help "Database connection pool size" <> Env.helpDef show)
            <*> pure (AppCtx environment)

parseEnvVar :: String -> Either String Environment
parseEnvVar str =
    let normalizedStr = map toLower str
     in case normalizedStr of
            "dev" -> Right DEV
            "prod" -> Right PROD
            "test" -> Right TEST
            "testing" -> Right TEST
            "production" -> Right PROD
            "development" -> Right DEV
            _ -> Left $ "Invalid environment option: " <> normalizedStr
