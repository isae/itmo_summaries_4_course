
import Graphics.UI.Gtk

main = do
  initGUI
  window <- windowNew
  buf    <- textBufferNew Nothing
  view   <- textViewNewWithBuffer buf
  let
    handler :: TextIter -> [Char] -> IO()
    handler = undefined
  --handler = \_ _ -> putStrLn "hi!"
    buf `on` bufferInsertText $ handler
  set window [ containerChild := view ]
  widgetShowAll window
  mainGUI
