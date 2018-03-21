{-# LANGUAGE NoImplicitPrelude #-}
module Main (main) where

import Criterion.Main (defaultMain, bench, nfIO)
import Data.Map (toList)
import Data.Maybe (isJust)
import Data.List (sort)
import Graphics.Blank
import Paths_blank_canvas_mark
import Prelude.Compat
import System.Environment (lookupEnv)

-------------------------------------------------------------------------------

-- import qualified Bezier
import qualified CirclesRandomSize
import qualified CirclesUniformSize
import qualified FillText
import qualified Image
import qualified IsPointInPath
--import qualified Life -- No JS version
import qualified MeasureText
import qualified Rave
import qualified StaticAsteroids
import qualified ToDataURL

import Utils

-------------------------------------------------------------------------------

main :: IO ()
main = runBenchmark

benchmarks :: [CanvasBenchmark]
benchmarks = [ {-Bezier.benchmark
             , -}CirclesRandomSize.benchmark
             , CirclesUniformSize.benchmark
             , FillText.benchmark
             , Image.benchmark
--             , Life.benchmark
             , StaticAsteroids.benchmark
             , Rave.benchmark
             , IsPointInPath.benchmark
             , MeasureText.benchmark
             , ToDataURL.benchmark
             ]

benchSummaries :: [String]
benchSummaries = [ {- Bezier.summary
                 , -} CirclesRandomSize.summary
                 , CirclesUniformSize.summary
                 , FillText.summary
                 , Image.summary
--                 , Life.summary
                 , StaticAsteroids.summary
                 , Rave.summary
                 , IsPointInPath.summary
                 , MeasureText.summary
                 , ToDataURL.summary
                 ]

runBenchmark :: IO ()
runBenchmark = do
    dat <- getDataDir
    let c0 = 3000 { root = dat }
    remote <- isJust <$> lookupEnv "BLANK_REMOTE"
    let c1 = if remote 
             then c0 { middleware = [] }
             else c0
    wk <- isJust <$> lookupEnv "BLANK_WEAK"
    let c2 = if wk
             then c1 { weak = True }
             else c1
    prof <- isJust <$> lookupEnv "BLANK_PROFILE"
    let c3 = if prof
             then c2 { profiling = True }
             else c2    
    putStrLn $ "Tests: " ++ unwords benchSummaries
    blankCanvas c3 $ \ ctx -> do
        defaultMain
           [ bench s $ nfIO $ b ctx
           | (b,s) <- zip benchmarks benchSummaries
           ]
        pktProf <-  readPacketProfile ctx
        putStr $ unlines
                 -- number of packets, each with how many commands and procedures
               [ show n ++ "," ++ show c ++ "," ++ show p
               | (PacketProfile c p,n) <- sort $ toList pktProf
               ]
        putStrLn "done"

