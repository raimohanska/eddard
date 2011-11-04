module XmlMatchSpec where

import Test.Hspec
import XmlMatch

xmlMatchSpecs = describe "Xml match" [
  it "matches template against self" (xmlMatch "<xml/>" "<xml/>"),
  it "matches with wildcard" (xmlMatch "<xml>*</xml>" "<xml>lol</xml>"),
  it "matches with different white space" (xmlMatch "\n<xml><field>*</field></xml>\n" "<xml>\n \t<field>lol</field>\r</xml>"),
  it "rejects non-match" (xmlMatch "<xml>" "<xlm>" == False),
  it "extracts data from wildcards" (xmlExtract "<xml>{name}</xml>" " <xml>jack</xml>\t" == [("name", "jack")]),
  it "extracts more data from wildcards" (
    xmlExtract 
      "<login><username>{username}</username><password>{password}</password></login>" 
      "<login><username>u</username><password>p</password></login>" 
      == [("username", "u"), ("password", "p")]),
  it "extracts empty result for non-match" (xmlExtract "<xml>{name}</xml>" "<xml>jack</xlm>" == [])
  ]
