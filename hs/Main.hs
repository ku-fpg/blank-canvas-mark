module Main (main) where

import Criterion.Main (defaultMain, bench, nfIO)
import Paths_blank_canvas_mark
import Graphics.Blank

-------------------------------------------------------------------------------

import qualified Bezier
import qualified CirclesRandomSize
import qualified CirclesUniformSize
import qualified FillText
import qualified Image
import qualified IsPointInPath
import qualified Life
import qualified MeasureText
import qualified Rave
import qualified StaticAsteroids

import Utils

-------------------------------------------------------------------------------

main :: IO ()
main = runBenchmark

benchmarks :: [CanvasBenchmark]
benchmarks = [ Bezier.benchmark
             , CirclesRandomSize.benchmark
             , CirclesUniformSize.benchmark
             , FillText.benchmark
             , Image.benchmark
             , IsPointInPath.benchmark
             , Life.benchmark
             , MeasureText.benchmark
             , Rave.benchmark
             , StaticAsteroids.benchmark
             ]

benchSummaries :: [String]
benchSummaries = [ Bezier.summary
                 , CirclesRandomSize.summary
                 , CirclesUniformSize.summary
                 , FillText.summary
                 , Image.summary
                 , IsPointInPath.summary
                 , Life.summary
                 , MeasureText.summary
                 , Rave.summary
                 , StaticAsteroids.summary
                 ]

runBenchmark :: IO ()
runBenchmark = do
    dat <- getDataDir
    blankCanvas 3000 { root = dat } $ \ ctx -> do
        defaultMain . map (\(b, s) -> bench s . nfIO $ b ctx) $ zip benchmarks benchSummaries
        putStrLn "done"
