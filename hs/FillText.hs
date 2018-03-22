{-# LANGUAGE ApplicativeDo     #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
module FillText (benchmark, summary) where

import           Control.Monad.Compat

import           Data.Foldable        (for_)
import           Data.Text            (Text)
import qualified Data.Text            as T

import           Graphics.Blank

import           Prelude.Compat

import           System.Random

import           Utils

benchmark :: CanvasBenchmark
benchmark ctx = do
    xs <- replicateM numWords $ randomXCoord ctx
    ys <- replicateM numWords $ randomYCoord ctx
    ws <- cycle <$> replicateM numWords randomWord
    send' ctx $ for_ (zip3 xs ys ws)
                     (\x y word -> showText (x, y) word)

summary :: String
summary = "FillText"

numWords :: Int
numWords = 1000

-- Randomly creates a four-letter, lowercase word
randomWord :: IO Text
randomWord = fmap T.pack . replicateM 4 $ randomRIO ('a', 'z')

showText :: Point -> Text -> Canvas ()
showText (x, y) txt = do
    fillStyle("black");
    font("10pt Calibri");
    fillText(txt, x, y);
