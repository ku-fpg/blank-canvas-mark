{-# Language ParallelListComp #-}

module StaticAsteroids (summary, benchmark, showAsteroid) where

import Graphics.Blank

import Control.Monad
import System.Random
import Data.List(tails)
import qualified Data.Text as T

type Point = (Double, Double)

summary :: String
summary = "StaticAsteroids"

numAsteroids :: Int
numAsteroids = 10

showAsteroid :: Point -> [Point] -> Canvas ()
showAsteroid (x,y) pts = do
  beginPath()
  moveTo (x,y)
  mapM lineTo pts
  closePath()
  stroke()

mkPts :: Point -> [(Double, Double)] -> [Point]
mkPts (x,y) [] = [(x,y)]
mkPts (x,y) ((dx, dy) : ds)= (x'+dx,y'+dy) : rest where
  rest = mkPts (x,y) ds
  (x',y') = head rest

splitEvery :: Int -> [a] -> [[a]]
splitEvery n = takeWhile (not.null) . map (take n) . iterate (drop n) -- borrowed from Magnus Kronqvist on stack overflow

benchmark :: DeviceContext  -> IO ()
benchmark ctx = do
  xs  <- replicateM numAsteroids $ randomRIO (0, width ctx) 
  ys  <- replicateM numAsteroids $ randomRIO (0, height ctx)
  dxs <- replicateM numAsteroids $ randomRIO (-10, 15)
  dys <- replicateM numAsteroids $ randomRIO (-10, 15)
  send ctx $ sequence_ [showAsteroid (x,y) (mkPts (x,y) ds) 
                       | x <- xs
                       | y <- ys
                       | ds <- cycle $ splitEvery 10 $ zip dxs dys
                       ]
