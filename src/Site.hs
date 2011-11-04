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

------------------------------------------------------------------------------
-- | Renders the front page of the sample site.
--
-- The 'ifTop' is required to limit this to the top of a route.
-- Otherwise, the way the route table is currently set up, this action
-- would be given every request.
match :: Handler App App ()
match = ifTop $ do
    reqBody <- liftM L8.unpack getRequestBody
    liftIO $ putStrLn $ "processing" ++ reqBody
    conf <- liftIO $ readConfig "." 
    writeLBS $ L8.pack $ serve conf reqBody
  where
    serve conf reqBody = case xmlExtractWithConfig conf reqBody of
      Nothing -> "error : no match"
      Just reply -> reply

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
