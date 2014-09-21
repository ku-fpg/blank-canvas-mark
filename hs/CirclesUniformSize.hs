{-# LANGUAGE OverloadedStrings, ParallelListComp #-}
module CirclesUniformSize (benchmark, summary) where

import Control.Monad
import Data.Text hiding (count)
import Graphics.Blank
import Utils

benchmark :: DeviceContext -> IO ()
benchmark ctx = do
    xs <- replicateM numCircles $ randomXCoord ctx
    ys <- replicateM numCircles $ randomYCoord ctx
    send ctx $ sequence_ [ showBall (x, y) col
                             | x <- xs
                             | y <- ys
                             | col <- cycle ["red","blue","green"]
                             ]

summary :: String
summary = "CirclesUniformSize"

numCircles :: Int
numCircles = 1000

showBall :: Point -> Text -> Canvas ()
showBall (x, y) col = do
    beginPath();
    fillStyle(col);
    arc(x, y, 10, 0, pi*2, False);
    closePath();
    fill();