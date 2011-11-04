module FileConfig(readConfig) where

import System.Directory
import Text.Regex.XMLSchema.String
import Control.Monad

readConfig :: FilePath -> IO (IO [(String, String)])
readConfig = liftM pairs . getDirectoryContents
  where pairs = sequence . map (\t -> liftM2 (,) (readFile t) (readFile (replyFile t))) . templateFiles
        templateFiles = grep ".*template.*"
        replyFile = sed (const "reply") "template"
