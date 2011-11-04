{-# LANGUAGE OverloadedStrings #-}

{-|

This is where all the routes and handlers are defined for your site. The
'app' function is the initializer that combines everything together and
is exported by this module.

-}

module Site
  ( app
  ) where

import           Data.ByteString (ByteString)
import           Snap.Core
import           Snap.Snaplet
import           Snap.Util.FileServe
import           Control.Monad.Trans
import           Control.Monad
import           Application
import qualified Data.ByteString.Lazy.Char8 as L8
import           XmlMatch
import           FileConfig
import           System.UUID.V4 

match = ifTop $ do
    reqBody <- liftM L8.unpack getRequestBody
    conf <- liftIO $ readConfig "."
    reply <- liftIO $ serve conf reqBody 
    writeLBS $ L8.pack $ reply 
  where
    serve conf reqBody = case xmlExtractWithConfig conf reqBody of
      Nothing -> return "error : no match"
      Just (reply, extractedVars) -> do
        uuid <- uuid >>= return . show
        putStrLn $ uuid ++ " -- Received values : " ++ (show extractedVars)
        return reply

-----------------------------------------------------------------------------
-- | The application's routes.
routes :: [(ByteString, Handler App App ())]
routes = [ ("/",            match)
         , ("", serveDirectory "resources/static")
         ]

------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "app" "An snaplet example application." Nothing $ do
    addRoutes routes
    return $ App
