module XmlMatchSpec where

import Test.Hspec
import XmlMatch

xmlMatchSpecs = describe "Xml match" [
  it "matches template against self" (xmlMatch "<xml/>" "<xml/>"),
  it "matches with wildcard" (xmlMatch "<xml>*</xml>" "<xml>lol</xml>"),
  it "matches with different white space" (xmlMatch "\n<xml><field>*</field></xml>\n" "<xml>\n \t<field>lol</field>\r</xml>"),
  it "rejects non-match" (xmlMatch "<xml>" "<xlm>" == False),
  it "extracts data from wildcards" (xmlExtract "<xml>{name}</xml>" " <xml>jack</xml>\t" == [("name", "jack")]),
  it "extracts empty result for non-match" (xmlExtract "<xml>{name}</xml>" "<xml>jack</xlm>" == [])
  ]
