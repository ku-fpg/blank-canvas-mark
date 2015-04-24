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
   inp <- BS.hGetContents stdin
   let Just [SingleTest nm res] = decode inp
   let config = defaultConfig { verbosity = Verbose, reportFile = return "foo.html" }
   r <- withConfig config $ do
           r1 <- analyseOne 0 nm $ V.fromList $ [ measured { measTime = t, measIters = fromIntegral i } | (t,i) <- res ]
           report [r1]
           return r1
   print "called"
{-   
   
   let m v i = measured { measTime = v * 1.01 * fromIntegral i, measIters = i,  measCpuTime = v + 1.0, measCycles = 1000 }
   let n v i = measured { measTime = v * sqrt (fromIntegral i), measIters = i }
   print "calling"
   r <- withConfig config $ do
           r1 <- analyseOne 0 "foo" $ V.fromList $ [m 4 i | (i,v) <- zip [1..] [0..8]]
           r2 <- analyseOne 1 "foo2" $ V.fromList $ [m 3 i | (i,v) <- zip [1..] [0..100]]
           r3 <- analyseOne 2 "foo3" $ V.fromList $ [n 5 i | (i,v) <- zip [1..] [0..100]]
           report [r1,r2,r3]
           return r1
   print "called"
   print r
   BS.putStrLn $ encode r
-}

analyseOne :: Int -> String -> V.Vector Measured -> Criterion Report
analyseOne i desc meas = do
  erp <- runExceptT $ analyseSample i desc meas
  case erp of
    Left err -> printError "*** Error: %s\n" err
    Right rpt -> return rpt
