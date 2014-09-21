{-# LANGUAGE OverloadedStrings, ParallelListComp #-}
module FillText where

import           Control.Applicative
import           Control.Monad

import qualified Data.Text as T
import           Data.Text (Text)

import           Graphics.Blank

import           System.Random

benchmark :: DeviceContext -> IO ()
benchmark = draw numWords

summary :: String
summary = "FillText"

numWords :: Int
numWords = 50

-- Randomly creates a four-letter, lowercase word
randomWord :: IO Text
randomWord = fmap T.pack . replicateM 4 $ randomRIO ('a', 'z')

showText :: (Double, Double) -> Text -> Canvas ()
showText (x, y) txt = do
    fillStyle("black");
    font("10pt Calibri");
    fillText(txt, x, y);

draw :: Int -> DeviceContext -> IO ()
draw nWords ctx = do
    xs <- replicateM nWords randomIO
    ys <- replicateM nWords randomIO
    ws <- cycle <$> replicateM nWords randomWord
    send ctx $ sequence_ [ showText (x * width ctx, y * height ctx) word
                             | x <- xs
                             | y <- ys
                             | word <- ws
                             ]
