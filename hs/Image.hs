{-# LANGUAGE OverloadedStrings #-}
module Image where

import qualified Data.Text as T
import           Data.Text (Text)

import           Graphics.Blank

import           System.FilePath
import           System.Random

import           Utils

benchmark :: CanvasBenchmark
benchmark ctx = do
    x     <- randomXCoord ctx
    y     <- randomYCoord ctx
    w     <- randomXCoord ctx
    h     <- randomYCoord ctx
    theta <- randomRIO (0, 2*pi)
    send ctx $ drawTheImage (x,y,w,h) theta

summary :: String
summary = "Image"

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