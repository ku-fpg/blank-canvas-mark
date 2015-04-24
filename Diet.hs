{-# LANGUAGE OverloadedStrings, BangPatterns, DeriveDataTypeable, RecordWildCards #-}

module Main where

import Data.Text (Text)
import Criterion.Analysis
import Criterion.Monad
import Criterion.Types
import Criterion.Main
import Criterion.Report
import Criterion.Measurement (measured, initializeTime)
import Criterion.IO.Printf
import Control.Monad.Trans.Except
import Data.Aeson
import qualified Data.ByteString.Lazy as BS
import qualified Data.Vector as V
import Control.Applicative
import Data.Monoid
import Control.Monad
import System.IO (stdin)
import Statistics.Resampling.Bootstrap -- as B
import System.Directory
import System.Environment

data SingleTest = SingleTest String [(Double,Int)]
        deriving Show

instance FromJSON SingleTest where
 parseJSON (Object v) =
    SingleTest
           <$> v .: "name"
           <*> fmap f (v .: "results")
      where f res = [ (t,i) | (Just t,i) <- res `zip` [1..] ]
 parseJSON _ = mzero



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
                [ analyseOne 0 nm $ V.fromList $ [ measured { measTime = t, measIters = fromIntegral i } | (t,i) <- res ]
                | SingleTest nm res <- rawTestResults
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
