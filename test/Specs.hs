module Specs where
import RegexEscapeSpec
import TemplateMatchSpec
import XmlMatchSpec
import FunctionalSpec

import Test.Hspec

main = hspec (regexEscapeSpecs ++ templateMatchSpecs ++ xmlMatchSpecs ++ functionalSpecs)
