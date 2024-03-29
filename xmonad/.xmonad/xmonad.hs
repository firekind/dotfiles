--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import qualified Data.Map as M
import Data.Monoid
import System.Exit (exitSuccess)
import XMonad hiding ((|||))
import XMonad.Actions.CycleWS (nextScreen, prevScreen, shiftNextScreen, shiftPrevScreen)
import XMonad.Actions.Warp (warpToWindow)
import XMonad.Hooks.DynamicBars (DynamicStatusBar, DynamicStatusBarCleanup, dynStatusBarEventHook, dynStatusBarStartup, multiPP)
import XMonad.Hooks.DynamicLog (PP (..), shorten, wrap, xmobarColor, xmobarPP)
import XMonad.Hooks.ManageDocks (ToggleStruts (ToggleStruts), avoidStruts, docksEventHook, manageDocks)
import XMonad.Hooks.Place (placeHook, fixed)
import XMonad.Layout.Gaps (GapMessage (ToggleGaps), gaps)
import XMonad.Layout.LayoutCombinators (JumpToLayout (JumpToLayout), (|||))
import XMonad.Layout.LayoutModifier (ModifiedLayout)
import XMonad.Layout.LimitWindows (limitWindows)
import XMonad.Layout.NoBorders (noBorders)
import XMonad.Layout.Renamed (Rename (Replace), renamed)
import XMonad.Layout.ResizableTile (ResizableTall (..))
import XMonad.Layout.Spacing (Border (Border), Spacing, spacingRaw, toggleScreenSpacingEnabled, toggleWindowSpacingEnabled)
import XMonad.Layout.Tabbed (Direction2D (..), Theme (..), shrinkText, tabbedAlways)
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig (mkKeymap)
import XMonad.Util.NamedScratchpad (NamedScratchpad (NS), customFloating, namedScratchpadAction, namedScratchpadFilterOutWorkspacePP, namedScratchpadManageHook)
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.SpawnOnce (spawnOnce)

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal :: String
myTerminal = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth :: Dimension
myBorderWidth = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--

myModMask :: KeyMask
myModMask = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
    doubleLts '<' = "<<"
    doubleLts x = [x]

myWorkspaces :: [String]
myWorkspaces =
  clickable . map xmobarEscape $
    ["term", "code", "web", "dev", "app", "misc", "gfx", "chat"]
  where
    clickable l =
      [ "<action=xdotool key super+" ++ show n ++ ">" ++ ws ++ "</action>"
        | (i, ws) <- zip [1 .. 8] l,
          let n = i
      ]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor :: String
myNormalBorderColor = "#424242"

myFocusedBorderColor :: String
myFocusedBorderColor = "#dddddd"

-- Function to toggle all gaps
--
toggleAllGaps :: X ()
toggleAllGaps = toggleWindowSpacingEnabled >> toggleScreenSpacingEnabled >> sendMessage ToggleGaps

-- Function that toggles gaps and struts, effectively filling the
-- entire screen with the current layout
--
toggleGapsAndStruts :: X ()
toggleGapsAndStruts = toggleAllGaps >> sendMessage ToggleStruts

-- scratch pads
--
termScratchpadName :: String
termScratchpadName = "alacritty-scratchpad"

htopScratchpadName :: String
htopScratchpadName = "htop-scratchpad"

scratchpads =
  [ NS termScratchpadName spawnTerm findTerm manageTerm,
    NS htopScratchpadName spawnHtop findHtop manageHtop
  ]
  where
    spawnTerm = unwords [myTerminal, "-t", termScratchpadName] -- command to spawn terminal
    findTerm = title =? termScratchpadName
    manageTerm = customFloating $ W.RationalRect 0.592 0.016 0.4 0.3

    spawnHtop = unwords [myTerminal, "-t", htopScratchpadName, "-e", "htop"] -- command to spawn htop
    findHtop = title =? htopScratchpadName
    manageHtop = customFloating $ W.RationalRect 0.05 0.05 0.9 0.9

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf =
  mkKeymap conf $
    [ -- launch rofi:
      ("M-<Space>", spawn "rofi -show drun -display-drun Apps -theme ~/.config/rofi/themes/appmenu.rasi"),
      -- launch a terminal:
      ("M-<Return>", spawn $ XMonad.terminal conf),
      -- toggle terminal scratchpad:
      -- ("M-`", namedScratchpadAction scratchpads termScratchpadName),
      -- toggle htop scratchpad:
      -- ("M-S-x", namedScratchpadAction scratchpads htopScratchpadName),
      -- launch nautilus:
      ("M-e", spawn "nautilus"),
      -- launch rofi calendar:
      ("M-c", spawn "~/.config/custom-scripts/calendar"),
      -- launch rofi wifi menu:
      ("M-w", spawn "networkmanager_dmenu"),
      -- launch rofi calculator
      ("M-S-c", spawn "rofi -show calc -modi calc -no-show-match -no-sort -theme ~/.config/rofi/themes/calc.rasi"),
      -- close focused window:
      ("M-S-q", kill),
      -- toggle gaps:
      -- ("M-S-g", toggleAllGaps),
      -- toggle gaps and struts:
      -- ("M-S-f", toggleGapsAndStruts),
      -- Rotate through the available layout algorithms:
      ("M-S-l", sendMessage NextLayout),
      --  Reset the layouts on the current workspace to default:
      ("M-S-<Space>", setLayout $ XMonad.layoutHook conf),
      -- Resize viewed windows to the correct size:
      ("M-n", refresh),
      -- Move focus to the next window:
      ("M-<Tab>", windows W.focusDown),
      -- Move focus to the next window:
      ("M-l", windows W.focusDown),
      -- Move focus to the next window:
      ("M-j", windows W.focusDown),
      -- Move focus to the previous window:
      ("M-k", windows W.focusUp),
      -- Move focus to the previous window:
      ("M-h", windows W.focusUp),
      -- Move focus to the previous window:
      ("M-m", windows W.focusMaster),
      -- Swap the focused window and the master window:
      ("M-S-m", windows W.swapMaster),
      -- Swap the focused window with the next window:
      ("M-S-<Down>", windows W.swapDown),
      -- Swap the focused window with the next window:
      ("M-S-<Right>", windows W.swapDown),
      -- Swap the focused window with the previous window:
      ("M-S-<Up>", windows W.swapUp),
      -- Swap the focused window with the previous window:
      ("M-S-<Left>", windows W.swapUp),
      -- Shrink the master area:
      ("M--", sendMessage Shrink),
      -- Expand the master area:
      ("M-S-=", sendMessage Expand),
      -- Push window back into tiling:
      ("M-t", withFocused $ windows . W.sink),
      --- Switch to tabbed mode:
      ("M-S-t", sendMessage $ JumpToLayout "Tabbed"),
      --- Switch to full screen mode:
      ("M-f", sendMessage (JumpToLayout "Full") >> sendMessage ToggleStruts),
      -- Increment the number of windows in the master area:
      -- ("M-,", sendMessage (IncMasterN 1)),
      -- Deincrement the number of windows in the master area:
      -- ("M-.", sendMessage (IncMasterN (-1))),
      -- Restart xmonad:
      ("M-S-r", spawn "xmonad --recompile; xmonad --restart"),
      -- Volume up - XF86AudioRaiseVolume:
      ("<XF86AudioRaiseVolume>", spawn "~/.config/custom-scripts/volume increase"),
      -- Volume down - XF86AudioLowerVolume:
      ("<XF86AudioLowerVolume>", spawn "~/.config/custom-scripts/volume decrease"),
      -- Volume mute - XF86AudioMute:
      ("<XF86AudioMute>", spawn "~/.config/custom-scripts/volume mute"),
      -- Brightness up - XF86MonBrightnessUp:
      ("<XF86MonBrightnessUp>", spawn "~/.config/custom-scripts/brightness inc"),
      -- Brightness down - XF86MonBrightnessDown:
      ("<XF86MonBrightnessDown>", spawn "~/.config/custom-scripts/brightness dec"),
      -- Screenshot:
      ("<Print>", spawn "~/.config/custom-scripts/screenshot"),
      -- logout:
      ("M-0 e", io exitSuccess),
      -- suspend:
      ("M-0 s", spawn "sh ~/.config/custom-scripts/power-and-session suspend"),
      -- shutdown:
      ("M-0 S-s", spawn "sh ~/.config/custom-scripts/power-and-session shutdown"),
      -- reboot:
      ("M-0 r", spawn "sh ~/.config/custom-scripts/power-and-session reboot"),
      -- lock:
      ("M-0 l", spawn "sh ~/.config/custom-scripts/power-and-session lock"),
      -- Switch focus to next monitor and move mouse to the top right of the focused window on that screen:
      ("M-]", nextScreen >> warpToWindow 1 0),
      -- Move focused window to next monitor:
      ("M-S-]", shiftNextScreen),
      -- Switch focus to previous monitor and move mouse to the top right of the focused window on that screen:
      ("M-[", prevScreen >> warpToWindow 1 0),
      -- Move focused window to previous monitor:
      ("M-S-[", shiftPrevScreen)
    ]
      ++
      -- mod-[1..9], Switch to workspace N
      -- mod-shift-[1..9], Move client to workspace N
      [ (m ++ k, windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) (map show [1 .. 8]),
          (f, m) <- [(W.greedyView, "M-"), (W.shift, "M-S-")]
      ]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings :: XConfig l0 -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings XConfig {XMonad.modMask = modm} =
  M.fromList
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ( (modm, button1),
        \w ->
          focus w >> mouseMoveWindow w
            >> windows W.shiftMaster
      ),
      -- mod-button2, Raise the window to the top of the stack
      ((modm, button2), \w -> focus w >> windows W.shiftMaster),
      -- mod-button3, Set the window to floating mode and resize by dragging
      ( (modm, button3),
        \w ->
          focus w >> mouseResizeWindow w
            >> windows W.shiftMaster
      )
      -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
addGaps :: Integer -> l a -> ModifiedLayout Spacing l a
addGaps i = spacingRaw False (Border i i i i) True (Border i i i i) True

tabTheme :: Theme
tabTheme =
  def
    { fontName = "xft:Source Code Pro Semibold:size=11",
      activeTextColor = "#2E94A7",
      inactiveTextColor = "#CCCCCC",
      urgentTextColor = "#FFFFFF",
      activeColor = "#111111",
      inactiveColor = "#0B0B0B",
      urgentColor = "#FF0000",
      activeBorderWidth = 0,
      inactiveBorderWidth = 0,
      decoHeight = 24
    }

tall =
  renamed [Replace "Tall"] $
    limitWindows 8 $
      addGaps 8 $
        ResizableTall 1 (3 / 100) (1 / 2) []

long =
  renamed [Replace "Long"] $
    Mirror tall

tabbed' =
  renamed [Replace "Tabbed"] $
    avoidStruts $ -- so that struts are avoided when going from Full to Tabbed layout
      gaps [(U, 16), (D, 16), (L, 16), (R, 16)] $
        noBorders $ tabbedAlways shrinkText tabTheme

fullScreen =
  renamed [Replace "Full"] $
    noBorders Full

myLayout =
  avoidStruts $
    tall
      ||| long
      ||| tabbed'
      ||| fullScreen

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook :: ManageHook
myManageHook =
  composeAll
    [ -- namedScratchpadManageHook scratchpads,
      placeHook $ fixed (0.5, 0.5),
      manageDocks,
      -- app specific
      className =? "Atom" --> doShift (myWorkspaces !! 1), -- code
      className =? "Code" --> doShift (myWorkspaces !! 1), -- code
      className =? "Chromium" --> doShift (myWorkspaces !! 2), -- web
      className =? "Firefox" --> doShift (myWorkspaces !! 2), -- web
      className =? "firefox" --> doShift (myWorkspaces !! 2), -- web
      className =? "obs" --> doShift (myWorkspaces !! 6), -- app
      className =? "Org.gnome.Nautilus" --> doShift (myWorkspaces !! 4), -- app
      className =? "pcmanfm-qt" --> doShift (myWorkspaces !! 4), -- app
      className =? "vlc" --> doShift (myWorkspaces !! 5), -- misc
      className =? "Gimp.bin" --> doShift (myWorkspaces !! 6), -- gfx
      className =? "discord" --> doShift (myWorkspaces !! 7), -- chat
      className =? "Signal" --> doShift (myWorkspaces !! 7), -- chat
      className =? "GParted" --> doFloat,
      className =? "Lxappearance" --> doFloat,
      className =? "Nitrogen" --> doFloat,
      className =? "Nm-connection-editor" --> doFloat,
      className =? "Pavucontrol" --> doFloat,
      className =? "Zenity" <&&> title =? "=Authentication" --> doFloat,
      className =? "File-roller" --> doFloat,
      className =? "TelegramDesktop" --> doShift (myWorkspaces !! 7), -- chat
      className =? "Slack" --> doShift (myWorkspaces !! 7), -- chat
      title =? "Firefox - Choose User Profile" --> doFloat
    ]

------------------------------------------------------------------------
-- Status bar (XMobar)
-- Custom PP
--
xmobarCreator :: DynamicStatusBar
xmobarCreator (S sid) = spawnPipe $ "xmobar -x " ++ show sid

xmobarDestroyer :: DynamicStatusBarCleanup
xmobarDestroyer = return ()

barPP :: PP
barPP =
  namedScratchpadFilterOutWorkspacePP $ -- prevents the NSP workspace from showing up in xmobar
    xmobarPP
      { ppCurrent = xmobarColor "#2E94A7" "",
        ppVisible = xmobarColor "#FFFFFF" "" . wrap "(" ")",
        ppUrgent = xmobarColor "#FF0000" "",
        ppHidden = xmobarColor "#FFFFFF" "",
        ppHiddenNoWindows = xmobarColor "#616161" "",
        ppTitle = xmobarColor "#FFFFFF" "" . shorten 40,
        ppSep = "<fc=#AF5F00> : </fc>",
        ppLayout = xmobarColor "#FFFFFF" "" . wrap "<action=xdotool key super+shift+l>" "</action>"
      }

barActivePP :: PP
barActivePP =
  barPP
    { ppCurrent = xmobarColor "#2E94A7" "" . wrap "[" "]"
    }

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook

--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook :: Event -> X All
myEventHook =
  composeAll
    [ dynStatusBarEventHook xmobarCreator xmobarDestroyer,
      docksEventHook
    ]

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook :: X ()
myLogHook = multiPP barActivePP barPP

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook :: X ()
myStartupHook = do
  dynStatusBarStartup xmobarCreator xmobarDestroyer
  spawnOnce "~/.fehbg &"
  -- spawnOnce "picom -b &"
  spawnOnce "xfce4-power-manager &"
  spawnOnce "udiskie -c ~/.config/udiskie/config.yaml &"
  spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &"
  spawnOnce "gnome-keyring-daemon --start &"
  -- spawnOnce "xsetroot -cursor_name Left_ptr"
  spawnOnce "autorandr --change &"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main :: IO ()
main = xmonad defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults =
  def
    { -- simple stuff
      terminal = myTerminal,
      focusFollowsMouse = myFocusFollowsMouse,
      clickJustFocuses = myClickJustFocuses,
      borderWidth = myBorderWidth,
      modMask = myModMask,
      workspaces = myWorkspaces,
      normalBorderColor = myNormalBorderColor,
      focusedBorderColor = myFocusedBorderColor,
      -- key bindings
      keys = myKeys,
      mouseBindings = myMouseBindings,
      -- hooks, layouts
      layoutHook = myLayout,
      manageHook = myManageHook,
      handleEventHook = myEventHook,
      logHook = myLogHook,
      startupHook = myStartupHook
    }
