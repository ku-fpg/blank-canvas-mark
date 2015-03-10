{-# LANGUAGE OverloadedStrings, ParallelListComp #-}
module MeasureText (benchmark, summary) where

import           Control.Monad

import qualified Data.Text as T
import           Data.Text (Text)

import           Graphics.Blank

import           System.Random

import           Utils

benchmark :: CanvasBenchmark
benchmark ctx = do
    ws <- replicateM numWords randomWord
    wds <- send ctx $ do
        fillStyle("black")
	font("10pt Calibri")
	sequence [ measureText word
                 | word <- ws
                 ]
    x <- randomXCoord ctx
    y <- randomYCoord ctx

    send' ctx $ do
       fillStyle("black");
       font("10pt Calibri");
       fillText(T.pack $ show $ sum [ v | TextMetrics v <- wds ], x, y);
    return ()

summary :: String
summary = "MeasureText"

numWords :: Int
numWords = 100

-- Randomly creates a four-letter, lowercase word
randomWord :: IO Text
randomWord = fmap T.pack . replicateM 4 $ randomRIO ('a', 'z')

