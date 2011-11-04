{-# LANGUAGE OverloadedStrings #-}

module Site(app) where

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
import           Text.Regex.XMLSchema.String(sed)

eddard :: Handler App App ()
eddard = ifTop $ do
    reqBody <- liftM L8.unpack getRequestBody
    conf <- liftIO $ readConfig "."
    reply <- liftIO $ serve conf reqBody 
    writeLBS $ L8.pack $ reply 
  where
    serve conf reqBody = case xmlExtractWithConfig conf reqBody of
      Nothing -> return "error : no match"
      Just (reply, extractedValues) -> do
        id <- uuid >>= return . show
        storeValues id extractedValues
        return $ includeId id reply
    storeValues id values = do
        let filename = id ++ ".values"
        putStrLn $ id ++ " -- Received values : " ++ (show values)
        writeFile filename $ show values
    includeId id = sed (const id) "\\{id\\}" 

-----------------------------------------------------------------------------
-- | The application's routes.
routes :: [(ByteString, Handler App App ())]
routes = [ ("/",            eddard)
         , ("", serveDirectory "resources/static")
         ]

------------------------------------------------------------------------------
-- | The application initializer.
app :: SnapletInit App App
app = makeSnaplet "eddard" "Eddard Fake Web Service" Nothing $ do
    addRoutes routes
    return $ App
