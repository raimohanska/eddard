module FunctionalSpec where

import Test.HUnit
import qualified Main as Eddard
import Control.Concurrent(forkIO, threadDelay, killThread)
import Curl
import Network.Curl(curlGetString)
import Text.Regex.XMLSchema.String(match)
import XmlMatch(clean)
import Control.Exception(finally)
import RegexEscape(escape)

functionalTests = TestList [
  postTest "Login request" "/" "<login><username>juha</username><password>secret</password></login>" "<login-reply>.*</login-reply>",
  postTest "Query request" "/" "<query><id>1</id><query-string>testing</query-string></query>" "<query-results><id>1</id></query-results>",
  postTest "Non-matching request" "/" "lol" "error : no match",
  getTest "Extracted values" "/values/1" $ escape "{\"id\":\"1\",\"query\":\"testing\"}"
  ]

rootUrl = "localhost:8000" 

postTest :: String -> String -> String -> String -> Test
postTest desc path request pattern = 
  httpTest desc path (curlPostGetString (rootUrl ++ path) request) pattern

getTest desc path pattern = httpTest desc path (curlGetString (rootUrl ++ path) []  >>= return . snd) pattern

httpTest :: String -> String -> IO String -> String -> Test
httpTest desc path request pattern = TestLabel desc $ TestCase $ withTestServer $ do
    reply <- request
    putStrLn $ "Got reply : " ++ reply
    assertBool desc (match pattern (clean reply))

withTestServer :: IO () -> IO ()
withTestServer task = do
    serverThread <- forkIO $ Eddard.main
    threadDelay $ 1000*1000
    task `finally` (killThread serverThread)
 
