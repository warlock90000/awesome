local theme                                     = {}

theme.confdir                                   = os.getenv("HOME") .. "/.config/awesome/themes/multicolor"
--theme.wallpaper                                 = theme.confdir .. "/wall1.png"
theme.wallpaper_dir                             = "/home/jacka/Pictures/art/-=COSPLAY=-/disharmonica.deviantart.com/1"
theme.wallpaper                                 = theme.wallpaper_dir .. "/the_witcher___triss_merigold_cosplay_by_dzikan-dantbho.jpg"

theme.font                                      = "Terminus Re33 Bold 12"
theme.tooltip_font                              = "Terminus Re33 Bold 14"

theme.bg_normal                                 = "#000000"
theme.bg_focus                                  = "#3d3d3eb5"
theme.bg_urgent                                 = "#000000"
theme.fg_normal                                 = "#aaaaaa"
theme.fg_focus                                  = "#aaaaaa"
theme.fg_urgent                                 = "#af1d18"
theme.fg_minimize                               = "#ffffff"
theme.border_width                              = 1
theme.border_normal                             = "#1c2022"
theme.border_focus                              = "#606060"
theme.border_marked                             = "#3ca4d8"

theme.launcher_icon                             = theme.confdir .. "/icons/awesome.png"
theme.menu_border_width                         = 2
theme.menu_width                                = 230
theme.menu_submenu_icon                         = theme.confdir .. "/icons/submenu.png"
theme.menu_fg_normal                            = "#C7C7C7" -- 67aead
theme.menu_fg_focus                             = "#155D93"
theme.menu_bg_normal                            = "#3d3d3e"
theme.menu_bg_focus                             = "#202020"

theme.tooltip_bg                                = "#3d3d3eb5"
theme.widget_bg                                 = "#3d3d3eb5" -- 155D93b5
theme.widget_bg1                                = "#3d3d3e0f" -- 3d3d3ee0
theme.widget_bg2                                = "#535355FF"
theme.widget_font_color                         = "#ffffff" -- 67aead
theme.clock_font_color                          = "#de5e1e"

theme.fg_widget                                 = "#969696" -- 00B52A
theme.fg_center_widget                          = "#B87912" -- B87912
theme.fg_end_widget                             = "#B81D08" -- B81D08

theme.base03                                    = "#202020" -- 155D93 323232 темн
theme.base02                                    = "#383d3d" -- 073642 свет, 3d3d3e
theme.base01                                    = "#586e75"
theme.base00                                    = "#657b83"
theme.base0                                     = "#839496"
theme.base1                                     = "#93a1a1"
theme.base2                                     = "#eee8d5"
theme.base3                                     = "#fdf6e3"
theme.yellow                                    = "#b58900"
theme.orange                                    = "#cb4b16"
theme.red                                       = "#dc322f"
theme.magenta                                   = "#d33682"
theme.violet                                    = "#6c71c4"
theme.blue                                      = "#268bd2"
theme.cyan                                      = "#2aa198"
theme.green                                     = "#859900"


theme.taglist_squares_sel                       = theme.confdir .. "/icons/square_a.png"
theme.taglist_squares_unsel                     = theme.confdir .. "/icons/square_b.png"

theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true

theme.useless_gap                               = 0

theme.layout_tile                               = theme.confdir .. "/icons/tile.png"
theme.layout_tilegaps                           = theme.confdir .. "/icons/tilegaps.png"
theme.layout_tileleft                           = theme.confdir .. "/icons/tileleft.png"
theme.layout_tilebottom                         = theme.confdir .. "/icons/tilebottom.png"
theme.layout_tiletop                            = theme.confdir .. "/icons/tiletop.png"
theme.layout_fairv                              = theme.confdir .. "/icons/fairv.png"
theme.layout_fairh                              = theme.confdir .. "/icons/fairh.png"
theme.layout_spiral                             = theme.confdir .. "/icons/spiral.png"
theme.layout_dwindle                            = theme.confdir .. "/icons/dwindle.png"
theme.layout_max                                = theme.confdir .. "/icons/max.png"
theme.layout_fullscreen                         = theme.confdir .. "/icons/fullscreen.png"
theme.layout_magnifier                          = theme.confdir .. "/icons/magnifier.png"
theme.layout_floating                           = theme.confdir .. "/icons/floating.png"
theme.layout_cornernw                           = theme.confdir .. "/icons/cornernww.png"
theme.layout_cornerne                           = theme.confdir .. "/icons/cornernew.png"
theme.layout_cornersw                           = theme.confdir .. "/icons/cornersww.png"
theme.layout_cornerse                           = theme.confdir .. "/icons/cornersew.png"

theme.shutdown                                  = theme.confdir .. "/icons/shutdown.png"
theme.restart                                   = theme.confdir .. "/icons/restart.png"
theme.suspend                                   = theme.confdir .. "/icons/suspend.png"
theme.sleep                                     = theme.confdir .. "/icons/suspend.png"
theme.cancel                                    = theme.confdir .. "/icons/cancel.png"

theme.widget_note_on                            = theme.confdir .. "/icons/note_on.png"

theme.titlebar_close_button_normal              = theme.confdir .. "/icons/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = theme.confdir .. "/icons/titlebar/close_focus.png"
theme.titlebar_minimize_button_normal           = theme.confdir .. "/icons/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus            = theme.confdir .. "/icons/titlebar/minimize_focus.png"
theme.titlebar_ontop_button_normal_inactive     = theme.confdir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = theme.confdir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = theme.confdir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = theme.confdir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_sticky_button_normal_inactive    = theme.confdir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = theme.confdir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = theme.confdir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = theme.confdir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_floating_button_normal_inactive  = theme.confdir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = theme.confdir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = theme.confdir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = theme.confdir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_maximized_button_normal_inactive = theme.confdir .. "/icons/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme.confdir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = theme.confdir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = theme.confdir .. "/icons/titlebar/maximized_focus_active.png"

return theme