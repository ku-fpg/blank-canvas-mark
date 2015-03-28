{-# LANGUAGE CPP, OverloadedStrings #-}
module Bezier (benchmark, summary) where

#if !(MIN_VERSION_base(4,8,0))
import Control.Applicative
#endif
import Control.Monad

import Graphics.Blank

import Utils

benchmark :: CanvasBenchmark
benchmark ctx = do
    bzs <- replicateM numBezier $ replicateM numCurves $ (,,,,,)
                      <$> randomXCoord ctx
                      <*> randomYCoord ctx
                      <*> randomXCoord ctx
                      <*> randomYCoord ctx
                      <*> randomXCoord ctx
                      <*> randomYCoord ctx
    send' ctx $ forM_ bzs drawCloud 

summary :: String
summary = "Bezier"

numBezier :: Int
numBezier = 100

numCurves :: Int
numCurves = 5

type Bezier = (Double, Double, Double, Double, Double, Double)

drawCloud :: [Bezier] -> Canvas ()
drawCloud bzs = do
    beginPath();
    let (_, _, _, _, x, y) = last bzs
    moveTo(x, y);
    forM_ bzs bezierCurveTo
    
    closePath();
    lineWidth(5);
    fillStyle("#8ED6FF");
    fill();
    strokeStyle("blue");
    stroke();
