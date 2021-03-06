-- Copyright 2020 Pfizer Inc.

-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at

--     https://www.apache.org/licenses/LICENSE-2.0

-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
{-# LANGUAGE UndecidableInstances #-}
module Lagoon.Interface.FriendlyException (FriendlyException(..)) where

import Control.Exception

-- | User-friendly rendering of an exception
--
-- The goal here is to make the error understandable to application users
-- (non-Haskell experts), even if some detail is lost
class Exception e => FriendlyException e where
  displayFriendly :: e -> String
  displayFriendly = displayException
