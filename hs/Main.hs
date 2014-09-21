module Main (main) where

import Criterion.Main (defaultMain, bench, nfIO)
import Graphics.Blank

-------------------------------------------------------------------------------

import qualified CirclesRandomSize
import qualified CirclesUniformSize
import qualified FillText
import qualified IsPointInPath
import qualified MeasureText

import Utils

-------------------------------------------------------------------------------

main :: IO ()
main = runBenchmark

benchmarks :: [CanvasBenchmark]
benchmarks = [ CirclesRandomSize.benchmark
             , CirclesUniformSize.benchmark
             , FillText.benchmark
             , IsPointInPath.benchmark
             , MeasureText.benchmark
             ]

benchSummaries :: [String]
benchSummaries = [ CirclesRandomSize.summary
                 , CirclesUniformSize.summary
                 , FillText.summary
                 , IsPointInPath.summary
                 , MeasureText.summary
                 ]

runBenchmark :: IO ()
runBenchmark = blankCanvas 3000 $ \ ctx -> do
    defaultMain $ map (\(b, s) -> bench s . nfIO $ b ctx) $ zip benchmarks benchSummaries
    putStrLn "done"