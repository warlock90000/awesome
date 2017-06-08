local awful         = require("awful")
local tyrannical = require("tyrannical")
-- {{{ Tyrannical tags
tyrannical.settings.default_layout = awful.layout.suit.floating
tyrannical.tags = {
    {
        name        = "",
        init        = true,
        exclusive   = true,
        screen      = 1,
        --screen      = screen.count()>1 and 2 or 1,-- Setup on screen 2 if there is more than 1 screen, else on screen 1
        layout      = awful.layout.suit.floating,
        class = {"Pale moon", "Firefox", "Vivaldi-stable", "Chromium"}
    },
    {
        name        = "",                 -- Call the tag "Term"
        init        = true,                   -- Load the tag on startup
        exclusive   = true,                   -- Refuse any other type of clients (by classes)
        screen      = 1,                  -- Create this tag on screen 1 and screen 2
        layout      = awful.layout.suit.tile, -- Use the tile layout
        class       = {"konsole", "terminator", "qterminal", "urxvt", "URxvt"}
    },
    --[[
    {
        name        = "",
        init        = false,
        exclusive   = true,
        screen      = {1,2},
        layout      = awful.layout.suit.tile,
        class       = {"urxvt", "URxvt"}
    },
    ]]--
    {
        name        = "",
        init        = true,
        exclusive   = true,
        screen      = 1,
        layout      = awful.layout.suit.max,
        class       = {"Subl", "Subl3"}
    },
    {
        name        = "",
        init        = true,
        exclusive   = true,
        screen      = 1,
        force_screen = true,
        layout      = awful.layout.suit.max,
        class = {"Vlc", "bomi", "Freetuxtv", "mpv", "webtorrent", "smplayer"}
    },
    {
        name        = "",
        init        = false,
        exclusive   = true,
        screen      = {1,2}, --screen.count()>1 and 2 or 1,
        layout      = awful.layout.suit.max,
        --exec_once   = {"dolphin"}, --When the tag is accessed for the first time, execute this command
        class  = {"Thunar", "Konqueror", "Dolphin", "ark", "Nautilus", "Doublecmd", "pcmanfm-qt"}
    },
    {
        name        = "",
        init        = false,
        exclusive   = true,
        screen      = 1,
        layout      = awful.layout.suit.floating,
        class = {"Kate", "KDevelop", "Codeblocks", "Code::Blocks" , "DDD", "kate4"}
    },
    {
        name        = "",
        init        = false,
        exclusive   = true,
        screen      = 1,
        layout      = awful.layout.suit.floating,
        class = {"lximage-qt", "XnViewMP", "Okular", "xpdf", "Xpdf", "Hotshots", "Photoshop.exe"}
    },
    --- Screen 2
    {
        name        = "",
        init        = true,
        exclusive   = true,
        screen      = 2,
        force_screen = true,
        layout      = awful.layout.suit.floating,
        class = {"Conky"}
    },
    {
        name        = "",
        init        = true,
        exclusive   = true,
        screen      = 2,
        force_screen = true,
        layout      = awful.layout.suit.tile,
        class       = {"xterm", "XTerm"}
    },
    {
        name        = "",
        init        = true,
        exclusive   = true,
        screen      = 2,
        force_screen = true,
        layout      = awful.layout.suit.tile,
        class = {"ktorrent", "Transgui"}
    },
    {
        name        = "",
        init        = false,
        exclusive   = true,
        screen      = 2,
        force_screen = true,
        layout      = awful.layout.suit.max,
        class = {"Audacious", "ncmpcpp", "URxvt:ncmpcpp"}
    },
    {
        name        = "",
        init        = false,
        exclusive   = true,
        screen      = 2,
        force_screen = true,
        layout      = awful.layout.suit.tile,
        class       = {"Skype", "TelegramDesktop", "Mumble"}
    },
}

-- Ignore the tag "exclusive" property for the following clients (matched by classes)
tyrannical.properties.intrusive = {
    "ksnapshot"     , "pinentry"       , "gtksu"     , "kcalc"        , "xcalc"               ,
    "feh"           , "Gradient editor", "About KDE" , "Paste Special", "Background color"    ,
    "kcolorchooser" , "plasmoidviewer" , "Xephyr"    , "kruler"       , "plasmaengineexplorer",
}

-- Ignore the tiled layout for the matching clients
tyrannical.properties.floating = {
    "MPlayer"      , "pinentry"        , "ksnapshot"  , "pinentry"     , "gtksu"          ,
    "xine"         , "feh"             , "kmix"       , "kcalc"        , "xcalc"          ,
    "yakuake"      , "Select Color$"   , "kruler"     , "kcolorchooser", "Paste Special"  ,
    "New Form"     , "Insert Picture"  , "kcharselect", "mythfrontend" , "plasmoidviewer"
}

-- Make the matching clients (by classes) on top of the default layout
tyrannical.properties.ontop = {
    "Xephyr"       , "ksnapshot"       , "kruler"
}

-- Force the matching clients (by classes) to be centered on the screen on init
tyrannical.properties.placement = {
    kcalc = awful.placement.centered
}
tyrannical.properties.centered = {
    "kcalc" , "Qalculate-gtk" , "Pavucontrol", "ncmpcpp"
}
tyrannical.settings.block_children_focus_stealing = true --Block popups ()
tyrannical.settings.group_children = true
-- }}}
