{-# LANGUAGE OverloadedStrings, ParallelListComp #-}
module Main where

import Graphics.Blank
import System.Random
import Data.Text(Text)
import Criterion.Main (defaultMain, bench, nfIO)


showBall :: (Float,Float) -> Text -> Canvas ()
showBall (x,y) col = do
        beginPath()
        fillStyle col
        arc(x, y, 10, 0, pi*2, False)
        closePath()
        fill()

draw :: Int -> DeviceContext -> IO ()
draw count context = do
  xs <- sequence [ randomIO | _ <- [1..count]]
  ys <- sequence [ randomIO | _ <- [1..count]]
  send context $ do
       sequence_ [ showBall (x * width context,y * height context) col
       		 | x <- xs
		     | y <- ys 
             | col <- cycle ["red","blue","green"]
       ]

main :: IO ()
main = blankCanvas 3000 $ \ context -> defaultMain 
        [ bench (show n ++ " circles") $ nfIO $ draw n context
        | n <- [1000]
        ] >> putStrLn "done"
