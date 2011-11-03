module TemplateMatchSpec where

import Test.Hspec
import TemplateMatch(templateMatch, templateExtract)

templateMatchSpecs = describe "Template match" [
  it "matches template against self" (templateMatch "<xml/>" "<xml/>"),
  it "matches with wildcard" (templateMatch "<xml>*</xml>" "<xml>lol</xml>"),
  it "extracts data from wildcards" (templateExtract "<xml>{name}</xml>" "<xml>jack</xml>" == [("name", "jack")])
  ]
