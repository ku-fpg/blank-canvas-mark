{-# LANGUAGE OverloadedStrings, ParallelListComp #-}
module Image (benchmark, summary) where

import           Control.Monad

import qualified Data.Text as T
import           Data.Text (Text)

import           Graphics.Blank

import           System.FilePath
import           System.Random

import           Utils

benchmark :: CanvasBenchmark
benchmark ctx = do
    xs     <- replicateM numImages $ randomXCoord ctx
    ys     <- replicateM numImages $ randomYCoord ctx
    ws     <- replicateM numImages $ randomXCoord ctx
    hs     <- replicateM numImages $ randomYCoord ctx
    thetas <- replicateM numImages $ randomRIO (0, 2*pi)
    send ctx $ sequence_ [ drawTheImage (x,y,w,h) theta
                         | x     <- xs
                         | y     <- ys
                         | w     <- ws
                         | h     <- hs
                         | theta <- thetas
                         ]

summary :: String
summary = "Image"

numImages :: Int
numImages = 10

image :: Text
image = T.pack $ "images" </> "cc" <.> "gif"

type Angle = Double

drawTheImage :: Path -> Angle -> Canvas ()
drawTheImage (x,y,w,h) theta = do
    beginPath();
    save();
    rotate(theta);
    img <- newImage image
    drawImageSize(img, x, y, w, h);
    closePath();
    restore();