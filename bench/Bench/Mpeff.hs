{-
The handlers of Mp.Eff for state and reader are based on internal `IORef`
and `unsafePerformIO`. For a fair comparison, we implement the usual way
of handling these effects.
-}
module Bench.Mpeff
    ( Reader
    , ask
    , local
    , runReader
    , State
    , get
    , put
    , runState
    , runMpState
    ) where

import Control.Mp.Eff qualified as Mp
import Control.Mp.Util qualified as Mp

newtype Reader r e ans = Reader
    { askOp :: Mp.Op () r e ans
    }

data State s e ans = State
    { getOp :: Mp.Op () s e ans
    , putOp :: Mp.Op s () e ans
    }

ask :: Mp.Eff (Reader r Mp.:* e) r
ask = Mp.perform askOp ()

local :: (r -> r) -> Mp.Eff (Reader r Mp.:* e) a -> Mp.Eff (Reader r Mp.:* e) a
local f m = do
    r <- ask
    Mp.handlerHide Reader {askOp = Mp.value (f r)} m

runReader :: r -> Mp.Eff (Reader r Mp.:* e) a -> Mp.Eff e a
runReader r = Mp.handler Reader {askOp = Mp.value r}

get :: (State s Mp.:? e) => Mp.Eff e s
get = Mp.perform getOp ()

put :: (State s Mp.:? e) => s -> Mp.Eff e ()
put = Mp.perform putOp

-- Mp.state internally uses unsafe IO
runMpState :: s -> Mp.Eff (Mp.State s Mp.:* e) a -> Mp.Eff e (s, a)
runMpState s0 m = Mp.state s0 do
    r <- m
    s <- Mp.perform Mp.get ()
    pure (s, r)

-- The following implements state using state-passing functions in the
-- usual way.
runState :: s -> Mp.Eff (State s Mp.:* e) a -> Mp.Eff e (s, a)
runState s m = do
    f <- Mp.handlerRet (\a s' -> pure (s', a)) stateHandler m
    f s

stateHandler :: State s e (s -> Mp.Eff e (s, a))
stateHandler =
    State
        { getOp = Mp.operation \() k -> pure \s -> do
            f <- k s
            f s
        , putOp = Mp.operation \s k -> pure \_ -> do
            f <- k ()
            f s
        }