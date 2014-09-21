{-# LANGUAGE OverloadedStrings, ParallelListComp #-}
module CirclesRandomSize (benchmark, summary) where

import Control.Monad
import Data.Text hiding (count)
import Graphics.Blank
import System.Random

benchmark :: DeviceContext -> IO ()
benchmark = draw numCircles radiusMin radiusMax

summary :: String
summary = "circles_random_size"

numCircles :: Int
numCircles = 1000

radiusMin, radiusMax :: Double
radiusMin  = 5
radiusMax  = 50

showBall :: (Double, Double) -> Double -> Text -> Canvas ()
showBall (x, y) r col = do
    beginPath();
    fillStyle(col);
    arc(x, y, r, 0, pi*2, False);
    closePath();
    fill();

draw :: Int -> Double -> Double -> DeviceContext -> IO ()
draw count rMin rMax context = do
    xs <- replicateM count randomIO
    ys <- replicateM count randomIO
    rs <- replicateM count $ randomRIO (rMin, rMax)
    send context $ sequence_ [ showBall (x * width context,y * height context) r col
                             | x <- xs
                             | y <- ys
                             | r <- rs
                             | col <- cycle ["red","blue","green"]
                             ] 
