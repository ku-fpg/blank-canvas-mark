{-# LANGUAGE OverloadedStrings, ParallelListComp #-}
module CirclesRandomSize (benchmark, summary) where

import Control.Monad
import Data.Text hiding (count)
import Graphics.Blank
import System.Random
import Utils

benchmark :: CanvasBenchmark
benchmark ctx = do
    xs <- replicateM numCircles $ randomXCoord ctx
    ys <- replicateM numCircles $ randomYCoord ctx
    rs <- replicateM numCircles $ randomRIO (radiusMin, radiusMax)
    send ctx $ sequence_ [ showBall (x, y) r col
                             | x <- xs
                             | y <- ys
                             | r <- rs
                             | col <- cycle ["red","blue","green"]
                             ] 

summary :: String
summary = "CirclesRandomSize"

numCircles :: Int
numCircles = 1000

radiusMin, radiusMax :: Double
radiusMin  = 5
radiusMax  = 50

showBall :: Point -> Double -> Text -> Canvas ()
showBall (x, y) r col = do
    beginPath();
    fillStyle(col);
    arc(x, y, r, 0, pi*2, False);
    closePath();
    fill();
