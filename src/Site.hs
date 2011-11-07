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
import qualified Text.JSON as JSON
import           Data.List(find)

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
        id <- generateId extractedValues
        storeValues id extractedValues
        return $ includeId id reply
    storeValues id values = do
        let filename = id ++ ".values"
        let asJson = JSON.encode $ JSON.toJSObject values
        putStrLn $ id ++ " -- Received values : " ++ asJson
        writeFile filename asJson
    includeId id = sed (const id) "\\{id\\}" 
    generateId values = case find (\(key, _) -> key == "id") values of
        Nothing      ->  uuid >>= return . show
        Just (_, id) ->  return id

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
