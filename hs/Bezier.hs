{-# LANGUAGE OverloadedStrings #-}
module Bezier (benchmark, summary) where

import Control.Applicative
import Control.Monad

import Graphics.Blank

import Utils

benchmark :: CanvasBenchmark
benchmark ctx = do
    bzs <- replicateM numCurves $ (,,,,,)
                      <$> randomXCoord ctx
                      <*> randomYCoord ctx
                      <*> randomXCoord ctx
                      <*> randomYCoord ctx
                      <*> randomXCoord ctx
                      <*> randomYCoord ctx
    send ctx $ drawCloud bzs

summary :: String
summary = "Bezier"

numCurves :: Int
numCurves = 6

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
