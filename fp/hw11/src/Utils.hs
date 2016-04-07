{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE TemplateHaskell    #-}
{-# LANGUAGE TypeFamilies       #-}

module Utils where

import qualified Control.Monad.State as D
import Graphics.UI.Gtk
import Graphics.UI.Gtk.ModelView as Model
import Data.Acid
import Data.Acid.Remote
import Control.Applicative
import Control.Monad.Reader
import Control.Monad
import Data.SafeCopy
import Network
import System.Environment
import System.Exit
import System.IO
import Data.Typeable
import qualified Data.Map as Map

data Note = Note String deriving Typeable
data NoteList = NoteList [Note] deriving Typeable

insert :: String -> Update NoteList ()
insert record = do
     NoteList ns <- D.get
     D.put (NoteList (ns ++ [Note record]))

deleteByPosition :: Int -> Update NoteList ()
deleteByPosition pos = do
    NoteList ns <- D.get
    D.put (NoteList ((take (pos - 1) ns) ++ (drop (pos + 1) ns)))

edit :: Int -> String -> Update NoteList ()
edit pos record = do
    NoteList ns <- D.get
    D.put (NoteList ((take (pos - 1) ns) ++ [Note record] ++ (drop (pos + 1) ns)))

getNotesList :: Query NoteList [Note]
getNotesList = do 
    NoteList ns <- ask
    return ns

$(deriveSafeCopy 0 'base ''Note)
$(deriveSafeCopy 0 'base ''NoteList)
$(makeAcidic ''NoteList ['insert, 'deleteByPosition, 'edit, 'getNotesList])
