module TemplateMatch where

import Text.Regex.XMLSchema.String(match, sed, matchSubex)
import RegexEscape

templateMatch :: String -> String -> Bool
templateMatch template input = match (toRegex template) input
  where toRegex = sed (const ".*") "\\\\\\*" . escape

templateExtract :: String -> String -> [(String, String)]
templateExtract template input = matchSubex (toExtractRegex template) input

toExtractRegex = sed (\variable -> "(" ++ variable ++ ".*)") "\\{[^\\}]+\\}" . escapeSome "[]\\^$.|?*+()"
