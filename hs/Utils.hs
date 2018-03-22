{-# LANGUAGE NoImplicitPrelude #-}
module Utils where

import           Graphics.Blank
import           Prelude.Compat
import           System.Random

type CanvasBenchmark = DeviceContext -> IO ()
type Path = (Double, Double, Double, Double)
type Point = (Double, Double)

randomXCoord, randomYCoord :: DeviceContext -> IO Double
randomXCoord ctx = (*width ctx) <$> randomIO
randomYCoord ctx = (*height ctx) <$> randomIO

-- A version of send that ends with a sync
-- Forces the timings to be more realistic,
-- because you need to wait for them to reach the
-- graphics pipeline.

send' :: DeviceContext -> Canvas a -> IO a
send' c m = send c $ do
               r <- m
               sync
               return r
