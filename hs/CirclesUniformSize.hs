{-# LANGUAGE OverloadedStrings, ParallelListComp #-}
module CirclesUniformSize where

import Data.Text hiding (count)
import Graphics.Blank
import System.Random

circlesUniformSize :: DeviceContext -> IO ()
circlesUniformSize = draw numCircles

circlesUniformSizeSummary :: String
circlesUniformSizeSummary = show numCircles ++ " circles (uniform size)"

numCircles :: Int
numCircles = 1000

showBall :: (Float,Float) -> Text -> Canvas ()
showBall (x, y) col = do
    beginPath();
    fillStyle(col);
    arc(x, y, 10, 0, pi*2, False);
    closePath();
    fill();

draw :: Int -> DeviceContext -> IO ()
draw count context = do
    xs <- sequence [ randomIO | _ <- [1..count]]
    ys <- sequence [ randomIO | _ <- [1..count]]
    send context $ sequence_ [ showBall (x * width context,y * height context) col
                             | x <- xs
                             | y <- ys 
                             | col <- cycle ["red","blue","green"]
                             ]