{- Code adapted from https://github.com/ku-fpg/better-life -}
module Life where

import Control.Concurrent
import Control.Monad

import Data.List
import Data.Text (pack)

import Graphics.Blank

import Numeric

import Utils

type Pos = (Int,Int)
type Size = (Int,Int)
type Config = (Size,Bool)
type Board = LifeBoard Config [Pos]

benchmark :: CanvasBenchmark
benchmark ctx = lifeCanvas numIters ctx $ scene ((50,50),False) gliderGun

summary :: String
summary = "Life"

numIters :: Int
numIters = 150

data LifeBoard c b = LifeBoard{
    config :: c
  , board :: b
} deriving Show

renderBall :: Pos -> Canvas ()
renderBall (x,y) = do 
        beginPath()
        let x' = 10 * x
        let y' = 10 * y
        fillStyle $ pack $ '#' : concat 
                [showHex (255 - (x' `mod` 255)) "", 
                  '0' : (showHex (0 :: Int) ""),
                  showHex (y' `mod` 255) ""]
        arc(fromIntegral x', fromIntegral y', 5 , 0, pi*2, False)
        closePath()
        fill()

renderBalls :: [Pos] -> Canvas ()
renderBalls xs = mapM_ renderBall xs

nextgen :: Board -> Board
nextgen b = LifeBoard (config b) $ sort $ board (survivors b) ++ board (births b)

alive :: Board -> [Pos]
alive = board

next :: Board -> Board
next = nextgen

neighbs :: Config -> Pos -> Board
neighbs c@((w,h),warp) (x,y) = LifeBoard c $ sort $ if warp
                then map (\(x',y') -> (x' `mod` w, y' `mod` h)) neighbors
                else filter (\(x',y') -> (x' >= 0 && x' < w) && (y' >= 0 && y' < h)) neighbors
        where neighbors = [(x-1,y-1), (x,y-1), (x+1,y-1), (x-1,y), (x+1,y), (x-1,y+1), (x,y+1), (x+1,y+1)]

isAlive :: Board -> Pos -> Bool
isAlive b p = elem p $ board b

isEmpty :: Board -> Pos -> Bool
isEmpty b = not . (isAlive b)

liveneighbs :: Board -> Pos -> Int
liveneighbs b = length . filter (isAlive b) . board . (neighbs (config b))

survivors :: Board -> Board
survivors b = LifeBoard (config b) $ filter (\p -> elem (liveneighbs b p) [2,3]) $ board b
--[ p | p <- board b, elem (liveneighbs b p) [2,3] ]

births :: Board -> Board
births b = LifeBoard (config b) $ filter (\p -> isEmpty b p && liveneighbs b p == 3) 
                                $ nub $ concatMap (board . (neighbs (config b))) $ board b

lifeCanvas :: Int -> DeviceContext -> Board -> IO ()
lifeCanvas n dc b = do 
        send dc $ do 
                clearRect (0, 0, width dc, height dc)
                renderBalls $ alive b
        threadDelay $ 50 * 50
        unless (n <= 0) $ lifeCanvas (n-1) dc $ next b

empty :: Config -> Board
empty = flip LifeBoard []

inv :: Pos -> Board -> Board
inv p b = LifeBoard (config b) $
    if isAlive b p
    then filter ((/=) p) $ board b
    else sort $ p : board b

scene :: Config -> [Pos] -> Board
scene = foldr inv . empty

gliderGun :: [Pos]
gliderGun = [(2,6), (2,7), (3,6), (3,7), (12,6), 
    (12,7), (12,8), (13,5), (13,9), (14,4), 
    (14,10), (15,4), (15,10), (16,7), (17,5), 
    (17,9), (18,6), (18,7), (18,8), (19,7),
    (22,4), (22,5), (22,6), (23,4), (23,5), 
    (23,6), (24,3), (24,7), (26,2), (26,3), 
    (26,7), (26,8), (36,4), (36,5), (37,4), (37,5)]

-- -- Runs Life indefinitely
-- life :: Config -> [Pos] -> IO ()
-- life c b = blankCanvas 3000 $ \dc -> lifeCanvas dc (scene c b :: Board)
-- 
-- main :: IO ()
-- main = life ((50,50),False) gliderGun