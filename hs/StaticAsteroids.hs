{-# Language ParallelListComp #-}
module StaticAsteroids (benchmark, summary) where

import Control.Monad
import Graphics.Blank
import System.Random
import Utils

benchmark :: CanvasBenchmark
benchmark ctx = do
  xs  <- replicateM numAsteroids $ randomXCoord ctx
  ys  <- replicateM numAsteroids $ randomYCoord ctx
  dxs <- replicateM numAsteroids $ randomRIO (-10, 15)
  dys <- replicateM numAsteroids $ randomRIO (-10, 15)
  send' ctx $ do
             clearCanvas
             sequence_ [showAsteroid (x,y) (mkPts (x,y) ds)
                       | x <- xs
                       | y <- ys
                       | ds <- cycle $ splitEvery 10 $ zip dxs dys
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
mkPts (x,y) [] = [(x,y)]
mkPts (x,y) ((dx, dy) : ds)= (x'+dx,y'+dy) : rest where
  rest = mkPts (x,y) ds
  (x',y') = head rest

splitEvery :: Int -> [a] -> [[a]]
splitEvery n = takeWhile (not.null) . map (take n) . iterate (drop n) -- borrowed from Magnus Kronqvist on stack overflow
