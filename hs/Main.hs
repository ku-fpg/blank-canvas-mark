module Main (main) where

import Criterion.Main (defaultMain, bench, nfIO)
import Paths_blank_canvas_mark
import Graphics.Blank
import Data.Maybe (isJust)
import Control.Applicative ((<$>))
import System.Environment (lookupEnv)

-------------------------------------------------------------------------------

import qualified Bezier
import qualified CirclesRandomSize
import qualified CirclesUniformSize
import qualified FillText
import qualified Image
import qualified IsPointInPath
--import qualified Life -- No JS version
import qualified MeasureText
import qualified Rave
import qualified StaticAsteroids

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
    putStrLn $ "Tests: " ++ unwords benchSummaries
    blankCanvas c2 $ \ ctx -> do
        defaultMain . map (\(b, s) -> bench s . nfIO $ b ctx) $ zip benchmarks benchSummaries
        putStrLn "done"
