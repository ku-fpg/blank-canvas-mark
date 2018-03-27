--{-# LANGUAGE ApplicativeDo     #-}
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import           Control.Concurrent
import           Criterion.Main           (Benchmark, bench, defaultConfig,
                                           defaultMain, nfIO, runMode)
import           Criterion.Main.Options   (MatchType (..), Mode (..))
import           Criterion.Types          (Config (..))
import           Data.List                (sort)
import           Data.Map                 (toList)
-- import           Data.Maybe               (isJust)
import           Data.Semigroup           ((<>))
import           Graphics.Blank
import           Options.Applicative
import           Paths_blank_canvas_mark
import           Prelude.Compat
-- import           System.Environment       (lookupEnv)

import           System.Exit
import           System.IO.CodePage       (withCP65001)
import           System.IO.Unsafe
import           System.Posix.Process
import           System.Process


import qualified Data.HashMap.Strict      as HM
import qualified Data.Text                as T
-------------------------------------------------------------------------------

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

import           Utils

-------------------------------------------------------------------------------

data MyOptions = MyOptions
  {
    moStrategy   :: BundlingStrategy
  , moTests      :: T.Text
  , moPort       :: Integer
  , moProfiling  :: Bool
  , moReportFile :: Maybe FilePath
  , moCSVFile    :: Maybe FilePath
  }deriving Show

ops :: Parser MyOptions
ops = MyOptions <$> option auto (long "strategy"
                            <> short 's'
                            <> showDefault
                            <> value Appl
                            <> help "Bundle Strategy: weak, strong, applicative")
               <*> strOption (long "tests"
                             <> short 't'
                             <> help "Specific tests to run"
                             <> showDefault
                             <> value "all")
               <*> option auto
                   (long "port"
                   <> short 'p'
                   <> showDefault
                   <> value 3000
                   <> help "Port to run blank-canvas")
               <*> switch
                   (long "prof"
                    <> help "to run with blank-canvas profiling")
               -- Criterion flags
               <*> optional( strOption (long "output" <> short 'o'
                                         <> help "File to write report to"))
               <*> optional( strOption (long "csv"
                                      <> help "File to write CSV summary to"))

outputOption :: Maybe String -> Mod OptionFields String -> Parser (Maybe String)
outputOption file m =
  optional (strOption (m <> metavar "FILE" <> maybe mempty value file))

main :: IO ()
main =
  setupTests =<< execParser opts
    where
      opts = info (ops <**> helper)
                  ( fullDesc
                 <> progDesc "Run benchmarks individually with a given bundling strategy"
                 <> header "blank-canvas-mark - blank-canvas benchmarking suite" )
  -- runBenchmark

setupTests :: MyOptions -> IO()
setupTests mo = do
           print mo
           dat <- getDataDir
           let canvasOptions = (fromInteger (moPort mo)) { root = dat
                                                         , bundling = moStrategy mo
                                                         , profiling= moProfiling mo
                                                         }
           let criterionOptions = defaultConfig { reportFile = moReportFile mo
                                                , csvFile  = moCSVFile mo}
           runTests criterionOptions canvasOptions (moTests mo)

runTests :: Config -> Options -> T.Text -> IO ()
runTests crit canvas "all" = do
                        let (tests,summaries) = (benchmarks, benchSummaries)
                        putStrLn $ "Tests: " ++ unwords summaries
                        blankCanvas canvas $ \ctx -> do
                          -- defaultMain tries to use our commandline arguments
                          customDefaultMain crit summaries
                               [ bench s $ nfIO $ b ctx
                               | (b,s) <- zip tests summaries
                               ]
                          printProfileInfo ctx
                          close ctx
                          putStrLn "done"
runTests crit canvas test = case HM.lookup (T.unpack test) benchmarkMap of
                           Just (s,b) -> do
                                           runSeparateTest crit canvas b s
                           Nothing -> do
                                       let validTests = HM.keys benchmarkMap
                                       putStrLn $ "benchmark: " ++ show test ++ " not found. "
                                                 ++ "Please choose from: " ++ show validTests

runSeparateTest :: Config -> Options -> CanvasBenchmark -> String -> IO ()
runSeparateTest crit canvas b s =
                      blankCanvas canvas $ \ctx -> do
                        customDefaultMain crit [s] $ [bench s $ nfIO $ b ctx]
                        printProfileInfo ctx
                        close ctx
                        putStrLn "done"

                        -- send ctx $ eval "open(location, '_self').close()"
                        -- send ctx $ eval "window.close()"


close :: DeviceContext -> IO ()
close context = do
        send context $ eval "open(location, '_self').close()"
        threadDelay (1000 * 1000);
        putStrLn "dying"
        p <- getProcessID
        callProcess "kill" [show p]
        quit

quit :: IO a
quit = exitSuccess

printProfileInfo :: DeviceContext -> IO ()
printProfileInfo ctx = do
                          pktProf <-  readPacketProfile ctx
                          putStr $ unlines
                                   -- number of packets, each with how many commands and procedures
                                 [ show n ++ "," ++ show c ++ "," ++ show p
                                 | (PacketProfile c p,n) <- sort $ toList pktProf
                                 ]

customDefaultMain :: Config -> [String] -> [Benchmark] -> IO ()
customDefaultMain cfg summaries benches =
  withCP65001 $ runMode (Run cfg Prefix summaries) benches



benchmarks :: [CanvasBenchmark]
benchmarks = [ Bezier.benchmark
             , CirclesRandomSize.benchmark
             , CirclesUniformSize.benchmark
             , FillText.benchmark
             , Image.benchmark
             , Life.benchmark
             , StaticAsteroids.benchmark
             , Rave.benchmark
             , IsPointInPath.benchmark
             , IsPointInPathSequenceA.benchmark
             , IsPointInPathADo.benchmark
             , IsPointInPathSequenceADo.benchmark
             , MeasureText.benchmark
             , MeasureTextSequenceA.benchmark
             , MeasureTextADo.benchmark
             , MeasureTextSequenceADo.benchmark
             , ToDataURL.benchmark
             , ToDataURLSequenceA.benchmark
             , ToDataURLADo.benchmark
             , ToDataURLSequenceADo.benchmark
             ]

benchSummaries :: [String]
benchSummaries = [ Bezier.summary
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
                 ]

benchmarkMap :: HM.HashMap String (String,CanvasBenchmark)
benchmarkMap = HM.fromList $ zip benchSummaries (zip benchSummaries benchmarks)

-- runBenchmark :: IO ()
-- runBenchmark = do
--     dat <- getDataDir
--     let c0 = 3000 { root = dat }
--     remote <- isJust <$> lookupEnv "BLANK_REMOTE"
--     let c1 = if remote
--              then c0 { middleware = [] }
--              else c0
--     wk <- isJust <$> lookupEnv "BLANK_WEAK"
--     app <- isJust <$> lookupEnv "BLANK_APP"
--     str <- isJust <$> lookupEnv "BLANK_STRONG"
--     print (app,str,wk)
--     let c2 = if app
--              then c1 { bundling = Appl }
--              else if str
--              then c1 { bundling = Strong }
--              else if wk
--              then c1 { bundling = Weak}
--              else c1
--     prof <- isJust <$> lookupEnv "BLANK_PROFILE"
--     let c3 = if prof
--              then c2 { profiling = True }
--              else c2
--     putStrLn $ "Tests: " ++ unwords benchSummaries
--     blankCanvas c3 $ \ ctx -> do
--         defaultMain
--            [ bench s $ nfIO $ b ctx
--            | (b,s) <- zip benchmarks benchSummaries
--            ]
--         printProfileInfo ctx
--         putStrLn "done"
