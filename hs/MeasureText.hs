{-# LANGUAGE ApplicativeDo     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ParallelListComp  #-}
module MeasureText (benchmark, summary) where

import           Control.Monad

import           Data.Text      (Text)
import qualified Data.Text      as T

import           Graphics.Blank

import           System.Random

import           Utils

benchmark :: CanvasBenchmark
benchmark ctx = do
    ws <- replicateM numWords randomWord
    wds <- send' ctx $ do
        fillStyle("black")
        font("10pt Calibri")
      --  for ws measureText
        sequenceA [ measureText word
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
numWords = 1000

-- Randomly creates a four-letter, lowercase word
randomWord :: IO Text
randomWord = do
--  sz <- randomRIO (1,10)
  fmap T.pack . replicateM 10 $ randomRIO ('a', 'z')
