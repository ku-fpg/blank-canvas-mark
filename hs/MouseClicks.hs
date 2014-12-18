{-# Language ParallelListComp #-}

module MouseClicks (benchmark, summary) where

import           Control.Monad

import qualified Data.Text as T
import           Data.Text (Text)

import           Graphics.Blank

import           Utils

benchmark :: CanvasBenchmark
benchmark ctx = do
  xs <- replicateM numClicks $ randomXCoord ctx
  ys <- replicateM numClicks $ randomYCoord ctx
  let positions = zip xs ys
  let clicks = map (\pos -> Event False (Just pos) click Nothing) positions
  send' ctx $ mapM_ trigger clicks
  mapM_ (detect ctx) $ take numClicks colors

summary :: String
summary = "MouseClicks"

numClicks :: Int
numClicks = 100

colors :: [Text]
colors = cycle $ map T.pack ["red", "blue", "green"]

showBall :: (Double, Double) -> Text -> Canvas ()
showBall (x, y) col = do
  beginPath()
  fillStyle(col)
  arc(x, y, 10, 0, pi*2, False)
  fill()

detect :: DeviceContext -> Text -> IO ()
detect ctx col = do
  event <- wait ctx
  case ePageXY event of
    Nothing  -> return ()
    Just pos -> send' ctx $ showBall pos col

click :: Text
click = T.pack "mouseDown"