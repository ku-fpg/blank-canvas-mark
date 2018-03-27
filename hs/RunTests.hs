--{-# LANGUAGE ApplicativeDo     #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import           Control.Concurrent
import           Data.Foldable            (for_)
import           GHC.IO.Handle
import           Prelude.Compat
import           Web.Browser

import           Graphics.Blank

import           System.Exit
import           System.IO.Unsafe
import           System.Posix.Process
import           System.Process

import qualified Bezier
import qualified CirclesRandomSize
import qualified CirclesUniformSize
import qualified FillText
import qualified Image
import qualified IsPointInPath
import qualified IsPointInPathADo
import qualified IsPointInPathSequenceA
import qualified IsPointInPathSequenceADo
import qualified Life
import qualified MeasureText
import qualified MeasureTextADo
import qualified MeasureTextSequenceA
import qualified MeasureTextSequenceADo
import qualified Rave
import qualified StaticAsteroids
import qualified ToDataURL
import qualified ToDataURLADo
import qualified ToDataURLSequenceA
import qualified ToDataURLSequenceADo

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

tests :: [String]
tests = [ Bezier.summary
        , CirclesRandomSize.summary
        , CirclesUniformSize.summary
        , FillText.summary
        , Image.summary
        , Life.summary
        , StaticAsteroids.summary
        , Rave.summary
        , IsPointInPath.summary
        , IsPointInPathSequenceA.summary
        , IsPointInPathADo.summary
        , IsPointInPathSequenceADo.summary
        , MeasureText.summary
        , MeasureTextSequenceA.summary
        , MeasureTextADo.summary
        , MeasureTextSequenceADo.summary
        , ToDataURL.summary
        , ToDataURLSequenceA.summary
        , ToDataURLADo.summary
        , ToDataURLSequenceADo.summary
        , "all"
        ]

main :: IO ()
main = do
       let bundlings = [Weak, Strong, Appl]
       putStrLn $ "Running: "++ show tests  ++ " for bundlings: " ++ show bundlings
       for_ [Weak,Strong,Appl] $ \b -> do
         _ <- createProcess (shell ("mkdir -p results/" ++ show b ))

         for_ tests $ \ test -> do
              print test
              let port = 3000
              let repFile = "results/"++ show b ++ "/" ++ test ++ ".html"
              (_,_,_,server)<- createProcess
                                 (proc "stack" ["exec","blank-canvas-mark", "--"
                                                      , "-s", show b
                                                      , "-t", test
                                                      , "-p", show port
                                                      , "-o", repFile
                                                      ])--{std_out = CreatePipe}
              -- wait half a second before opening browser
              threadDelay (500 * 1000)
              openBrowser $ "http://localhost:" ++ show port ++"/?height=600&width=800"
              waitForProcess server
