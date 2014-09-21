{-# LANGUAGE ParallelListComp #-}
module Rave where

import           Control.Applicative
import           Control.Monad

import           Graphics.Blank
import qualified Graphics.Blank.Style as S
import           Graphics.Blank.Style (CanvasColor)

import           System.Random

import           Utils

benchmark :: CanvasBenchmark
benchmark ctx = do
    let w = width ctx
        h = height ctx
        dy = h / fromIntegral numGradients
        ys = [0, dy .. h-dy]
    rgbsList <- replicateM numGradients . replicateM numColors $
        S.rgb <$> randomIO <*> randomIO <*> randomIO
    send ctx $ sequence_ [ drawGradient (0, y, w, h) rgbs
                         | y <- ys
                         | rgbs <- rgbsList
                         ]

summary :: String
summary = "Rave"

numGradients, numColors :: Int
numGradients = 10
numColors    =  6

drawGradient :: CanvasColor c => Path -> [c] -> Canvas ()
drawGradient (x, y, w, h) cs = do
    rect(x, y, w, h);
    grd <- createLinearGradient(x, y, w, h);
    let cMaxIndex = fromIntegral $ length cs - 1
    forM_ (zip cs [0..cMaxIndex]) $ \(c,i) ->
        grd # S.addColorStop (i/cMaxIndex, c);
    S.fillStyle(grd);
    fill();