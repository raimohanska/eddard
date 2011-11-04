module XmlMatch where

import TemplateMatch(templateMatch, templateExtract)
import Text.Regex.XMLSchema.String(match, sed)
import Data.List(find)

xmlMatch :: String -> String -> Bool
xmlMatch template input = templateMatch (clean template) (clean input)

xmlExtract :: String -> String -> [(String, String)]
xmlExtract template input = templateExtract (clean template) (clean input)

xmlExtractWithConfig :: [(String, String)] -> String -> Maybe String
xmlExtractWithConfig conf input = firstMatch >>= return . snd 
  where firstMatch = find (\(t, r) -> not $ null $ xmlExtract t input) conf 

clean = sed (const "><") ">\\s*<" . trim
trim = dropWhile whitespace . reverse . dropWhile whitespace . reverse

whitespace c = match "\\s" [c]
