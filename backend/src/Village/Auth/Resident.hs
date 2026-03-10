{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE UndecidableInstances #-}

{-# OPTIONS_GHC -Wno-missing-export-lists #-}

module Village.Auth.Resident where

import Data.Text (Text)
import Data.Time (UTCTime)
import Database.Persist.TH

mkPersist
    sqlSettings
    [persistLowerCase|
Resident
    username Text
    created_at UTCTime
    deriving Show
|]
