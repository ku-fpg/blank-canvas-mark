module Main (main) where

import Criterion.Main (defaultMain, bench, nfIO)
import Graphics.Blank

-------------------------------------------------------------------------------

import qualified CirclesRandomSize
import qualified CirclesUniformSize
import qualified FillText
import qualified MeasureText

-------------------------------------------------------------------------------

main :: IO ()
main = runBenchmark

benchmarks :: [DeviceContext -> IO ()]
benchmarks = [ CirclesRandomSize.benchmark
             , CirclesUniformSize.benchmark
             , FillText.benchmark
             , MeasureText.benchmark
             ]

benchSummaries :: [String]
benchSummaries = [ CirclesRandomSize.summary
                 , CirclesUniformSize.summary
                 , FillText.summary
                 , MeasureText.summary
                 ]

runBenchmark :: IO ()
runBenchmark = blankCanvas 3000 $ \ context -> do
    defaultMain $ map (\(b, s) -> bench s . nfIO $ b context) $ zip benchmarks benchSummaries
    putStrLn "done"