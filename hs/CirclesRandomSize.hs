{-# LANGUAGE ApplicativeDo     #-}
{-# LANGUAGE OverloadedStrings #-}
module CirclesRandomSize (benchmark, summary) where

import           Control.Monad  hiding (sequence_)
import           Data.Foldable  (for_)
import           Data.List      (zip4)
import           Data.Text      hiding (count)
import           Graphics.Blank
import           System.Random
import           Utils

benchmark :: CanvasBenchmark
benchmark ctx = do
    xs <- replicateM numCircles $ randomXCoord ctx
    ys <- replicateM numCircles $ randomYCoord ctx
    rs <- replicateM numCircles $ randomRIO (radiusMin, radiusMax)
    send' ctx $ for_ (zip4 xs ys rs (cycle ["red","blue","green"]))
                     (\ x y r col -> showBall (x, y) r col)


summary :: String
summary = "CirclesRandomSize"

numCircles :: Int
numCircles = 1000 * 1

radiusMin, radiusMax :: Double
radiusMin  = 1
radiusMax  = 50

showBall :: Point -> Double -> Text -> Canvas ()
showBall (x, y) r col = do
    beginPath();
    fillStyle(col);
    arc(x, y, r, 0, pi*2, False);
    closePath();
    fill();
