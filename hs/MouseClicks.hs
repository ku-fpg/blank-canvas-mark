{-# Language ParallelListComp #-}

module MouseClicks(benchmark, summary) where

import Graphics.Blank

import System.Random
import Control.Monad
import qualified Data.Text as T

summary :: String
summary = "MouseClicks"

numClicks :: Int
numClicks = 100

colors :: [T.Text]
colors = cycle $ map T.pack ["red", "blue", "green"]

benchmark :: DeviceContext -> IO ()
benchmark = draw numClicks

showBall :: (Double, Double) -> T.Text -> Canvas ()
showBall (x, y) col = do
  beginPath()
  fillStyle(col)
  arc(x, y, 10, 0, pi*2, False)
  fill()

detect :: DeviceContext -> T.Text -> IO ()
detect ctx col = do
  event <- wait ctx
  case ePageXY event of
    Nothing  -> return ()
    Just pos -> send ctx $ showBall pos col

click :: T.Text
click = T.pack "mouseDown"

draw :: Int -> DeviceContext -> IO ()
draw numClicks ctx = do
  xs <- replicateM numClicks $ randomRIO (0, width  ctx)
  ys <- replicateM numClicks $ randomRIO (0, height ctx)
  let positions = zip xs ys
  let clicks = map (\pos -> Event False (Just pos) click Nothing) positions
  send ctx $ mapM_ trigger clicks
  mapM_ (detect ctx) $ take numClicks colors
  
