module FileConfig where

import System.Directory
import Text.Regex.XMLSchema.String
import Control.Monad

readConfig = liftM pairs . getDirectoryContents
templateFiles = grep ".*template.*"
replyFile = sed (const "reply") "template"
fileNamePairs = map (\t -> (t, replyFile t)) . templateFiles
pairs = sequence . map (\(t, r) -> liftM2 (,) (readFile t) (readFile r)) . fileNamePairs
