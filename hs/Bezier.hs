{-# LANGUAGE ApplicativeDo     #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
module Bezier (benchmark, summary) where

import           Control.Monad.Compat
import           Data.Foldable        (for_)
import           Graphics.Blank
import           Prelude.Compat
import           Utils

benchmark :: CanvasBenchmark
benchmark ctx = do
    bzs <- replicateM numBezier $ replicateM numCurves $ (,,,,,)
                      <$> randomXCoord ctx
                      <*> randomYCoord ctx
                      <*> randomXCoord ctx
                      <*> randomYCoord ctx
                      <*> randomXCoord ctx
                      <*> randomYCoord ctx
    send' ctx $ for_ bzs drawCloud

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
