{-# LANGUAGE OverloadedStrings, ParallelListComp #-}
module FillText where

import           Control.Applicative
import           Control.Monad

import qualified Data.Text as T
import           Data.Text (Text)

import           Graphics.Blank

import           System.Random

import           Utils

benchmark :: DeviceContext -> IO ()
benchmark ctx = do
    xs <- replicateM numWords $ randomXCoord ctx
    ys <- replicateM numWords $ randomYCoord ctx
    ws <- cycle <$> replicateM numWords randomWord
    send ctx $ sequence_ [ showText (x, y) word
                             | x <- xs
                             | y <- ys
                             | word <- ws
                             ]

summary :: String
summary = "FillText"

numWords :: Int
numWords = 50

-- Randomly creates a four-letter, lowercase word
randomWord :: IO Text
randomWord = fmap T.pack . replicateM 4 $ randomRIO ('a', 'z')

showText :: Point -> Text -> Canvas ()
showText (x, y) txt = do
    fillStyle("black");
    font("10pt Calibri");
    fillText(txt, x, y);
