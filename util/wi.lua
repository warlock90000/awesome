local gears      = require("gears")
local awful      = require("awful")
                   require("awful.autofocus")
local wibox      = require("wibox")
local beautiful  = require("beautiful")
local naughty    = require("naughty")
local lain       = require("lain")
local helpers    = require("lain.helpers")
local vicious    = require("vicious")

local markup     = lain.util.markup

local color1     = "<span color=\"#87af5f\">"
local color2     = "<span color=\"#e54c62\">"
local color3     = "<span color=\"#ffffff\">"
local color4     = "<span color=\"#67aead\">"
local color5     = "<span color=\"#4682b4\">"
local color6     = "<span color=\"#bf3eff\">"
local color7     = "<span color=\"#00B52A\">"
local color8     = "<span color=\"#B87912\">"

local font1      = "<span font=\"Terminus Re33 Bold 13\">"
local font2      = "<span font=\"Terminus Re33 Bold 10\">"
local font3      = "<span font=\"Terminus Re33 Bold 11\">"
local font4      = "<span font=\"Terminus Re33 Bold 12\">"
local span_end   = "</span>"

function math_round( roundIn , roundDig ) -- первый аргумент - число которое надо округлить, второй аргумент - количество символов после запятой.
     local mul = math.pow( 10, roundDig )
     return ( math.floor( ( roundIn * mul ) + 0.5 )/mul )
end

-- {{{ Keyboard layout widget
kbdcfg = {}
kbdcfg.image        = wibox.widget.imagebox()
kbdcfg.layout       = { "us", "ru" }
kbdcfg.current      = 1
kbdcfg.images       = { awful.util.getdir("config") .. "/themes/multicolor/icons/lang/icon_lang_en.png",
                        awful.util.getdir("config") .. "/themes/multicolor/icons/lang/icon_lang_ru.png" }
kbdcfg.image:set_image(awful.util.getdir("config") .. "/themes/multicolor/icons/lang/icon_lang_en.png")
dbus.request_name("session", "ru.gentoo.kbdd")
dbus.add_match("session", "interface='ru.gentoo.kbdd',member='layoutChanged'")
dbus.connect_signal("ru.gentoo.kbdd", function(...)
    kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
    kbdcfg.image:set_image(kbdcfg.images[kbdcfg.current])
    end
)
-- }}}
--========= base =========--
sys    = wibox.widget.textbox()
vicious.register(sys, vicious.widgets.os, color5.."$1 $2"..span_end, 600)
uptime = wibox.widget.textbox()
vicious.register(uptime, vicious.widgets.uptime,
    function (widget, args)
      return string.format(color6.."Up: %2dd %02dh:%02dm "..span_end, args[1], args[2], args[3])
    end, 61)
--========= base =========--
--========= Textclock =========--
mytextclock = wibox.widget.textclock(markup.font("Terminus Re33 Bold 18", markup(beautiful.clock_font_color, " %H:%M ")))
myclock_t   = awful.tooltip({
         objects          = { mytextclock },
         delay_show       = 0,
         margin_leftright = 15,
         margin_topbottom = 14,
         timer_function   = function()
            return os.date(markup.font("Terminus Re33 Bold 18", markup(beautiful.clock_font_color, "%A %d %B %Y")))
          end,
})
myclock_t:set_shape(function(cr, width, height)
    gears.shape.infobubble(cr, width, height, corner_radius, arrow_size, width - 75)
end)
  --========= Calendar =========--
lain.widget.calendar({
    attach_to = { mytextclock },
    notification_preset = {
        font = "Terminus Re33 Bold 13",
        bg   = beautiful.widget_bg
}})
  --========= Calendar =========--
--========= Textclock =========--
--========= Weather =========--ConkyWeather bold 11
myweather = lain.widget.weather({
    city_id = 520494,
    weather_na_markup = markup(beautiful.widget_font_color, "N/A "),
    notification_preset = { font = "Terminus Re33 Bold 13", bg = beautiful.widget_bg },
    settings = function()
        descr = weather_now["weather"][1]["description"]:lower()
        units = math.floor(weather_now["main"]["temp"])
        icons = weather_now["weather"][1]["icon"] .. ".png"
        --widget:set_markup(markup.font("Hack 9", markup(beautiful.widget_font_color, " " .. descr .. " | " .. units .. "°C ")))
        widget:set_markup(markup.font("Terminus Re33 Bold 13", markup(beautiful.widget_font_color, " " .. units .. "°C ")))
    end
})
--========= Weather =========--
--========= fs =========--
vicious.cache(vicious.widgets.dio)
vicious.cache(vicious.widgets.fs)
--[[
hdd_temp = awful.widget.watch("hddtemp /dev/sdb | awk '{print $3}'", 60,
  function(widget, stdout)
    widget:set_markup(markup.font("Terminus Re33 Bold 11", markup("#00B52A", stdout)))
    return
  end)
]]--
fstext_r = wibox.widget {
    color            = beautiful.fg_normal,
    background_color = beautiful.bg_normal,
    font             = "Terminus Re33 Bold 11",
    widget           = wibox.widget.textbox,
}

fsbar_r  = wibox.widget {
    forced_height    = 15,
    forced_width     = 298,
    background_color = beautiful.widget_bg,
    color            = ({
                          type  = "linear",
                          from  = { 0, 0 },
                          to    = { 298, 0 },
                          stops = {
                            { 0, beautiful.fg_widget },
                            { 0.75, beautiful.fg_center_widget },
                            { 1, beautiful.fg_end_widget }
                                  }
                       }),
    margins          = 3,
    paddings         = 1,
    ticks            = true,
    ticks_size       = 6,
    widget           = wibox.widget.progressbar,
}

fstext_h = wibox.widget {
    color            = beautiful.fg_normal,
    background_color = beautiful.bg_normal,
    font             = "Terminus Re33 Bold 11",
    widget           = wibox.widget.textbox,
}

fsbar_h = wibox.widget {
    forced_height    = 15,
    forced_width     = 298,
    background_color = beautiful.widget_bg,
    color            = ({
                          type  = "linear",
                          from  = { 0, 0 },
                          to    = { 298, 0 },
                          stops = {
                            { 0, beautiful.fg_widget },
                            { 0.75, beautiful.fg_center_widget },
                            { 1, beautiful.fg_end_widget }
                                  }
                       }),
    margins          = 3,
    paddings         = 1,
    ticks            = true,
    ticks_size       = 6,
    widget           = wibox.widget.progressbar,
}

fs_r = lain.widget.fs({
    partition = "/", options = "--exclude-type=tmpfs",
    settings  = function()
        fstext_r:set_markup(""..color2.." Root "..span_end..color7..fs_now.used_gb..span_end.."/"..color8..fs_now.available_gb..span_end)
        fsbar_r:set_value(fs_now.used / 100)
    end
})
fs_h = lain.widget.fs({
    partition = "/home", options = "--exclude-type=tmpfs",
    settings  = function()
        fstext_h:set_markup(""..color2.." Home "..span_end..color7..fs_now.used_gb..span_end.."/"..color8..fs_now.available_gb..span_end)
        fsbar_h:set_value(fs_now.used / 100)
    end
})
--[[
vicious.register(fstext_r, vicious.widgets.fs,
            function (widget, args)
              fstext_r:set_text(' / '..tostring(args["{/ used_gb}"])..'/' .. tostring(args["{/ avail_gb}"])..'Gb')
              fsbar_r:set_max_value(tonumber(args["{/ size_gb}"]))
              fsbar_r:set_value(tonumber(args["{/ used_gb}"]))
              fstext_h:set_text(' /Home '..tostring(args["{/home used_gb}"])..'/' .. tostring(args["{/home avail_gb}"])..'Gb')
              fsbar_h:set_max_value(tonumber(args["{/home size_gb}"]))
              fsbar_h:set_value(tonumber(args["{/home used_gb}"]))
            end, 60)
]]--

fs_stat_graph_r_read = wibox.widget {
            forced_height    = 25,
            forced_width     = 57,
            step_width       = 2,
            step_spacing     = 1,
            step_shape       = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 2)
            end,
            border_color     = beautiful.widget_bg,
            background_color = beautiful.widget_bg,
            color            = ({
                                  type  = "linear",
                                  from  = { 0, 25 },
                                  to    = { 0, 0 },
                                  stops = {
                                    { 0, beautiful.fg_widget },
                                    { 0.75, beautiful.fg_center_widget },
                                    { 1, beautiful.fg_end_widget }
                                  }
                                }),
            widget           = wibox.widget.graph,
}
fs_stat_graph_r_write = wibox.widget {
            forced_height    = 25,
            forced_width     = 57,
            step_width       = 2,
            step_spacing     = 1,
            step_shape       = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 2)
            end,
            border_color     = beautiful.widget_bg,
            background_color = beautiful.widget_bg,
            color            = ({
                                  type  = "linear",
                                  from  = { 0, 25 },
                                  to    = { 0, 0 },
                                  stops = {
                                    { 0, beautiful.fg_widget },
                                    { 0.75, beautiful.fg_center_widget },
                                    { 1, beautiful.fg_end_widget }
                                  }
                                }),
            widget           = wibox.widget.graph,
}
fs_stat_graph_h_read = wibox.widget {
            forced_height    = 25,
            forced_width     = 57,
            step_width       = 2,
            step_spacing     = 1,
            step_shape       = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 2)
            end,
            border_color     = beautiful.widget_bg,
            background_color = beautiful.widget_bg,
            color            = ({
                                  type  = "linear",
                                  from  = { 0, 25 },
                                  to    = { 0, 0 },
                                  stops = {
                                    { 0, beautiful.fg_widget },
                                    { 0.75, beautiful.fg_center_widget },
                                    { 1, beautiful.fg_end_widget }
                                  }
                                }),
            widget           = wibox.widget.graph,
}
fs_stat_graph_h_write = wibox.widget {
            forced_height    = 25,
            forced_width     = 57,
            step_width       = 2,
            step_spacing     = 1,
            step_shape       = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 2)
            end,
            border_color     = beautiful.widget_bg,
            background_color = beautiful.widget_bg,
            color            = ({
                                  type  = "linear",
                                  from  = { 0, 25 },
                                  to    = { 0, 0 },
                                  stops = {
                                    { 0, beautiful.fg_widget },
                                    { 0.75, beautiful.fg_center_widget },
                                    { 1, beautiful.fg_end_widget }
                                  }
                                }),
            widget           = wibox.widget.graph,
}

vicious.register(fs_stat_graph_r_read, vicious.widgets.dio,
            function (widget, args)
              fs_stat_graph_r_read:add_value(tonumber(args["{sdb7 read_kb}"]))
              fs_stat_graph_r_write:add_value(tonumber(args["{sdb7 write_kb}"]))
              fs_stat_graph_h_read:add_value(tonumber(args["{sdb3 read_kb}"]))
              fs_stat_graph_h_write:add_value(tonumber(args["{sdb3 write_kb}"]))
            end, 3)
--========= fs =========--
--========= CPU =========--
vicious.cache(vicious.widgets.cpu)
vicious.cache(vicious.widgets.cpufreq)

cpufreq_vicious = wibox.widget.textbox()
vicious.register(cpufreq_vicious, vicious.widgets.cpufreq,
  function (widget,args)
    cpufreq_vicious:set_text(args[5].." "..math.floor(args[1]).."Mhz")
  end , 5, "cpu0")
temp_mb = wibox.widget{
      widget = wibox.widget.textbox,
      font   = "Terminus Re33 Bold 11",
}
temp_gpu = wibox.widget{
      widget = wibox.widget.textbox,
      font   = "Terminus Re33 Bold 11",
}

temp_cpu = lain.widget.temp({
    tempfile = "/sys/class/hwmon/hwmon2/temp1_input",
    settings = function()
        widget:set_markup(markup.font("Terminus Re33 Bold 11", " "..color2.."CPU "..span_end..color7..coretemp_now .. "°C"..span_end))
    end
})
mb = lain.widget.temp({
    tempfile = "/sys/class/hwmon/hwmon1/temp1_input",
    settings = function()
        temp_mb:set_markup(color1.."MB "..span_end..color7..coretemp_now .. "°C"..span_end)
    end
})
gpu = lain.widget.temp({
    tempfile = "/sys/class/hwmon/hwmon0/temp1_input",
    settings = function()
        temp_gpu:set_markup(color8.."GPU "..span_end..color7..coretemp_now .. "°C"..span_end)
    end
})

cpu_txt = wibox.widget{
      markup = color2 .. "  CPU1     CPU2     CPU3     CPU4" .. span_end,
      widget = wibox.widget.textbox,
      font   = "Terminus Re33 Bold 11",
}
cpu = wibox.widget{
      widget = wibox.widget.textbox,
      font   = "Terminus Re33 Bold 11",
}

cpupct0   = wibox.widget.textbox()
cpugraph0 = wibox.widget {
            forced_height    = 25,
            forced_width     = 50,
            max_value        = 100,
            step_width       = 2,
            step_spacing     = 1,
            step_shape       = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 2)
            end,
            border_color     = beautiful.widget_bg,
            background_color = beautiful.widget_bg,
            color            = ({
                                  type  = "linear",
                                  from  = { 0, 25 },
                                  to    = { 0, 0 },
                                  stops = {
                                    { 0, beautiful.fg_widget },
                                    { 0.55, beautiful.fg_center_widget },
                                    { 1, beautiful.fg_end_widget }
                                  }
                                }),
            widget           = wibox.widget.graph,
}

cpupct1   = wibox.widget.textbox()
cpugraph1 = wibox.widget {
            forced_height    = 25,
            forced_width     = 50,
            max_value        = 100,
            step_width       = 2,
            step_spacing     = 1,
            step_shape       = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 2)
            end,
            border_color     = beautiful.widget_bg,
            background_color = beautiful.widget_bg,
            color            = ({
                                  type  = "linear",
                                  from  = { 0, 25 },
                                  to    = { 0, 0 },
                                  stops = {
                                    { 0, beautiful.fg_widget },
                                    { 0.55, beautiful.fg_center_widget },
                                    { 1, beautiful.fg_end_widget }
                                          }
                                }),
            widget        = wibox.widget.graph,
}

cpupct2   = wibox.widget.textbox()
cpugraph2 = wibox.widget {
            forced_height    = 25,
            forced_width     = 50,
            max_value        = 100,
            step_width       = 2,
            step_spacing     = 1,
            step_shape       = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 2)
            end,
            border_color     = beautiful.widget_bg,
            background_color = beautiful.widget_bg,
            color            = ({
                                  type  = "linear",
                                  from  = { 0, 25 },
                                  to    = { 0, 0 },
                                  stops = {
                                    { 0, beautiful.fg_widget },
                                    { 0.55, beautiful.fg_center_widget },
                                    { 1, beautiful.fg_end_widget }
                                          }
                                }),
            widget           = wibox.widget.graph,
}

cpupct3   = wibox.widget.textbox()
cpugraph3 = wibox.widget {
            forced_height    = 25,
            forced_width     = 50,
            max_value        = 100,
            step_width       = 2,
            step_spacing     = 1,
            step_shape       = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 2)
            end,
            border_color     = beautiful.widget_bg,
            background_color = beautiful.widget_bg,
            color            = ({
                                  type  = "linear",
                                  from  = { 0, 25 },
                                  to    = { 0, 0 },
                                  stops = {
                                    { 0, beautiful.fg_widget },
                                    { 0.55, beautiful.fg_center_widget },
                                    { 1, beautiful.fg_end_widget }
                                          }
                                }),
            widget        = wibox.widget.graph,
}
vicious.register(cpupct3, vicious.widgets.cpu,
            function (widget, args)
              cpu:set_text("  " .. args[1] .. "% ")
              cpupct0:set_text(tostring(args[2]).."%")
              cpugraph0:add_value(tonumber(args[2]))
              cpupct1:set_text(tostring(args[3]).."%")
              cpugraph1:add_value(tonumber(args[3]))
              cpupct2:set_text(tostring(args[4]).."%")
              cpugraph2:add_value(tonumber(args[4]))
              cpupct3:set_text(tostring(args[5]).."%")
              cpugraph3:add_value(tonumber(args[5]))
            end, 3)

process_htop = awful.widget.watch("bash -c '/bin/ps --sort -c,-s -eo fname,user,%cpu,%mem,pid | /usr/bin/head'", 7)
  process_htop:set_font("Terminus Re33 Bold 11")
--========= CPU =========
--========= Mem =========--
vicious.cache(vicious.widgets.mem)

mem_txt = wibox.widget {
        widget = wibox.widget.textbox,
        font = "Terminus Re33 Bold 11",
  }

mem_graph = wibox.widget {
            forced_height    = 15,
            forced_width     = 298,
            background_color = beautiful.widget_bg,
            margins          = 1,
            paddings         = 1,
            ticks            = true,
            ticks_size       = 6,
            widget           = wibox.widget.progressbar,
}

vicious.register(mem_graph, vicious.widgets.mem,
  function (widget,args)
      mem_txt:set_markup(" "..color2.." Use:"..span_end..color7..tostring(args[2]).."Mb"..span_end..color1.." Free:"..span_end..color7..tostring(args[4]).."Mb"..span_end..color8.." Tot:"..span_end..color7..tostring(args[3]).."Mb"..span_end)
          mem_graph:set_color({
                                type  = "linear",
                                from  = { 0, 0 },
                                to    = { 298, 0 },
                                stops = {
                                  { 0, beautiful.fg_widget },
                                  { 0.75, beautiful.fg_center_widget },
                                  { 1, beautiful.fg_end_widget }
                                        }
                               })
          return args[1]
  end , 5 )
--========= Mem =========--
--========= Audio =========--
--[[
volumewidget = wibox.widget{
      markup        = pulseaudio.volume_info_c(),
      widget        = wibox.widget.textbox,
      font          = "Terminus Re33 Bold 13",
}
volumewidget1 = wibox.widget{
      max_value     = 112,
      forced_height = 20,
      forced_width  = 70,
      bar_shape     = gears.shape.rounded_rect,
      bar_height    = 3,
      bar_color     = beautiful.base03,
      handle_color  = beautiful.widget_font_color,
      handle_shape  = gears.shape.circle,
      value         = pulseaudio.volume_info_for_bar(),
      widget        = wibox.widget.slider,
}

volumewidget1:buttons(awful.util.table.join(
  awful.button({ }, 2, function() pulseaudio.volume_mute(); volumewidget1.value = pulseaudio.volume_info_for_bar(); volumewidget.markup = pulseaudio.volume_info_c() end),
  awful.button({ }, 3, function() awful.util.spawn("pavucontrol") end),
  awful.button({ }, 4, function() pulseaudio.volume_change("+3db"); volumewidget1.value = pulseaudio.volume_info_for_bar(); volumewidget.markup = pulseaudio.volume_info_c() end),
  awful.button({ }, 5, function() pulseaudio.volume_change("-3db"); volumewidget1.value = pulseaudio.volume_info_for_bar(); volumewidget.markup = pulseaudio.volume_info_c() end)
))

volumetimer = timer({ timeout = 31 })
volumetimer:connect_signal("timeout", function() volumewidget.markup = pulseaudio.volume_info_c() end)
volumetimer:start()
volumetimer1 = timer({ timeout = 31 })
volumetimer1:connect_signal("widget::redraw_needed", function() volumewidget1.value = pulseaudio.volume_info_for_bar() end)
volumetimer1:start()
]]--
soundicon = wibox.widget{
    font                = "Terminus Re33 Bold 13",
    widget              = wibox.widget.textbox
}
-- Pulsebar
volume = lain.widget.pulsebar({
    ticks               = true,
    ticks_size          = 6,
    notification_preset = { font = "Terminus Re33 Bold 13" },

    settings = function()
      if (not volume_now.muted and volume_now.left == 0) or volume_now.muted == "no" then
          if tonumber(volume_now.left) >= 67 then
              soundicon:set_markup(markup.fontfg(beautiful.font, beautiful.widget_font_color, " "..volume_now.left .. "%"))
          elseif tonumber(volume_now.left) >= 33 and tonumber(volume_now.left) <= 66 then
              soundicon:set_markup(markup.fontfg(beautiful.font, beautiful.widget_font_color, "🔉 "..volume_now.left .. "%"))
          else
              soundicon:set_markup(markup.fontfg(beautiful.font, beautiful.widget_font_color, "🔈 "..volume_now.left .. "%"))
          end
          else
            soundicon:set_markup(markup.fontfg(beautiful.font, "#EB8F8F", "🔇 muted"))
      end
    end
})
volume.tooltip.wibox.fg   = beautiful.widget_bg
volume.tooltip.wibox.font = beautiful.font
volume.bar:set_width(60)
volume.bar:set_height(6)
volume.bar:buttons(awful.util.table.join(
    awful.button({}, 1, function() -- left click
        awful.spawn("pavucontrol")
    end),
    awful.button({}, 2, function() -- middle click
        awful.spawn(string.format("pactl set-sink-volume %d 100%%", volume.sink))
        volume.update()
  volume.notify()
    end),
    awful.button({}, 3, function() -- right click
        awful.spawn(string.format("pactl set-sink-mute %d toggle", volume.sink))
        volume.update()
  volume.notify()
    end),
    awful.button({}, 4, function() -- scroll up
        awful.spawn(string.format("pactl set-sink-volume %d +2%%", volume.sink))
        volume.update()
  volume.notify()
    end),
    awful.button({}, 5, function() -- scroll down
        awful.spawn(string.format("pactl set-sink-volume %d -2%%", volume.sink))
        volume.update()
  volume.notify()
    end)
))
--========= Audio =========--
--========= PKG =========--
local capi = {
    mouse  = mouse,
    screen = screen
}
local b = "<span color=\"#67aead\">"
local e = "</span>"
local function display()
    local lines = "<u><b>Pacman Updates:</b></u>\n"
    local cmd = [[zsh -c '~/.config/awesome/util/script/pacm.sh pack_name']]
    awful.spawn.easy_async(cmd, function(stdout)
        local s = stdout
    line = lines .. "\n" .. b .. s .. e .."\n"
    end)
    return line
end
display()

pkg_upd_icons = wibox.widget.textbox()

pkg_upd_icons:set_markup(markup.font("PacFont Bold 11", markup(beautiful.widget_font_color, "C--- ")))
pkg_upd_icons:connect_signal('mouse::enter', function ()
      usage         = naughty.notify({
      text          = string.format('<span font_desc="%s">%s</span>', "Terminus Re33 Bold 13", display()),
      timeout       = 10,
      position      = "top_right",
      bg            = beautiful.widget_bg,
      screen        = capi.mouse.screen
    })
  end)

pkg_upd_icons:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.spawn.with_shell('uxterm -geometry 90x10 -T Updating -e bash -c "sudo yaourt -Sy && pauseme"') end),
    awful.button({ }, 3, function () awful.spawn.with_shell('urxvt -T Updating -e bash -c "sudo yaourt -Sua && pauseme"') end)
))

pkg_upd_count = awful.widget.watch('zsh -c "~/.config/awesome/util/script/pacm.sh pack_count"', 600,
  function(widget, stdout)
      if tonumber(stdout) > 0 then
        widget:set_markup(markup.font("Terminus Re33 Bold 13", markup(beautiful.red, stdout)))
      else
        widget:set_markup(markup.font("Terminus Re33 Bold 13", markup(beautiful.widget_font_color, "OK")))
      end
    return
  end)
--========= PKG =========--
--========= Net =========--
vicious.cache(vicious.widgets.net)

net_vicious = wibox.widget.textbox()
vicious.register(net_vicious, vicious.widgets.net, color1.."⬇ "..span_end..font2.."${enp3s0 rx_mb}M".." ✦ ".."${enp3s0 down_kb}K"..span_end..color3.." ✦ "..span_end..color2.."⬆ "..span_end..font2.."${enp3s0 tx_mb}M".." ✦ ".."${enp3s0 up_kb}K"..span_end, 5)

net_raph_d = wibox.widget {
            forced_height     = 25,
            forced_width      = 140,
            scale             = true,
            step_width        = 2,
            step_spacing      = 0,
            step_shape        = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 2)
            end,
            border_color     = beautiful.widget_bg,
            background_color = beautiful.widget_bg,
            color            = ({
                                  type = "linear",
                                  from = { 0, 25 },
                                  to = { 0, 0 },
                                  stops = {
                                    { 0, beautiful.fg_widget },
                                    { 0.55, beautiful.fg_center_widget },
                                    { 1, beautiful.fg_end_widget }
                                          }
                                }),
            widget           = wibox.widget.graph,
}

net_raph_u = wibox.widget {
            forced_height    = 25,
            forced_width     = 140,
            scale            = true,
            step_width       = 2,
            step_spacing     = 1,
            step_shape       = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 2)
            end,
            border_color     = beautiful.widget_bg,
            background_color = beautiful.widget_bg,
            color            = ({
                                  type = "linear",
                                  from = { 0, 25 },
                                  to = { 0, 0 },
                                  stops = {
                                    { 0, beautiful.fg_widget },
                                    { 0.55, beautiful.fg_center_widget },
                                    { 1, beautiful.fg_end_widget }
                                          }
                                }),
            widget           = wibox.widget.graph,
}
vicious.register(net_raph_d, vicious.widgets.net,
            function (widget, args)
              net_raph_d:add_value(tonumber(args["{enp3s0 down_kb}"]))
              net_raph_u:add_value(tonumber(args["{enp3s0 up_kb}"]))
            end, 3)
--=======
-- vnstat_image notification
local vnstat_image        = {}
vnstat_image.notification = nil
local eth_if              = "enp3s0"
local conn_stat           = nil

function vnstat_image:hide()
    if self.notification ~= nil then
        naughty.destroy(self.notification)
        self.notification = nil
    end
end

function vnstat_image:show()
    self:hide()
    os.execute( 'LC_ALL=C vnstati -vs -ne -i ' .. eth_if .. ' -o /tmp/vnstat_summary.png' )
    local net_summary = "/tmp/vnstat_summary.png"
    self.notification = naughty.notify({
    icon              = net_summary,
    position          = 'top_left',
    timeout           = 20,
    bg                = beautiful.widget_bg,
    })
end

function vnstat_image:show1()
    self:hide()
    os.execute( 'LC_ALL=C vnstati -t -ne -i ' .. eth_if .. ' -o /tmp/vnstat_summary_h.png' )
    local net_summary_h = "/tmp/vnstat_summary_h.png"
    self.notification = naughty.notify({
    icon              = net_summary_h,
    position          = 'top_left',
    timeout           = 20,
    bg                = beautiful.widget_bg,
    })
end

function vnstat_image:show2()
    self:hide()
    local conn_stat   = [[bash -c 'lsof -i |grep ESTABLISHED']]
    awful.spawn.easy_async(conn_stat, function(stdout, stderr, reason, exit_code)
      naughty.notify {
        text          = color4 .. stdout .. span_end,
        position      = 'top_right',
        timeout       = 50,
        bg            = beautiful.widget_bg,
      }
      end)
end

function vnstat_image:show3()
    self:hide()
    local conn_stat   = [[bash -c 'vnstat -h | xargs -0 notify-send -t 0']]
    awful.spawn.easy_async(conn_stat, function(stdout, stderr, reason, exit_code)
      naughty.notify {
        text          = color4 .. stdout .. span_end,
        position      = 'top_right',
        timeout       = 50,
        bg            = beautiful.widget_bg,
      }
      end)
end

function vnstat_image:show4()
    self:hide()
    local conn_stat   = [[bash -c 'vnstat -d | xargs -0 notify-send -t 0']]
    awful.spawn.easy_async(conn_stat, function(stdout, stderr, reason, exit_code)
      naughty.notify {
        text          = color4 .. stdout .. span_end,
        position      = 'top_right',
        timeout       = 50, hover_timeout = 0.5, bg = beautiful.widget_bg,
      }
      end)
end

net_vicious:connect_signal("mouse::enter", function () vnstat_image:show() end)
net_vicious:connect_signal("mouse::leave", function () vnstat_image:hide() end)
net_vicious:buttons(awful.util.table.join(
    awful.button({ }, 1, function () vnstat_image:show1() end),
    awful.button({ }, 3, function () vnstat_image:show2() end),
    awful.button({ }, 9, function () vnstat_image:show3() end),
    awful.button({ }, 8, function () vnstat_image:show4() end)
    ))
--========= Net =========--
--========= MPD =========--
local mpdicon   = wibox.widget.imagebox()
local mpdwidget = lain.widget.mpd({
    settings    = function()
        mpd_notification_preset = {
            text = string.format("%s [%s] - %s\n%s", mpd_now.artist,
                   mpd_now.album, mpd_now.date, mpd_now.title)
        }

        if mpd_now.state == "play" then
            artist = mpd_now.artist .. " > "
            title  = mpd_now.title .. " "
            mpdicon:set_image(beautiful.widget_note_on)
        elseif mpd_now.state == "pause" then
            artist = "mpd "
            title  = "paused "
        else
            artist = ""
            title  = ""
            --mpdicon:set_image() -- not working in 4.0
            mpdicon._private.image = nil
            mpdicon:emit_signal("widget::redraw_needed")
            mpdicon:emit_signal("widget::layout_changed")
        end
        widget:set_markup(markup.font("Hack 9", markup("#e54c62", artist)) .. markup.font("Hack 9", markup("#b2b2b2", title)))
    end
})
--========= MPD =========--
--========= Balans =========--
balans_widget = awful.widget.watch("zsh -c '~/.config/awesome/util/script/balans'", 6000,
  function(widget, stdout)
    widget:set_markup(markup.font("Terminus Re33 Bold 11", markup("#00B52A", stdout)))
    return
  end)
--========= Balans =========--
--========= Ext. IP =========--
ext_ip = awful.widget.watch('wget -O - -q icanhazip.com', 600,
  function(widget, stdout)
    widget:set_markup(markup.font("Terminus Re33 Bold 11", markup("#B87912", "IP:"..stdout)))
    return
  end)
--========= Ext. IP =========--
