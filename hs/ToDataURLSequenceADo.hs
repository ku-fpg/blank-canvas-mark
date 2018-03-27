{-# LANGUAGE ApplicativeDo     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ParallelListComp  #-}
module ToDataURLSequenceADo (benchmark, summary) where

import           Control.Monad  (replicateM)
import           Data.Foldable  (sequenceA_)
import qualified Data.Text      as T
import           Graphics.Blank
import           System.Random
import           Utils

benchmark :: CanvasBenchmark
benchmark ctx = do
      rs <- replicateM numPictures $ randomRIO (0,100)
      send' ctx $  sequenceA_ [picture r | r <- rs ]

picture :: Double -> Canvas ()
picture  x = do
        clearCanvas
        beginPath();
        moveTo(170 + x, 80);
        bezierCurveTo(130 + x, 100, 130 + x, 150, 230 + x, 150);
        bezierCurveTo(250 + x, 180, 320 + x, 180, 340 + x, 150);
        bezierCurveTo(420 + x, 150, 420 + x, 120, 390 + x, 100);
        bezierCurveTo(430 + x, 40, 370 + x, 30, 340 + x, 50);
        bezierCurveTo(320 + x, 5, 250 + x, 20, 250 + x, 50);
        bezierCurveTo(200 + x, 5, 150 + x, 20, 170 + x, 80);
        closePath();
        lineWidth 5;
        strokeStyle "blue";
        stroke();
        cloud <- toDataURL();
        fillStyle("black");
        font "18pt Calibri"
        fillText(T.pack $ show $ T.take 50 $ cloud, 10, 300)

summary :: String
summary = "ToDataURLSequenceAApplicativeDo"

numPictures :: Int
numPictures = 30
