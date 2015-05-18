{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Main where

import           Control.Monad (mzero, when)
import           Control.Monad.Trans.Except

import           Criterion.Analysis
import           Criterion.IO.Printf
import           Criterion.Main
import           Criterion.Measurement (measured, initializeTime)
import           Criterion.Monad
import           Criterion.Report
import           Criterion.Types

import           Data.Aeson
import qualified Data.ByteString.Lazy as BS
import qualified Data.Vector as V

import           Prelude.Compat

import           Statistics.Resampling.Bootstrap -- as B

import           System.Directory
import           System.Environment

data SingleTest = SingleTest String [(Double,Int)]
        deriving Show

instance FromJSON SingleTest where
 parseJSON (Object v) =
    SingleTest
           <$> v .: "name"
           <*> fmap f (v .: "results")
      where f res = [ (t,i) | (Just t,i) <- res `zip` [1..] ]
 parseJSON _ = mzero

main :: IO ()
main = do
   initializeTime -- you need this
   [inpFile,outFile] <- getArgs
   inp <- BS.readFile inpFile
   let Just rawTestResults = decode inp
   let config = defaultConfig { verbosity = Verbose, reportFile = return "tmp.html", csvFile = return outFile }
   fileExists <- doesFileExist  outFile
   when fileExists $ removeFile outFile
   withConfig config $ do
           writeCsv ["Name","Mean","MeanLB","MeanUB","Stddev","StddevLB", "StddevUB"::String]
           rs <- sequence
                [ analyseOne n nm $ V.fromList $ [ measured { measTime = t, measIters = fromIntegral i } | (t,i) <- res ]
                | (n,SingleTest nm res) <- [0..] `zip` rawTestResults
                ]
           report rs
           return ()

analyseOne :: Int -> String -> V.Vector Measured -> Criterion Report
analyseOne i desc meas = do
  erp <- runExceptT $ analyseSample i desc meas
  case erp of
    Left err -> printError "*** Error: %s\n" err
    Right rpt@Report{..} -> do
      let SampleAnalysis{..} = reportAnalysis
          OutlierVariance{..} = anOutlierVar
      writeCsv (desc,
              estPoint anMean, estLowerBound anMean, estUpperBound anMean,
              estPoint anStdDev, estLowerBound anStdDev,
              estUpperBound anStdDev)
      return rpt
