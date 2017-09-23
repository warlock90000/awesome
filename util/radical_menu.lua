local radical    = require("radical")
local beautiful  = require("beautiful")
local wibox      = require("wibox")

local apps       = "/home/jacka/.icons/nouveKDEGray/256x256/apps/"
local devices    = "/home/jacka/.icons/nouveKDEGray/256x256/devices/"
local mimetypes  = "/home/jacka/.icons/nouveKDEGray/256x256/mimetypes/"
local actions    = "/home/jacka/.icons/nouveKDEGray/256x256/actions/"
local emblems    = "/home/jacka/.icons/nouveKDEGray/256x256/emblems/"
local places     = "/home/jacka/.icons/nouveKDEGray/256x256/places/"
local categories = "/home/jacka/.icons/nouveKDEGray/256x256/categories/"

local customMenu = require( "customMenu" )
local app_menu   = nil
local main_menu  = radical.context {
        style      = radical.style.arrow,
        arrow_type = 0,
        item_style = radical.item.style.classic ,
        width  = 200,
        layout = radical.layout.vertical, --horizontal,
        --border_width = 2,
        --border_color = "#88aa00",
        spacing  = 3,
        item_layout = radical.layout.centerred
    }
main_menu.margins.left = 12
main_menu:add_item {
    text     = beautiful.apps_title or "Apps",
    bg_used  = beautiful.bar_bg_buttons or beautiful.menu_bg_normal,
    --spacing  = 4,
    icon = categories.."gnome-applications.png",
    sub_menu = function()
        if not app_menu then
            app_menu = customMenu.appmenu (
            { -- Main menu
                max_items   = 20,
                style       = beautiful.button_menu_style or radical.style.arrow,
                item_style  = beautiful.button_menu_menu_item_style or radical.item.style.classic,
            }
           ,{ -- Sub menus
                max_items   = 20,
                style       = beautiful.button_menu_style or radical.style.arrow,
                item_style  = beautiful.button_menu_menu_item_style or radical.item.style.classic
            })
        end
        return app_menu
    end
}


main_menu:add_item{text="Wine",icon = apps.."gnome-gnibbles.png", sub_menu = function()
  local smenu = radical.context{}
    smenu:add_item{text="TC_Aion",icon = apps.."gnome-gnibbles.png", button1 = function() awful.util.spawn(script .. "tc_aion"); smenu.visible = false end}
    smenu:add_item{text="TC",icon = apps.."gnome-gnibbles.png", button1 = function() awful.util.spawn(script .. "tc"); smenu.visible = false end}
    smenu:add_item{text="Photoshop CS6 x32",icon = apps.."calligrakrita.png", button1 = function() awful.util.spawn(script .. "p_shop"); smenu.visible = false end}
    smenu:add_item{text="Aion",icon = apps.."gnome-gnibbles.png", button1 = function() awful.util.spawn(script .. "aion"); smenu.visible = false end}
    --smenu:add_item{text="Tera",icon = apps.."gnome-gnibbles.png", button1 = function() awful.util.spawn(script .. "tera"); smenu.visible = false end}
    smenu:add_item{text="Tera x32",icon = apps.."gnome-gnibbles.png", button1 = function() awful.util.spawn(script .. "tera x32"); smenu.visible = false end}
    smenu:add_item{text="Tera x64",icon = apps.."gnome-gnibbles.png", button1 = function() awful.util.spawn(script .. "tera x64"); smenu.visible = false end}
    smenu:add_item{text="Rift x32",icon = apps.."gnome-gnibbles.png", button1 = function() awful.util.spawn(script .. "rift x32"); smenu.visible = false end}
    smenu:add_item{text="Rift x64",icon = apps.."gnome-gnibbles.png", button1 = function() awful.util.spawn(script .. "rift x64"); smenu.visible = false end}
    smenu:add_item{text="Revelation",icon = apps.."gnome-gnibbles.png", button1 = function() awful.util.spawn(script .. "revel rus"); smenu.visible = false end}
    smenu:add_item{text="Cancel", icon = emblems.."emblem-noread.png", button1 = function() smenu.visible = false end}
    return smenu
  end}
main_menu:add_item{text="ACE Stream",icon = devices.."computer.png", sub_menu = function()
  local smenu = radical.context{}
    smenu:add_item{text="детские", icon = mimetypes.."video-x-matroska.png", button1 = function() awful.util.spawn("acestreamplayer http://super-pomoyka.us.to/trash/ttv-list/ttv.child.player.m3u"); smenu.visible = false end}
    smenu:add_item{text="общие", icon = mimetypes.."video-x-matroska.png",button1 = function() awful.util.spawn("acestreamplayer http://super-pomoyka.us.to/trash/ttv-list/ttv.common.player.m3u"); smenu.visible = false end}
    smenu:add_item{text="познавательные", icon = mimetypes.."video-x-matroska.png",button1 = function() awful.util.spawn("acestreamplayer http://super-pomoyka.us.to/trash/ttv-list/ttv.discover.player.m3u"); smenu.visible = false end}
    smenu:add_item{text="развлекательные", icon = mimetypes.."video-x-matroska.png",button1 = function() awful.util.spawn("acestreamplayer http://super-pomoyka.us.to/trash/ttv-list/ttv.ent.player.m3u"); smenu.visible = false end}
    smenu:add_item{text="фильмы", icon = mimetypes.."video-x-matroska.png",button1 = function() awful.util.spawn("acestreamplayer http://super-pomoyka.us.to/trash/ttv-list/ttv.film.player.m3u"); smenu.visible = false end}
    smenu:add_item{text="музыкальные", icon = mimetypes.."video-x-matroska.png",button1 = function() awful.util.spawn("acestreamplayer http://super-pomoyka.us.to/trash/ttv-list/ttv.music.player.m3u"); smenu.visible = false end}
    smenu:add_item{text="новости", icon = mimetypes.."video-x-matroska.png",button1 = function() awful.util.spawn("acestreamplayer http://super-pomoyka.us.to/trash/ttv-list/ttv.news.player.m3u"); smenu.visible = false end}
    smenu:add_item{text="HD", icon = mimetypes.."video-x-matroska.png",button1 = function() awful.util.spawn("acestreamplayer http://super-pomoyka.us.to/trash/ttv-list/ttv.HD.player.m3u"); smenu.visible = false end}
    smenu:add_item{text="Cancel", icon = emblems.."emblem-noread.png", button1 = function() smenu.visible = false end}

    return smenu
  end}
main_menu:add_item {text="Exit",icon = actions.."system-shutdown.png", sub_menu = function()
  local smenu = radical.context{}
    smenu:add_item{text="Shutdown", icon = actions.."system-shutdown.png", button1 = function() awful.util.spawn("systemctl poweroff"); smenu.visible = false end}
    smenu:add_item{text="Reboot", icon = actions.."system-reboot.png", button1 = function() awful.util.spawn("systemctl reboot"); smenu.visible = false end}
    smenu:add_item{text="Suspend", icon = actions.."system-suspend.png", button1 = function() awful.util.spawn("systemctl suspend"); smenu.visible = false end}
    smenu:add_item{text="Sleep", icon = actions.."system-suspend-hibernate.png", button1 = function() awful.util.spawn("systemctl hybrid-sleep"); smenu.visible = false end}
    smenu:add_item{text="Cancel", icon = emblems.."emblem-noread.png", button1 = function() smenu.visible = false end}
    return smenu
  end}
main_menu:add_item{text="Cancel",icon = emblems.."emblem-noread.png", button1 = function() main_menu.visible = false end}

START_btn = wibox.widget.imagebox()
START_btn.image = places.."archlinux-logo.png"
START_btn.menu = main_menu



--[[
local exit_dialog = radical.box
  {
    item_width=62,
    item_height=32,
    style = radical.style.classic,
    border_width = 2,
    layout = radical.layout.horizontal,
    item_layout = radical.layout.centerred,
    item_style = radical.item.style.basic,
    autodiscard = false
  }

  exit_dialog.margins.top = 3
  exit_dialog.margins.bottom = 3

  exit_dialog:add_item{text="Shutdown", button1 = function() awful.util.spawn("systemctl poweroff") end}
  exit_dialog:add_item{text="Reboot", button1 = function() awful.util.spawn("systemctl reboot") end}
  exit_dialog:add_item{text="Suspend", button1 = function() awful.util.spawn("systemctl suspend") end}
  exit_dialog:add_item{text="Sleep", button1 = function() awful.util.spawn("systemctl hybrid-sleep") end}
  exit_dialog:add_item{text="Cancel", button1 = function() exit_dialog.visible = false end}

local exit_menu = radical.context {
        style      = radical.style.classic      ,
        item_style = radical.item.style.arrow_prefix ,
        item_height = 18,--48,
        width = 140,
        layout = radical.layout.vertical, --horizontal,
        border_width = 2,
        border_color = "#88aa00",
        item_layout = radical.layout.centerred
    }
  exit_menu:add_item{text="Shutdown", button1 = function() awful.util.spawn("systemctl poweroff") end}
  exit_menu:add_item{text="Reboot", button1 = function() awful.util.spawn("systemctl reboot") end}
  exit_menu:add_item{text="Suspend", button1 = function() awful.util.spawn("systemctl suspend") end}
  exit_menu:add_item{text="Sleep", button1 = function() awful.util.spawn("systemctl hybrid-sleep") end}
  exit_menu:add_item{text="Cancel", button1 = function() exit_menu.visible = false end}
]]--