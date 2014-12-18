module Utils where

import Control.Applicative
import Graphics.Blank
import System.Random

type CanvasBenchmark = DeviceContext -> IO ()
type Path = (Double, Double, Double, Double)
type Point = (Double, Double)

randomXCoord, randomYCoord :: DeviceContext -> IO Double
randomXCoord ctx = (*width ctx) <$> randomIO
randomYCoord ctx = (*height ctx) <$> randomIO

-- A version of send' that ends with a sync
-- Forces the timings to be more realistic,
-- because you need to wait for them to reach the 
-- graphics pipeline.

send' :: DeviceContext -> Canvas () -> IO ()
send' c m = do send c $ m >> sync