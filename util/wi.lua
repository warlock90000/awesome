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
local color9     = "<span color=\"#C7C7C7\">"
local color10     = "<span color=\"#969696\">"

local font1      = "<span font=\"Terminus Re33 Bold 13\">"
local font2      = "<span font=\"Terminus Re33 Bold 10\">"
local font3      = "<span font=\"Terminus Re33 Bold 11\">"
local font4      = "<span font=\"Terminus Re33 Bold 12\">"
local font_pacman = "<span font=\"PacFont Bold 11\">"
local span_end   = "</span>"

function math_round( roundIn , roundDig ) -- первый аргумент - число которое надо округлить, второй аргумент - количество символов после запятой.
     local mul = math.pow( 10, roundDig )
     return ( math.floor( ( roundIn * mul ) + 0.5 )/mul )
end

-- {{{ Keyboard layout widget
--[[
kbdcfg = {}
kbdcfg.image        = wibox.widget.imagebox()
kbdcfg.layout       = { "us", "ru" }
kbdcfg.current      = 1
kbdcfg.images       = { awful.util.getdir("config") .. "/themes/multicolor/icons/lang/icon_lang_en.png",
                        awful.util.getdir("config") .. "/themes/multicolor/icons/lang/icon_lang_ru.png" }
kbdcfg.image.image = awful.util.getdir("config") .. "/themes/multicolor/icons/lang/icon_lang_en.png"
dbus.request_name("session", "ru.gentoo.kbdd")
dbus.add_match("session", "interface='ru.gentoo.kbdd',member='layoutChanged'")
dbus.connect_signal("ru.gentoo.kbdd", function(...)
    kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
    kbdcfg.image.image = kbdcfg.images[kbdcfg.current]
    end
)
]]--
kbdcfg = {}

kbdcfg.cmd          = "setxkbmap"
kbdcfg.layout      = { "us", "ru" }
kbdcfg.layout_names = { "English", "Russian" }
kbdcfg.current      = 1
kbdcfg.image        = wibox.widget.imagebox()
kbdcfg.text         = wibox.widget.textbox()
kbdcfg.images       = { awful.util.getdir("config") .. "/themes/multicolor/icons/lang/icon_lang_en.png",
                        awful.util.getdir("config") .. "/themes/multicolor/icons/lang/icon_lang_ru.png" }

kbdcfg.switch = function()
  kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
  local t = " " .. kbdcfg.layout[kbdcfg.current]
  kbdcfg.text:set_text(kbdcfg.layout_names[kbdcfg.current])
  os.execute(kbdcfg.cmd .. t)
  kbdcfg.image:set_image(kbdcfg.images[kbdcfg.current])
end

for i = 1, #(kbdcfg.layout) do
  kbdcfg.switch()
end

layoutButtons = awful.util.table.join(awful.button({ }, 1, kbdcfg.switch))
kbdcfg.image:buttons(layoutButtons)
kbdcfg.text:buttons(layoutButtons)

--keyboardInfoWidget = wibox.layout.fixed.horizontal()
--keyboardInfoWidget:add(kbdcfg.image)
--keyboardInfoWidget:add(kbdcfg.text)
-- }}}
--========= base =========--
sys    = wibox.widget.textbox()
vicious.register(sys, vicious.widgets.os, color3.."$1"..span_end..color9.." $2"..span_end, 600)
uptime = wibox.widget.textbox()
vicious.register(uptime, vicious.widgets.uptime,
    function (widget, args)
      return string.format(color3.."Up:"..span_end..color9.."%2dd %02dh:%02dm "..span_end, args[1], args[2], args[3])
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
myclock_t.shape = function(cr, width, height)
    gears.shape.infobubble(cr, width, height, corner_radius, arrow_size, width - 75)
end
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
icon_widget = wibox.widget.imagebox()
function show_weather_current()
        local conn_stat   = [[zsh -c 'curl -H "Accept-Language: ru" wttr.in/"Нижний Тагил?T?0?Q" | head -n5']]
        awful.spawn.easy_async(conn_stat, function(stdout)
          naughty.notify {
            text          = color3 .. stdout .. span_end,
            position      = 'top_right',
            timeout       = 5,
            bg            = "#202020"
          }
          end)
    end
icon_widget:connect_signal("mouse::enter", function () show_weather_current() end)
--local path_to_icons = "/usr/share/icons/Arc/status/symbolic/"
local path_to_icons = "/usr/share/icons/Papirus-Dark/symbolic/status/"
local icon_map = {
    ["01d"] = "weather-clear-symbolic.svg",
    ["02d"] = "weather-few-clouds-symbolic.svg",
    ["03d"] = "weather-clouds-symbolic.svg",
    ["04d"] = "weather-overcast-symbolic.svg",
    ["09d"] = "weather-showers-scattered-symbolic.svg",
    ["10d"] = "weather-showers-symbolic.svg",
    ["11d"] = "weather-storm-symbolic.svg",
    ["13d"] = "weather-snow-symbolic.svg",
    ["50d"] = "weather-fog-symbolic.svg",
    ["01n"] = "weather-clear-night-symbolic.svg",
    ["02n"] = "weather-few-clouds-night-symbolic.svg",
    ["03n"] = "weather-clouds-night-symbolic.svg",
    ["04n"] = "weather-overcast-symbolic.svg",
    ["09n"] = "weather-showers-scattered-symbolic.svg",
    ["10n"] = "weather-showers-symbolic.svg",
    ["11n"] = "weather-storm-symbolic.svg",
    ["13n"] = "weather-snow-symbolic.svg",
    ["50n"] = "weather-fog-symbolic.svg"
}
--[[
local path_to_icons = "/usr/share/icons/oxygen/base/128x128/status/"
local icon_map = {
    ["01d"] = "weather-clear.png",
    ["02d"] = "weather-few-clouds.png",
    ["03d"] = "weather-clouds.png",
    ["04d"] = "weather-overcast.png",
    ["09d"] = "weather-showers-scattered.png",
    ["10d"] = "weather-showers.png",
    ["11d"] = "weather-storm.png",
    ["13d"] = "weather-snow.png",
    ["50d"] = "weather-fog.png",
    ["01n"] = "weather-clear-night.png",
    ["02n"] = "weather-few-clouds-night.png",
    ["03n"] = "weather-clouds-night.png",
    ["04n"] = "weather-overcast.png",
    ["09n"] = "weather-showers-scattered.png",
    ["10n"] = "weather-showers.png",
    ["11n"] = "weather-storm.png",
    ["13n"] = "weather-snow.png",
    ["50n"] = "weather-fog.png"
}]]--
myweather = lain.widget.weather({
    city_id = 520494,
    weather_na_markup = markup(beautiful.widget_font_color, "N/A "),
    notification_preset = { font = "Terminus Re33 Bold 13", bg = beautiful.widget_bg },
    settings = function()
        descr = weather_now["weather"][1]["description"]:lower()
        units = math.floor(weather_now["main"]["temp"])
        icons = weather_now["weather"][1]["icon"]
        --widget:set_markup(markup.font("Hack 9", markup(beautiful.widget_font_color, " " .. descr .. " | " .. units .. "°C ")))
        icon_widget.image = path_to_icons .. icon_map[icons]
        widget.markup = markup.font("Terminus Re33 Bold 13", markup(beautiful.widget_font_color, color9..units.."°C "..span_end))
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
    forced_width     = 290,
    set_max_value    = 100,
    background_color = beautiful.widget_bg,
    color            = ({
                          type  = "linear",
                          from  = { 0, 0 },
                          to    = { 290, 0 },
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
    forced_width     = 290,
    set_max_value    = 100,
    background_color = beautiful.widget_bg,
    color            = ({
                          type  = "linear",
                          from  = { 0, 0 },
                          to    = { 290, 0 },
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

--[[
fs_r = lain.widget.fs({
    partition = "/", options = "--exclude-type=tmpfs",
    settings  = function()
        fstext_r.markup = color3.." Root "..span_end..color9..fs_now.used_gb..span_end.."/"..color10..fs_now.available_gb..span_end
        fsbar_r.value = fs_now.used / 100
        arcchart.data_list = { {"available",fs_now.available_gb}, {"used", fs_now.used_gb}}
    end
})
]]--
fs_h = lain.widget.fs({
    options = "--exclude-type=tmpfs",
    settings  = function()
        --fstext_h.markup = color3.." Home "..span_end..color9..fs_now.used_gb..span_end.."/"..color10..fs_now.available_gb..span_end
        --fsbar_h.value = fs_now.used / 100

        fstext_r.markup = color3.." Root "..span_end..color9..tonumber(fs_info["/ used_gb"])..span_end.."/"..color10..tonumber(fs_info["/ avail_gb"])..span_end
        fsbar_r.value = tonumber(fs_info["/ used_p"])
        fstext_h.markup = color3.." Home "..span_end..color9..tonumber(fs_info["/home used_gb"])..span_end.."/"..color10..tonumber(fs_info["/home avail_gb"])..span_end
        fsbar_h.value = tonumber(fs_info["/home used_p"])
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
            scale             = true,
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
            scale             = true,
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
            scale             = true,
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
            scale             = true,
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
    --cpufreq_vicious.text = args[5].." "..math.floor(args[1]).."Mhz"
    return string.format(color3.."%s "..span_end..color9.."%s"..span_end.." Mhz", args[5], math.floor(args[1]))
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
        widget.markup = markup.font("Terminus Re33 Bold 11", color3.." ".."CPU "..span_end..color9..coretemp_now .. "°C"..span_end)
    end
})
mb = lain.widget.temp({
    tempfile = "/sys/class/hwmon/hwmon1/temp1_input",
    settings = function()
        temp_mb.markup = color3.."MB "..span_end..color9..coretemp_now .. "°C"..span_end
    end
})
gpu = lain.widget.temp({
    tempfile = "/sys/class/hwmon/hwmon0/temp1_input",
    settings = function()
        temp_gpu.markup = color3.."GPU "..span_end..color9..coretemp_now .. "°C"..span_end
    end
})

cpu_txt = wibox.widget{
      markup = color3 .. "  CPU1      CPU2       CPU3      CPU4" .. span_end,
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
              cpu.markup = color3.."  "..span_end..args[1].."% "
              cpupct0.text = tostring(args[2]).."%"
              cpugraph0:add_value(tonumber(args[2]))
              cpupct1.text = tostring(args[3]).."%"
              cpugraph1:add_value(tonumber(args[3]))
              cpupct2.text = tostring(args[4]).."%"
              cpugraph2:add_value(tonumber(args[4]))
              cpupct3.text = tostring(args[5]).."%"
              cpugraph3:add_value(tonumber(args[5]))
            end, 3)

process_htop = awful.widget.watch("bash -c '/bin/ps --sort -c,-s -eo fname,user,%cpu,%mem,pid | /usr/bin/head'", 7)
  process_htop.font = "Terminus Re33 Bold 11"
--========= CPU =========
--========= Mem =========--
vicious.cache(vicious.widgets.mem)

mem_txt = wibox.widget {
        widget = wibox.widget.textbox,
        font = "Terminus Re33 Bold 11",
  }

mem_graph = wibox.widget {
            forced_height    = 15,
            forced_width     = 290,
            background_color = beautiful.widget_bg,
            margins          = 1,
            paddings         = 1,
            ticks            = true,
            ticks_size       = 6,
            widget           = wibox.widget.progressbar,
}

vicious.register(mem_graph, vicious.widgets.mem,
  function (widget,args)
      mem_txt.markup = color3.."  Use:"..span_end..color9..tostring(args[2]).."Mb"..span_end..color3.." Free:"..span_end..color9..tostring(args[4]).."Mb"..span_end..color3.." Tot:"..span_end..color9..tostring(args[3]).."Mb"..span_end
          mem_graph.color = {
                                type  = "linear",
                                from  = { 0, 0 },
                                to    = { 290, 0 },
                                stops = {
                                  { 0, beautiful.fg_widget },
                                  { 0.75, beautiful.fg_center_widget },
                                  { 1, beautiful.fg_end_widget }
                                        }
                               }
          return args[1]
  end , 5 )
--========= Mem =========--
--========= Audio =========--
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
              soundicon.markup = markup.fontfg(beautiful.font, beautiful.widget_font_color, " "..color9..volume_now.left .. "%"..span_end)
          elseif tonumber(volume_now.left) >= 33 and tonumber(volume_now.left) <= 66 then
              soundicon.markup = markup.fontfg(beautiful.font, beautiful.widget_font_color, "🔉 "..color9..volume_now.left .. "%"..span_end)
          else
              soundicon.markup = markup.fontfg(beautiful.font, beautiful.widget_font_color, "🔈 "..color9..volume_now.left .. "%"..span_end)
          end
          else
            soundicon.markup = markup.fontfg(beautiful.font, "#EB8F8F", "🔇 muted")
      end
    end
})
volume.tooltip.wibox.fg   = beautiful.widget_bg
volume.tooltip.wibox.font = beautiful.font
volume.bar.width = 60
volume.bar.height = 6

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
local b = color9
local e = span_end
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

pkg_upd_count = awful.widget.watch('zsh -c "~/.config/awesome/util/script/pacm.sh pack_count"', 600,
  function(widget, stdout)
      if tonumber(stdout) > 0 then
        widget.markup = font_pacman..markup(beautiful.widget_font_color, "C--- ")..span_end..font1..markup(beautiful.red, stdout)..span_end
      else
        widget.markup = font_pacman..markup(beautiful.widget_font_color, "C--- ")..span_end..font1..markup(beautiful.widget_font_color, "OK")..span_end
      end
    return
  end)
pkg_upd_count:connect_signal('mouse::enter', function ()
      usage         = naughty.notify({
      text          = string.format('<span font_desc="%s">%s</span>', "Terminus Re33 Bold 13", display()),
      timeout       = 10,
      position      = "top_right",
      bg            = beautiful.widget_bg,
      screen        = capi.mouse.screen
    })
  end)
pkg_upd_count:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.spawn.with_shell('uxterm -geometry 90x10 -T Updating -e bash -c "sudo yaourt -Sy && pauseme"') end),
    awful.button({ }, 3, function () awful.spawn.with_shell('urxvt -T Updating -e bash -c "sudo yaourt -Sua && pauseme"') end)
))
--========= PKG =========--
--========= Net =========--
vicious.cache(vicious.widgets.net)

net_vicious1 = wibox.widget.textbox()
net_vicious2 = wibox.widget.textbox()

vicious.register(wibox.widget, vicious.widgets.net,
            function (widget, args)
              net_vicious1.markup = color3.."⬇ "..span_end..font2..tostring(args["{enp3s0 rx_mb}"]).."M ✦ "..tonumber(args["{enp3s0 down_kb}"]).."K"..span_end
              net_vicious2.markup = color3.."⬆ "..span_end..font2..tostring(args["{enp3s0 tx_mb}"]).."M ✦ "..tostring(args["{enp3s0 up_kb}"]).."K"..span_end
            end, 5)

net_raph_d = wibox.widget {
            forced_height     = 25,
            forced_width      = 135,
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
            forced_width     = 135,
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
    bg                = beautiful.widget_bg2
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
    bg                = beautiful.widget_bg2
    })
end

function vnstat_image:show2()
    self:hide()
    local conn_stat   = [[bash -c 'lsof -i |grep ESTABLISHED']]
    awful.spawn.easy_async(conn_stat, function(stdout, stderr, reason, exit_code)
      naughty.notify {
        text          = color3 .. stdout .. span_end,
        position      = 'top_right',
        timeout       = 50,
        bg            = beautiful.widget_bg2
      }
      end)
end

function vnstat_image:show3()
    self:hide()
    local conn_stat   = [[bash -c 'vnstat -h']]
    awful.spawn.easy_async(conn_stat, function(stdout, stderr, reason, exit_code)
      naughty.notify {
        text          = color3 .. stdout .. span_end,
        position      = 'top_right',
        timeout       = 50,
        bg            = beautiful.widget_bg2
      }
      end)
end

function vnstat_image:show4()
    self:hide()
    local conn_stat   = [[bash -c 'vnstat -d']]
    awful.spawn.easy_async(conn_stat, function(stdout, stderr, reason, exit_code)
      naughty.notify {
        text          = color3 .. stdout .. span_end,
        position      = 'top_right',
        timeout       = 50, hover_timeout = 0.5, bg = beautiful.widget_bg2
      }
      end)
end

net_vicious1:connect_signal("mouse::enter", function () vnstat_image:show() end)
net_vicious1:connect_signal("mouse::leave", function () vnstat_image:hide() end)
net_vicious1:buttons(awful.util.table.join(
    awful.button({ }, 1, function () vnstat_image:show1() end),
    awful.button({ }, 3, function () vnstat_image:show2() end),
    awful.button({ }, 9, function () vnstat_image:show3() end),
    awful.button({ }, 8, function () vnstat_image:show4() end)
    ))

net_icon = awful.widget.watch("zsh -c '~/.config/awesome/util/script/check_inet'", 60,
  function(widget, stdout)
    if tonumber(stdout) == 1 then
      widget.markup = font2..color7..""..span_end..span_end
    elseif tonumber(stdout) == 0 then
      widget.markup = font2..color2..""..span_end..span_end
      naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Шо та таки не то!",
                         text = "Нет интернета!" })
    else
      widget.markup = stdout
    end
    return
  end)
--========= Net =========-- color2 -bad, color7 -good
--========= MPD =========--
function format_time(s)
   return string.format("%d:%.2d", math.floor(s/60), s%60)
end

function mpd_toggle(s)
  awful.spawn.with_shell("mpc toggle || ncmpc toggle || pms toggle")
  mpdwidget.update()
end
function mpd_stop(s)
  awful.spawn.with_shell("mpc stop || ncmpc stop || pms stop")
  mpdwidget.update()
end
function mpd_prev(s)
  awful.spawn.with_shell("mpc prev || ncmpc prev || pms prev")
  mpdwidget.update()
end
function mpd_next(s)
  awful.spawn.with_shell("mpc next || ncmpc next || pms next")
  mpdwidget.update()
end
function open_ncmpcpp(s)
  local script = awful.util.get_configuration_dir() .. "/util/script/"
  awful.spawn.with_shell(script.."ncmpcpp_start")
end

icon_control_toggle = wibox.widget.textbox()
icon_control_prev   = wibox.widget.textbox()
  icon_control_prev.markup = color5.." "..span_end
icon_control_next   = wibox.widget.textbox()
  icon_control_next.markup = color5.." "..span_end
icon_control_stop   = wibox.widget.textbox()
  icon_control_stop.markup = color5.." "..span_end

mpdwidget = lain.widget.mpd({
    settings    = function()
        mpd_notification_preset = {
            text = string.format("%s [%s] - %s\n%s", mpd_now.artist,
                   mpd_now.album, mpd_now.date, mpd_now.title)
        }

        if mpd_now.state == "play" then
            artist = mpd_now.artist .. "  "
            album  = mpd_now.album ..  "  "
            title  = mpd_now.title
            time   = string.format(" (%s/%s)", format_time(mpd_now.elapsed),format_time(mpd_now.time))
            pls    = string.format("[%s/%s] ", mpd_now.pls_pos,mpd_now.pls_len)
            icon_control_toggle.markup = color5.." "..span_end
            icon_control_prev.markup   = color5.." "..span_end
            icon_control_next.markup   = color5.." "..span_end
            icon_control_stop.markup   = color5.." "..span_end
        elseif mpd_now.state == "pause" then
            artist = mpd_now.artist .. "  "
            album  = mpd_now.album ..  "  "
            title  = mpd_now.title
            time   = string.format(" (%s/%s)", format_time(mpd_now.elapsed),format_time(mpd_now.time))
            pls    = string.format("[%s/%s] ", mpd_now.pls_pos,mpd_now.pls_len)
            icon_control_toggle.markup = color5.." "..span_end
        else
            artist = ""
            album  = ""
            title  = ""
            time   = ""
            pls    = ""
            icon_control_toggle.markup = color5.." "..span_end
            icon_control_prev.markup   = ""
            icon_control_next.markup   = ""
            icon_control_stop.markup   = ""
        end
        widget.markup = font3..color9..pls..span_end..span_end..font3..color2..artist..span_end..span_end..font3..color1..album..span_end..span_end..font3..color3..title..span_end..span_end..font3..color9..time..span_end..span_end
    end
})
icon_control_toggle:connect_signal("button::press", function () mpd_toggle()   end)
icon_control_prev:connect_signal  ("button::press", function () mpd_prev()     end)
icon_control_next:connect_signal  ("button::press", function () mpd_next()     end)
icon_control_stop:connect_signal  ("button::press", function () mpd_stop()     end)
mpdwidget.widget:connect_signal   ("button::press", function () open_ncmpcpp() end)
--========= MPD =========--
--========= Balans =========--
balans_widget = awful.widget.watch("zsh -c '~/.config/awesome/util/script/balans'", 6000,
  function(widget, stdout)
    widget.markup = markup.font("Terminus Re33 Bold 11", color3.."Баланс "..span_end..color9..stdout..span_end)
    return
  end)
--========= Balans =========--
--========= Ext. IP =========--
ext_ip = awful.widget.watch('wget -O - -q icanhazip.com', 600,
  function(widget, stdout)
    widget.markup = markup.font("Terminus Re33 Bold 11", color3.."IP:"..span_end..color9..stdout..span_end)
    return
  end)
--========= Ext. IP =========--
