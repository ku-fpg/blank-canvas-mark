{-# LANGUAGE ApplicativeDo    #-}
{-# LANGUAGE ParallelListComp #-}
module StaticAsteroids (benchmark, summary) where

import           Control.Monad  hiding (sequence_)
import           Data.Foldable  (sequenceA_)
import           Graphics.Blank
import           System.Random
import           Utils

benchmark :: CanvasBenchmark
benchmark ctx = do
  xs  <- replicateM numAsteroids $ randomXCoord ctx
  ys  <- replicateM numAsteroids $ randomYCoord ctx
  dxs <- replicateM numAsteroids $ randomRIO (-15, 15)
  dys <- replicateM numAsteroids $ randomRIO (-15, 15)
  send' ctx $ do
             clearCanvas
             sequenceA_ [showAsteroid (x,y) (mkPts (x,y) ds)
                       | x <- xs
                       | y <- ys
                       | ds <- cycle $ splitEvery 6 $ zip dxs dys
                       ]

summary :: String
summary = "StaticAsteroids"

numAsteroids :: Int
numAsteroids = 1000

showAsteroid :: Point -> [Point] -> Canvas ()
showAsteroid (x,y) pts = do
  beginPath()
  moveTo (x,y)
  mapM_ lineTo pts
  closePath()
  stroke()

mkPts :: Point -> [(Double, Double)] -> [Point]
mkPts (x,y) xs = [ (x+x',y+y') | (x',y') <- xs ]

splitEvery :: Int -> [a] -> [[a]]
splitEvery n = takeWhile (not.null) . map (take n) . iterate (drop n) -- borrowed from Magnus Kronqvist on stack overflow
