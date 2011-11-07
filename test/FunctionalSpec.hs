module FunctionalSpec where

import Test.HUnit
import qualified Main as Eddard
import Control.Concurrent(forkIO, threadDelay, killThread)
import Curl
import Text.Regex.XMLSchema.String(match)
import XmlMatch(clean)
import Control.Exception(finally)

functionalTests = TestList [
  postTest "Login request" "/" "<login><username>juha</username><password>secret</password></login>" "<login-reply>.*</login-reply>",
  postTest "Non-matching request" "/" "lol" "error : no match"
  ]

rootUrl = "localhost:8000" 

postTest :: String -> String -> String -> String -> Test
postTest desc path request pattern = TestLabel desc $ TestCase $ withTestServer $ do
    putStrLn $ "Sending : " ++ request
    reply <- curlPostGetString (rootUrl ++ path) request
    putStrLn $ "Got reply : " ++ reply
    assertBool desc (match pattern (clean reply))

withTestServer :: IO () -> IO ()
withTestServer task = do
    serverThread <- forkIO $ Eddard.main
    threadDelay $ 1000*1000
    finally task (killThread serverThread)
 
