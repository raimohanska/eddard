module XmlMatch where

import TemplateMatch(templateMatch, templateExtract)
import Text.Regex.XMLSchema.String(match, sed)

xmlMatch :: String -> String -> Bool
xmlMatch template input = templateMatch (clean template) (clean input)

xmlExtract :: String -> String -> [(String, String)]
xmlExtract template input = templateExtract (clean template) (clean input)

clean = sed (const "><") ">\\s*<" . trim
trim = dropWhile whitespace . reverse . dropWhile whitespace . reverse

whitespace c = match "\\s" [c]
