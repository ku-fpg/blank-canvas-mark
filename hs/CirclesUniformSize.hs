--{-# LANGUAGE ApplicativeDo     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ParallelListComp  #-}
module CirclesUniformSize (benchmark, summary) where

import           Control.Monad  hiding (sequence_)
import           Data.Text      hiding (count)
import           Graphics.Blank
import           Utils

benchmark :: CanvasBenchmark
benchmark ctx = do
    xs <- replicateM numCircles $ randomXCoord ctx
    ys <- replicateM numCircles $ randomYCoord ctx
    send' ctx $ sequence_ [ showBall (x, y) col
                             | x <- xs
                             | y <- ys
                             | col <- cycle ["red","blue","green"]
                             ]

summary :: String
summary = "CirclesUniformSize"

numCircles :: Int
numCircles = 1000 * 1

showBall :: Point -> Text -> Canvas ()
showBall (x, y) col = do
    beginPath();
    fillStyle(col);
    arc(x, y, 25, 0, pi*2, False);
    closePath();
    fill();
