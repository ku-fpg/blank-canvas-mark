module Main where

import Criterion.Main (defaultMain, bench, nfIO)
import Graphics.Blank
import System.Environment

-------------------------------------------------------------------------------

import qualified CirclesUniformSize

-------------------------------------------------------------------------------

benchmarks :: [DeviceContext -> IO ()]
benchmarks = [CirclesUniformSize.benchmark]

benchSummaries :: [String]
benchSummaries = [CirclesUniformSize.summary]

numBenchmarks :: Int
numBenchmarks = length benchmarks

main :: IO ()
main = getArgs >>= \args -> case args of
    n:_ -> let n' = read n
            in if read n `elem` [1..numBenchmarks]
                  then runBenchmark n'
                  else printUsage
    _   -> printUsage

runBenchmark :: Int -> IO ()
runBenchmark n = blankCanvas 3000 $ \ context -> defaultMain
    [ bench summary . nfIO $ benchmark context
    ] >> putStrLn "done"
  where
    benchmark = benchmarks !! (n-1)
    summary   = benchSummaries !! (n-1)

printUsage :: IO ()
printUsage = getProgName >>= putStrLn . usage

usage :: String -> String
usage progName = "usage: " ++ progName ++ " n, where n is a number from 1 to " ++ show numBenchmarks