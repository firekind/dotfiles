--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

-- Base
import XMonad hiding ( (|||) )
import Data.Monoid
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

-- Actions
import XMonad.Actions.Submap

-- Data
import qualified Data.Map        as M

-- Hooks
import XMonad.Hooks.DynamicLog (xmobar, xmobarPP, xmobarColor, PP(..), wrap, shorten)
import XMonad.Hooks.DynamicBars  as Bars
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks)

-- Layouts
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed

-- Layout Modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.LimitWindows (limitWindows)
import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Layout.LayoutCombinators

-- Utilities
import XMonad.Util.SpawnOnce
import XMonad.Util.Run (spawnPipe)

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

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
        doubleLts x   = [x]

myWorkspaces :: [String]
myWorkspaces = clickable . (map xmobarEscape)
                $ [ "term", "code", "web", "dev", "app", "misc", "gfx", "chat" ]
    where
        clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                      (i, ws) <- zip [1..8] l,
                      let n = i]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#424242"
myFocusedBorderColor = "#dddddd"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm,               xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_space ), spawn "rofi -show drun -display-drun Apps -theme ~/.config/rofi/themes/appmenu.rasi")

    -- launch nautilus
	, ((modm,               xK_e     ), spawn "nautilus &")

    -- close focused window
    , ((modm .|. shiftMask, xK_q     ), kill)

    -- Rotate through the available layout algorithms
    , ((modm .|. shiftMask, xK_l     ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_Down  ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_Right ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_Up    ), windows W.focusUp  )

    -- Move focus to the previous window
    , ((modm,               xK_Left  ), windows W.focusUp  )

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_m     ), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_Down  ), windows W.swapDown  )

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_Right ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_Up    ), windows W.swapUp    )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_Left  ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    --- Switch to tabbed mode
    , ((modm .|. shiftMask, xK_t     ), sendMessage $ JumpToLayout "Tabbed")

    --- Switch to full screen mode
    , ((modm,               xK_f     ), sendMessage $ JumpToLayout "Full")

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Restart xmonad
    , ((modm .|. shiftMask, xK_r     ), spawn "xmonad --recompile; xmonad --restart")

	-- Volume up - XF86AudioRaiseVolume
	, ((0,                 0x1008ff13), spawn "sh ~/.config/i3/scripts/volume.sh increase")

	-- Volume down - XF86AudioLowerVolume
	, ((0,                 0x1008ff11), spawn "sh ~/.config/i3/scripts/volume.sh decrease")

	-- Volume mute - XF86AudioMute
	, ((0,                 0x1008ff12), spawn "sh ~/.config/i3/scripts/volume.sh mute")

	-- Brightness up - XF86MonBrightnessUp
	, ((0,                 0x1008ff02), spawn "sh ~/.config/i3/scripts/brightness.sh inc")

    -- Brightness down - XF86MonBrightnessDown
    , ((0,                 0x1008ff03), spawn "sh ~/.config/i3/scripts/brightness.sh dec")

	-- Screenshot
	, ((0,                     0xff61), spawn "sh ~/.config/i3/scripts/screenshot")

    -- Submap for logout, suspend, restart, shutdown
    , ((modm,                    xK_0), submap . M.fromList $ 
       -- logout
       [ ((0,                    xK_e), io exitSuccess)

       -- suspend
       , ((0,                    xK_s), spawn "sh ~/.config/i3/scripts/i3exit suspend")

       -- shutdown
       , ((shiftMask,            xK_s), spawn "sh ~/.config/i3/scripts/i3exit shutdown")

       -- reboot
       , ((0,                    xK_r), spawn "sh ~/.config/i3/scripts/i3exit reboot")

       -- lock
       , ((0,                    xK_l), spawn "sh ~/.config/i3/scripts/i3exit lock")
       ])
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{u,i,o}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{u,i,o}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_u, xK_i, xK_o] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

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

addGaps :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
addGaps i = spacingRaw False (Border i i i i) True (Border i i i i) True

myTabTheme = def { fontName            = "xft:Source Code Pro Semibold:size=11"
                 , activeTextColor     = "#1285A5"
                 , inactiveTextColor   = "#CCCCCC"
                 , activeColor         = "#111111"
                 , inactiveColor       = "#0B0B0B"
                 , activeBorderWidth   = 0
                 , inactiveBorderWidth = 0
                 , decoHeight          = 24
                 }


tall           = renamed [Replace "Tall"]
               $ limitWindows 8 
               $ addGaps 8
               $ ResizableTall 1 (3/100) (1/2) []

long           = renamed [Replace "Long"]
               $ Mirror tall

tabbed'        = renamed [Replace "Tabbed"]
               $ gaps [(U, 16), (D, 16), (L, 16), (R, 16)]
               $ tabbed shrinkText myTabTheme

fullScreen     = renamed [Replace "Full"]
               $ noBorders Full

myLayout    = tall
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
myManageHook = composeAll
    [ className =? "Firefox"                 --> doShift ( myWorkspaces !! 2 ) -- web
    , className =? "firefox"                 --> doShift ( myWorkspaces !! 2 ) -- web
    , className =? "Chromium"                --> doShift ( myWorkspaces !! 2 ) -- web
    , className =? "Code"                    --> doShift ( myWorkspaces !! 1 ) -- code
    , className =? "Atom"                    --> doShift ( myWorkspaces !! 1 ) -- code
    , className =? "discord"                 --> doShift ( myWorkspaces !! 7 ) -- chat
    , className =? "Signal"                  --> doShift ( myWorkspaces !! 7 ) -- chat
    , className =? "Gimp.bin"                --> doShift ( myWorkspaces !! 6 ) -- gfx
    , className =? "Pavucontrol"             --> doFloat 
    , className =? "GParted"                 --> doFloat
    , className =? "Lxappearance"            --> doFloat
    , className =? "Nitrogen"                --> doFloat
    , className =? "Nm-connection-editor"    --> doFloat]

------------------------------------------------------------------------
-- Status bar (XMobar)
-- Custom PP
--

xmobarCreator :: Bars.DynamicStatusBar
xmobarCreator (S sid) = spawnPipe $ "xmobar -x " ++ show sid

xmobarDestroyer :: Bars.DynamicStatusBarCleanup
xmobarDestroyer = return ()

myBarPP = xmobarPP { ppCurrent         = xmobarColor "#2E94A7" "" . wrap "[" "]"
                   , ppUrgent          = xmobarColor "#FF0000" ""
                   , ppHidden          = xmobarColor "#FFFFFF" ""
                   , ppHiddenNoWindows = xmobarColor "#616161" ""
                   , ppTitle           = xmobarColor "#FFFFFF" "" . shorten 40
                   , ppSep             = "<fc=#EBB079> : </fc>"
                   }

-- Key binding to toggle the gap for the bar
-- toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = Bars.dynStatusBarEventHook xmobarCreator xmobarDestroyer

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = Bars.multiPP myBarPP myBarPP

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
        Bars.dynStatusBarStartup xmobarCreator xmobarDestroyer
        spawnOnce "nitrogen --restore &"
        spawnOnce "picom -b &"
        spawnOnce "xfce4-power-manager &"
        spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &"
        spawnOnce "udiskie -c ~/.config/udiskie/config.yaml &"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = xmonad defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = avoidStruts $ myLayout,
        manageHook         = myManageHook <+> manageDocks,
        handleEventHook    = myEventHook <+> docksEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }

