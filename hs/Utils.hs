module Utils where

import Control.Applicative
import Graphics.Blank
import System.Random

type Path = (Double, Double, Double, Double)
type Point = (Double, Double)

randomXCoord, randomYCoord :: DeviceContext -> IO Double
randomXCoord ctx = (*width ctx) <$> randomIO
randomYCoord ctx = (*height ctx) <$> randomIO