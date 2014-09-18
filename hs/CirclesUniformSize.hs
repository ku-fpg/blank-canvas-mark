{-# LANGUAGE OverloadedStrings, ParallelListComp #-}
module CirclesUniformSize (benchmark, summary) where

import Control.Monad
import Data.Text hiding (count)
import Graphics.Blank
import System.Random

benchmark :: DeviceContext -> IO ()
benchmark = draw numCircles

summary :: String
summary = "circles_uniform_size"

numCircles :: Int
numCircles = 1000

showBall :: (Float, Float) -> Text -> Canvas ()
showBall (x, y) col = do
    beginPath();
    fillStyle(col);
    arc(x, y, 10, 0, pi*2, False);
    closePath();
    fill();

draw :: Int -> DeviceContext -> IO ()
draw count context = do
    xs <- replicateM count randomIO
    ys <- replicateM count randomIO
    send context $ sequence_ [ showBall (x * width context,y * height context) col
                             | x <- xs
                             | y <- ys
                             | col <- cycle ["red","blue","green"]
                             ]