--{-# LANGUAGE ApplicativeDo     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ParallelListComp  #-}
module ImageApplicative (benchmark, summary) where

import           Control.Monad

import           Data.Foldable   (sequenceA_)
import           Data.Text       (Text)
import qualified Data.Text       as T

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
    send' ctx $ do
       img <- newImage image
       sequenceA_ [ drawTheImage (x,y,w,h) theta img
                         | x     <- xs
                         | y     <- ys
                         | w     <- ws
                         | h     <- hs
                         | theta <- thetas
                         ]

summary :: String
summary = "ImageMarkApplicative"

numImages :: Int
numImages = 1000

image :: Text
image = T.pack $ "/images" </> "cc" <.> "gif"

type Angle = Double

drawTheImage :: Path -> Angle -> CanvasImage -> Canvas ()
drawTheImage (x,y,w,h) theta img = do
    beginPath();
    save();
    rotate(theta);
    drawImageSize(img, x - (w/2), y - (w/2), w, h);
    closePath();
    restore();
