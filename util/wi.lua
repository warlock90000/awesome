local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
local pulseaudio    = require("pulseaudio")
local vicious       = require("vicious")

local markup = lain.util.markup

-- {{{ Keyboard layout widget
kbdcfg = {}
kbdcfg.image        = wibox.widget.imagebox()
kbdcfg.layout      = { "us", "ru" }
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
--========= Textclock =========--
mytextclock = wibox.widget.textclock(markup.font("Terminus Re33 Bold 18", markup(beautiful.clock_font_color, "%H:%M:%S")))
myclock_t = awful.tooltip({
         objects = { mytextclock },
         delay_show = 0,
         timer_function = function()
            return os.date(markup.font("Terminus Re33 Bold 18", markup(beautiful.clock_font_color, "%A %d %B %Y")))
          end,
})
-- Calendar
----lain.widget.calendar.attach(mytextclock, { font_size = 10 })
lain.widget.calendar({
    attach_to = { mytextclock },
    notification_preset = {
        font = "Terminus Re33 Bold 13",
        bg   = beautiful.widget_bg
}})

--========= Textclock =========--
--========= Weather =========--ConkyWeather bold 11
myweather = lain.widget.weather({
    city_id = 520494, -- placeholder
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
fsroot = lain.widget.fs({
    options = "--exclude-type=tmpfs",
    notification_preset = { font = "Terminus Re33 Bold 13", bg = beautiful.widget_bg },
    settings  = function()
        widget:set_markup(markup.font("Terminus Re33 Bold 13", markup(beautiful.widget_font_color, " " .. fs_now.used .. "% ")))
    end
})
--========= fs =========--
--========= CPU =========--
cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font("Terminus Re33 Bold 13", markup(beautiful.widget_font_color, " " .. cpu_now.usage .. "% ")))
    end
})
---------- cpu freq
local function cpufreq(whichcpu)
  local file = io.open("/sys/devices/system/cpu/" .. whichcpu .. "/cpufreq/scaling_cur_freq", "r")
  local cpufreq = file:read("*n")
  file:close()
  return cpufreq / 1000
end
---------- cputmp()
local function cputemp()
  local file = io.open("/sys/class/hwmon/hwmon2/temp1_input", "r")
  local output = file:read("*n")
  file:close()
  return output / 1000
end
---------- cpugov()
local helpers = require("vicious.helpers")
local function cpugov(warg)
    local _cpufreq = helpers.pathtotable("/sys/devices/system/cpu/"..warg.."/cpufreq")
    local governor_state = {
       ["ondemand\n"]     = "↯",
       ["powersave\n"]    = "⌁",
       ["userspace\n"]    = "¤",
       ["performance\n"]  = "⚡",
       ["conservative\n"] = "⊚"
    }
    local governor = _cpufreq.scaling_governor
    governor = governor_state[governor] or governor or "N/A"

    return governor
end
---------- cpu popup
mycpu_t = awful.tooltip({
         objects = { cpu.widget },
        timer_function = function()
            mycpu_t:set_text(
            " CPU 0: " .. cpugov("cpu0") .. " " .. cpufreq("cpu0") .. " Mhz \n" ..
            " CPU 1: " .. cpugov("cpu1") .. " " ..  cpufreq("cpu1") .. " Mhz \n" ..
            " CPU 2: " .. cpugov("cpu2") .. " " ..  cpufreq("cpu2") .. " Mhz \n" ..
            " CPU 3: " .. cpugov("cpu3") .. " " ..  cpufreq("cpu3") .. " Mhz \n" ..
            " Temp: " .. cputemp() .. " °C")
          end,
})
--blingbling.popups.htop(cpu.widget, { title_color = white, user_color = black, root_color = black})
--========= CPU =========--font   = "xos4 Terminus Bold 12",
--========= Mem =========--
memory = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.font("Terminus Re33 Bold 13", markup(beautiful.widget_font_color, " " .. mem_now.used .. "M ")))
    end
})
-- {{{ Memory tooltip
local function GetMemInfo(format)
    local _mem = { buf = {}, swp = {} }

    -- Get MEM info
    for line in io.lines("/proc/meminfo") do
        for k, v in string.gmatch(line, "([%a]+):[%s]+([%d]+).+") do
            if     k == "MemTotal"  then _mem.total = math.floor(v/1024)
            elseif k == "MemFree"   then _mem.buf.f = math.floor(v/1024)
            elseif k == "Buffers"   then _mem.buf.b = math.floor(v/1024)
            elseif k == "Cached"    then _mem.buf.c = math.floor(v/1024)
            elseif k == "SwapTotal" then _mem.swp.t = math.floor(v/1024)
            elseif k == "SwapFree"  then _mem.swp.f = math.floor(v/1024)
            end
        end
    end

    -- Calculate memory percentage
    _mem.free  = _mem.buf.f + _mem.buf.b + _mem.buf.c
    _mem.inuse = _mem.total - _mem.free
    _mem.bcuse = _mem.total - _mem.buf.f
    _mem.usep  = math.floor(_mem.inuse / _mem.total * 100)
    -- Calculate swap percentage
    _mem.swp.inuse = _mem.swp.t - _mem.swp.f
    _mem.swp.usep  = math.floor(_mem.swp.inuse / _mem.swp.t * 100)
    local o = "Mem: " .. _mem.usep .. "% " .. "Use: " .. _mem.inuse .. "Mb " .. "Total: " .. _mem.total .. "Mb " .. "Free: " .. _mem.free .. "Mb " .. "Swap: " .. _mem.swp.usep .. "%"
    return o
end

mem_t = awful.tooltip({
        objects = { memory.widget },
        timer_function = function()
            mem_t:set_text(tostring(GetMemInfo("Mem:$1% Use: $2Mb Total: $3Mb Free: $4Mb Swap: $5%")))
          end,
})
-- }}}
--========= Mem =========--
--========= Audio =========--
volumewidget = wibox.widget{
      markup   = pulseaudio.volume_info_c(),
      widget = wibox.widget.textbox,
      font   = "Terminus Re33 Bold 13",
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
volumetimer:add_signal("timeout", function() volumewidget.markup = pulseaudio.volume_info_c() end)
volumetimer:start()
volumetimer1 = timer({ timeout = 31 })
volumetimer1:add_signal("widget::redraw_needed", function() volumewidget1.value = pulseaudio.volume_info_for_bar() end)
volumetimer1:start()
--========= Audio =========--
--========= PKG =========--
local capi = {
    mouse = mouse,
    screen = screen
}

local function display()
    local lines = "<u>Pacman Updates:</u>\n"
    local f = io.popen("yaourt -Qua", "r")
    local s = f:read('*all')
    line = lines .. "\n" .. s .. "\n"
    f:close()
    return line
end

pkg_upd_icons = wibox.widget.textbox()
  pkg_upd_icons:set_markup(markup.font("PacFont Bold 11", markup(beautiful.widget_font_color, "C--- ")))
  pkg_upd_icons:connect_signal('mouse::enter', function ()
        usage = naughty.notify({
        text = string.format('<span font_desc="%s">%s</span>', "Terminus Re33 Bold 13", display()),
        timeout = 0,
        hover_timeout = 0.5,
        bg = beautiful.widget_bg,
        screen = capi.mouse.screen
        })
    end)
    pkg_upd_icons:connect_signal('mouse::leave', function () naughty.destroy(usage) end)

pkg_upd_vicious = wibox.widget.textbox()
    vicious.register(pkg_upd_vicious, vicious.widgets.pkg, "$1", 1000, "Arch")
--========= PKG =========--
--========= Coretemp =========--
local tempicon = wibox.widget.imagebox(beautiful.widget_temp)
local temp = lain.widget.temp({
    settings = function()
        widget:set_markup(markup.font("Hack 9", markup("#f1af5f", coretemp_now .. "°C ")))
    end
})
--========= Coretemp =========--
--========= Net =========--
local netdowninfo = wibox.widget.textbox()
local netupinfo = lain.widget.net({
    settings = function()
        if iface ~= "network off" and
           string.match(myweather.widget.text, "N/A")
        then
            myweather.update()
        end

        widget:set_markup(markup.font("Hack 9", markup("#e54c62", "⬆ " .. net_now.sent .. " ")))
        netdowninfo:set_markup(markup.font("Hack 9", markup("#87af5f", "⬇ " .. net_now.received .. " ")))
    end
})
--========= Net =========--
--========= MPD =========--
local mpdicon = wibox.widget.imagebox()
local mpdwidget = lain.widget.mpd({
    settings = function()
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
--[[ Vicious template
--========= vicious =========--
local net_vicious = wibox.widget.textbox()
vicious.register(net_vicious, vicious.widgets.net, "⬇ <span font=\"Hack 10\">${enp3s0 carrier}M</span> <span color=\"#ffffff\"> ✦ </span>⬆ <span font=\"Hack 10\">${enp3s0 rx_mb}M</span>", 1)

local mem_vicious = wibox.widget.textbox()
    vicious.register(mem_vicious, vicious.widgets.mem, markup.big(markup.bold("Mem:$1% $2Mb Total:$3Mb Free:$4Mb $9")))

local pkg_upd_vicious = wibox.widget.textbox()
    vicious.register(pkg_upd_vicious, vicious.widgets.pkg, "$1", 1, "Arch")

local cpufreq_vicious = wibox.widget.textbox()
    vicious.register(cpufreq_vicious, vicious.widgets.cpufreq, "$5 $1 $2 $3 $4", 1, "cpu0")
    -- CPU usage widget
local cpuwidget = awful.widget.graph()
cpuwidget:set_width(50)
cpuwidget:set_height(30)
cpuwidget:set_background_color("#494B4F")
cpuwidget:set_color("#FF5656")

cpuwidget_t = awful.tooltip({ objects = { cpuwidget.widget },})

-- Register CPU widget
vicious.register(cpuwidget, vicious.widgets.cpu,
                    function (widget, args)
                        cpuwidget_t:set_text("CPU Usage: " .. args[1] .. "%")
                        return args[1]
                    end)
--========= vicious =========--
]]--