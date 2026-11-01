module Main where

import Data.List (isPrefixOf)

data KdpMember = KdpMember
  { memberId :: String
  , role     :: String
  , points   :: Int
  } deriving (Show, Eq)

me :: KdpMember
me = KdpMember
  { memberId = "KDPMember:KL5UQ4f48673352"
  , role     = "Member"
  , points   = 1
  }

-- The short code after the "KDPMember:" prefix
shortCode :: KdpMember -> String
shortCode m
  | prefix `isPrefixOf` i = drop (length prefix) i
  | otherwise             = i
  where
    prefix = "KDPMember:"
    i      = memberId m

main :: IO ()
main = do
  putStrLn "=== KDP Forum Profile ==="
  putStrLn $ "Nickname : " ++ memberId me
  putStrLn $ "Code     : " ++ shortCode me
  putStrLn $ "Role     : " ++ role me
  putStrLn $ "Points   : " ++ show (points me)
