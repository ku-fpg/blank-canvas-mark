{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ParallelListComp #-}
module IsPointInPath (benchmark, summary) where

import Control.Monad
import Graphics.Blank
import Prelude.Compat
import Utils

benchmark :: CanvasBenchmark
benchmark ctx = sequence_ [ internal ctx | _ <- [1..rounds]]

internal :: CanvasBenchmark
internal ctx = do
    pathX1 <- randomXCoord ctx
    pathX2 <- randomXCoord ctx
    pathY1 <- randomYCoord ctx
    pathY2 <- randomYCoord ctx
    points <- replicateM pointsPerPath $ (,) <$> randomXCoord ctx <*> randomYCoord ctx
    send ctx $ sequence_ [ isInPath (pathX1, pathX2, pathY1, pathY2) points ]

summary :: String
summary = "IsPointInPath"

rounds :: Int
rounds = 100

pointsPerPath :: Int
pointsPerPath = 10

pointRadius :: Double
pointRadius = 5

isInPath :: Path -> [Point] -> Canvas ()
isInPath (pathX, pathY, pathW, pathH) points = do
    strokeStyle("blue");
    beginPath();
    rect(pathX, pathY, pathW, pathH);
    cmds <- sequence [ do b <- isPointInPath(x, y);
                          return $ do
                              beginPath();
                              fillStyle(if b then "red" else "green");
                              arc(x, y, pointRadius, 0, pi*2, False);
                              fill();
                     | (x, y) <- points
                     ]
    stroke();
    sequence_ cmds
