{-# LANGUAGE ApplicativeDo     #-}
{-# LANGUAGE OverloadedStrings #-}
module CirclesUniformSize (benchmark, summary) where

import           Control.Monad  hiding (sequence_)
import           Data.Foldable  (for_)
import           Data.Text      hiding (count)
import           Graphics.Blank
import           Utils

benchmark :: CanvasBenchmark
benchmark ctx = do
    xs <- replicateM numCircles $ randomXCoord ctx
    ys <- replicateM numCircles $ randomYCoord ctx
    send' ctx $ for_ (zip3 xs ys (cycle ["red","blue","green"]))
                    (\ (x, y, col) -> showBall (x,y) col)

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
