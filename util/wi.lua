local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
local pulseaudio    = require("pulseaudio")
local vicious       = require("vicious")
vicious.contrib = require("vicious.contrib")
--local blingbling    = require("blingbling")

local markup = lain.util.markup

local color1 = "<span color=\"#87af5f\">"
local color2 = "<span color=\"#e54c62\">"
local color3 = "<span color=\"#ffffff\">"
local color4 = "<span color=\"#67aead\">"
local color5 = "<span color=\"#4682b4\">"
local color6 = "<span color=\"#bf3eff\">"

local font1 = "<span font=\"Terminus Re33 Bold 13\">"
local font2 = "<span font=\"Terminus Re33 Bold 11\">"
local span_end = "</span>"

function math_round( roundIn , roundDig ) -- первый аргумент - число которое надо округлить, второй аргумент - количество символов после запятой.
     local mul = math.pow( 10, roundDig )
     return ( math.floor( ( roundIn * mul ) + 0.5 )/mul )
end

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
--========= base =========--
sys = wibox.widget.textbox()
vicious.register(sys, vicious.widgets.os, color5.."$1 $2"..span_end, 600)
uptime = wibox.widget.textbox()
vicious.register(uptime, vicious.widgets.uptime,
    function (widget, args)
      return string.format(color6.."Up: %2dd %02d:%02d "..span_end, args[1], args[2], args[3])
    end, 61)
--========= base =========--
--========= Textclock =========--
mytextclock = wibox.widget.textclock(markup.font("Terminus Re33 Bold 18", markup(beautiful.clock_font_color, " %H:%M ")))
myclock_t = awful.tooltip({
         objects = { mytextclock },
         delay_show = 0,
         margin_leftright = 15,
         margin_topbottom = 14,
         timer_function = function()
            return os.date(markup.font("Terminus Re33 Bold 18", markup(beautiful.clock_font_color, "%A %d %B %Y")))
          end,
})
myclock_t:set_shape(function(cr, width, height)
    gears.shape.infobubble(cr, width, height, corner_radius, arrow_size, width - 75)
end)
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
---
fstext_r = wibox.widget {
    valign           = 3,
    align            = 1,
    color            = beautiful.fg_normal,
    background_color = beautiful.bg_normal,
    widget           = wibox.widget.textbox,
}

fsbar_r = wibox.widget {
    forced_height    = 15,
    forced_width     = 298,
    background_color = beautiful.widget_bg,
    margins          = 3,
    paddings         = 1,
    ticks            = true,
    ticks_size       = 6,
    widget        = wibox.widget.progressbar,
}
fs_r = lain.widget.fs({
    partition = "/",
    options = "--exclude-type=tmpfs",
    notification_preset = { fg = beautiful.fg_normal, bg = beautiful.bg_normal, font = beautiful.font },
    settings  = function()
        fstext_r:set_text(" Root " .. fs_now.used_gb.."/"..fs_now.available_gb)
        if tonumber(fs_now.used) < 90 then
            fsbar_r:set_color({
                        type = "linear",
                        from = { 0, 7 },
                        to = { 0, 0 },
                        stops = {
                          { 0, "#00B52A" },
                          { 0.5, "#1E8B22" },
                          { 1, "#B87912" }
                                }
                       })
        else
            fsbar_r:set_color({
                        type = "linear",
                        from = { 0, 4 },
                        to = { 0, 0 },
                        stops = {
                          { 0, "#B56900" },
                          { 0.5, "#dc322f" },
                          { 1, "#BB2424" }
                                }
                       })
        end
            fsbar_r:set_value(fs_now.used / 100)
        end
})
    ---
fstext_h = wibox.widget {
    valign           = 3,
    align            = 1,
    color            = beautiful.fg_normal,
    background_color = beautiful.bg_normal,
    widget           = wibox.widget.textbox,
}

fsbar_h = wibox.widget {
    forced_height    = 15,
    forced_width     = 298,
    background_color = beautiful.widget_bg,
    margins          = 3,
    paddings         = 1,
    ticks            = true,
    ticks_size       = 6,
    widget        = wibox.widget.progressbar,
}

fs_h = lain.widget.fs({
    partition = "/home",
    options = "--exclude-type=tmpfs",
    settings  = function()
        fstext_h:set_text(" Home " .. fs_now.used_gb.."/"..fs_now.available_gb)
        if tonumber(fs_now.used) < 90 then
          fsbar_h:set_color({
                        type = "linear",
                        from = { 0, 7 },
                        to = { 0, 0 },
                        stops = {
                          { 0, "#00B52A" },
                          { 0.5, "#1E8B22" },
                          { 1, "#B87912" }
                                }
                       })
        else
          fsbar_h:set_color({
                        type = "linear",
                        from = { 0, 4 },
                        to = { 0, 0 },
                        stops = {
                          { 0, "#B56900" },
                          { 0.5, "#dc322f" },
                          { 1, "#BB2424" }
                                }
                       })
        end
          fsbar_h:set_value(fs_now.used / 100)
        end
    })
vicious.cache(vicious.widgets.dio)
fs_stat_r = wibox.widget.textbox()
vicious.register(fs_stat_r, vicious.widgets.dio, '<span color="#4682b4">R:${sdb7 read_mb}</span>/<span color="#bf3eff">W:${sdb7 write_mb}</span>', 1)
fs_stat_h = wibox.widget.textbox()
vicious.register(fs_stat_h, vicious.widgets.dio, '<span color="#4682b4">R:${sdb3 read_mb}</span>/<span color="#bf3eff">W:${sdb3 write_mb}</span>', 1)

--========= fs =========--
--========= CPU =========--
vicious.cache(vicious.widgets.cpu)
--[[
cpu_graph = wibox.widget {
            forced_height    = 15,
            forced_width     = 120,
            color            = ({
                                  type = "linear",
                                  from = { 0, 25 },
                                  to = { 0, 0 },
                                  stops = {
                                    { 0, "#268bd2" },
                                    { 0.25, "#b58900" },
                                    { 1, "#dc322f" }
                                  }
                                }),
            background_color = beautiful.widget_bg,
            min_value        = 0,
            max_value        = 100,
            widget        = wibox.widget.graph,
}
]]--
cpufreq_vicious = wibox.widget.textbox()
vicious.register(cpufreq_vicious, vicious.widgets.cpufreq,
  function (widget,args)
    cpufreq_vicious:set_text(args[5].." "..math.floor(args[1]).."Mhz")
  end , 1, "cpu0")

temp_cpu = lain.widget.temp({
    tempfile = "/sys/class/hwmon/hwmon2/temp1_input",
    settings  = function()
        widget:set_markup(color1.. " " ..coretemp_now .. "°C"..span_end)
    end
})

cpu_scale_0 = wibox.widget {
            forced_height    = 10,
            forced_width     = 75,
            color            = ({
                                  type = "linear",
                                  from = { 0, 7 },
                                  to = { 0, 0 },
                                  stops = {
                                    { 0, "#00B52A" },
                                    { 0.5, "#1E8B22" },
                                    { 1, "#B87912" }
                                  }
                                }),
            background_color = beautiful.widget_bg,
            margins          = 1,
            paddings         = 1,
            ticks            = true,
            ticks_size       = 3,
            --max_value        = 100,
            widget        = wibox.widget.progressbar,
}
cpu_scale_1 = wibox.widget {
            forced_height    = 10,
            forced_width     = 75,
            color            = ({
                                  type = "linear",
                                  from = { 0, 7 },
                                  to = { 0, 0 },
                                  stops = {
                                    { 0, "#00B52A" },
                                    { 0.5, "#1E8B22" },
                                    { 1, "#B87912" }
                                  }
                                }),
            background_color = beautiful.widget_bg,
            margins          = 1,
            paddings         = 1,
            ticks            = true,
            ticks_size       = 3,
            --max_value        = 100,
            widget        = wibox.widget.progressbar,
}
cpu_scale_2 = wibox.widget {
            forced_height    = 10,
            forced_width     = 75,
            color            = ({
                                  type = "linear",
                                  from = { 0, 7 },
                                  to = { 0, 0 },
                                  stops = {
                                    { 0, "#00B52A" },
                                    { 0.5, "#1E8B22" },
                                    { 1, "#B87912" }
                                  }
                                }),
            background_color = beautiful.widget_bg,
            margins          = 1,
            paddings         = 1,
            ticks            = true,
            ticks_size       = 3,
            --max_value        = 100,
            widget        = wibox.widget.progressbar,
}
cpu_scale_3 = wibox.widget {
            forced_height    = 10,
            forced_width     = 75,
            color            = ({
                                  type = "linear",
                                  from = { 0, 7 },
                                  to = { 0, 0 },
                                  stops = {
                                    { 0, "#00B52A" },
                                    { 0.5, "#1E8B22" },
                                    { 1, "#B87912" }
                                  }
                                }),
            background_color = beautiful.widget_bg,
            margins          = 1,
            paddings         = 1,
            ticks            = true,
            ticks_size       = 3,
            --max_value        = 100,
            widget        = wibox.widget.progressbar,
}

cpu_txt = wibox.widget{
      markup   = color2 .. "   CPU1     CPU2     CPU3     CPU4" .. span_end,
      widget = wibox.widget.textbox,
      font   = "Terminus Re33 Bold 11",
}
cpu = wibox.widget{
      widget = wibox.widget.textbox,
      font   = "Terminus Re33 Bold 11",
}

vicious.register(cpu, vicious.widgets.cpu,
  function (widget,args)
    cpu:set_text("  " .. args[1] .. "% ")
    --cpu_graph:add_value(args[1])
  end , 1 )

vicious.register(cpu_scale_0, vicious.widgets.cpu,
  function (widget,args)
    cpu_scale_0:set_value(args[2])
    return args[2]
  end , 1 )
vicious.register(cpu_scale_1, vicious.widgets.cpu,
  function (widget,args)
    cpu_scale_1:set_value(args[3])
    return args[3]
  end , 1 )
vicious.register(cpu_scale_2, vicious.widgets.cpu,
  function (widget,args)
    cpu_scale_2:set_value(args[4])
    return args[4]
  end , 1 )
vicious.register(cpu_scale_3, vicious.widgets.cpu,
  function (widget,args)
    cpu_scale_3:set_value(args[5])
    return args[5]
  end , 1 )
--================
cpupct0 = wibox.widget.textbox()
vicious.register(cpupct0, vicious.widgets.cpu, "$2%", 2)
cpugraph0 = wibox.widget {
            forced_height    = 25,
            forced_width     = 50,
            step_width = 2,
            step_spacing = 1,
            step_shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 2)
            end,
            border_color     = beautiful.widget_bg,
            background_color = beautiful.widget_bg,
            color            = ({
                                  type = "linear",
                                  from = { 0, 25 },
                                  to = { 0, 0 },
                                  stops = {
                                    { 0, "#268bd2" },
                                    { 0.25, "#b58900" },
                                    { 1, "#dc322f" }
                                  }
                                }),
            widget        = wibox.widget.graph,
}
vicious.register(cpugraph0, vicious.widgets.cpu, "$2")

cpupct1 = wibox.widget.textbox()
vicious.register(cpupct1, vicious.widgets.cpu, "$3%", 2)
cpugraph1 = wibox.widget {
            forced_height    = 25,
            forced_width     = 50,
            step_width = 2,
            step_spacing = 1,
            step_shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 2)
            end,
            border_color     = beautiful.widget_bg,
            background_color = beautiful.widget_bg,
            color            = ({
                                  type = "linear",
                                  from = { 0, 25 },
                                  to = { 0, 0 },
                                  stops = {
                                    { 0, "#268bd2" },
                                    { 0.25, "#b58900" },
                                    { 1, "#dc322f" }
                                          }
                                }),
            widget        = wibox.widget.graph,
}
vicious.register(cpugraph1, vicious.widgets.cpu, "$3")

cpupct2 = wibox.widget.textbox()
vicious.register(cpupct2, vicious.widgets.cpu, "$4%", 2)
cpugraph2 = wibox.widget {
            forced_height    = 25,
            forced_width     = 50,
            step_width = 2,
            step_spacing = 1,
            step_shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 2)
            end,
            border_color     = beautiful.widget_bg,
            background_color = beautiful.widget_bg,
            color            = ({
                                  type = "linear",
                                  from = { 0, 25 },
                                  to = { 0, 0 },
                                  stops = {
                                    { 0, "#268bd2" },
                                    { 0.25, "#b58900" },
                                    { 1, "#dc322f" }
                                          }
                                }),
            widget        = wibox.widget.graph,
}
vicious.register(cpugraph2, vicious.widgets.cpu, "$4")

cpupct3 = wibox.widget.textbox()
vicious.register(cpupct3, vicious.widgets.cpu, "$5%", 2)
cpugraph3 = wibox.widget {
            forced_height    = 25,
            forced_width     = 50,
            step_width = 2,
            step_spacing = 1,
            step_shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 2)
            end,
            border_color     = beautiful.widget_bg,
            background_color = beautiful.widget_bg,
            color            = ({
                                  type = "linear",
                                  from = { 0, 25 },
                                  to = { 0, 0 },
                                  stops = {
                                    { 0, "#268bd2" },
                                    { 0.25, "#b58900" },
                                    { 1, "#dc322f" }
                                          }
                                }),
            widget        = wibox.widget.graph,
}
vicious.register(cpugraph3, vicious.widgets.cpu, "$5")

process_htop = awful.widget.watch("bash -c '/bin/ps --sort -c,-s -eo fname,user,%cpu,%mem,pid | /usr/bin/head'", 3)
  process_htop:set_font("Terminus Re33 Bold 11")

--[[  ------------------------------------ tooltip
---------- cpu popup
mycpu_t = awful.tooltip({
         objects = { cpu.widget },
         margin_leftright = 8,
         margin_topbottom = 8,
        timer_function = function()
            mycpu_t:set_text(
            " CPU 0: " .. cpugov("cpu0") .. " " .. cpufreq("cpu0") .. " Mhz \n" ..
            " CPU 1: " .. cpugov("cpu1") .. " " ..  cpufreq("cpu1") .. " Mhz \n" ..
            " CPU 2: " .. cpugov("cpu2") .. " " ..  cpufreq("cpu2") .. " Mhz \n" ..
            " CPU 3: " .. cpugov("cpu3") .. " " ..  cpufreq("cpu3") .. " Mhz \n" ..
            " Temp: " .. cputemp() .. " °C")
          end,
})
mycpu_t:set_shape(function(cr, width, height)
    gears.shape.infobubble(cr, width, height, corner_radius, arrow_size, width - 220)
end)
]]------------------------------------
--========= CPU =========
--========= Mem =========--
vicious.cache(vicious.widgets.mem)

mem_txt = wibox.widget {
        widget = wibox.widget.textbox,
        font = "Terminus Re33 Bold 11",
  }
vicious.register(mem_txt, vicious.widgets.mem, "  Use:$2Mb Tot:$3Mb Free:$4Mb", 5)

mem_graph = wibox.widget {
            forced_height    = 15,
            forced_width     = 298,
            background_color = beautiful.widget_bg,
            margins          = 1,
            paddings         = 1,
            ticks            = true,
            ticks_size       = 6,
            widget        = wibox.widget.progressbar,
}

vicious.register(mem_graph, vicious.widgets.mem,
  function (widget,args)
      if tonumber(args[1]) < 75 then
          mem_graph:set_color({
                        type = "linear",
                        from = { 0, 7 },
                        to = { 0, 0 },
                        stops = {
                          { 0, "#00B52A" },
                          { 0.5, "#1E8B22" },
                          { 1, "#B87912" }
                                }
                       })
          return args[1]
      else
          mem_graph:set_color({
                        type = "linear",
                        from = { 0, 4 },
                        to = { 0, 0 },
                        stops = {
                          { 0, "#B56900" },
                          { 0.5, "#dc322f" },
                          { 1, "#BB2424" }
                                }
                       })
          return args[1]
      end
  end , 5 )
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
local b = "<span color=\"#67aead\">"
local e = "</span>"
local function display()
    local lines = "<u><b>Pacman Updates:</b></u>\n"
    local f = io.popen("yaourt -Qua", "r")
    local s = f:read('*all')
    line = lines .. "\n" .. b .. s .. e .."\n"
    f:close()
    return line
end
--[[
radical = require("radical")
menu1 = radical.context{}
    menu1:add_item {text="Screen 1",text=GetMemInfo("Mem:$1% Use: $2Mb Total: $3Mb Free: $4Mb Swap: $5%")}
    menu1:add_item {text="Screen 9",icon= beautiful.awesome_icon}
    menu1:add_item {text="Sub Menu",sub_menu = function()
        local smenu = radical.context{}
        smenu:add_item{text="item 1"}
        smenu:add_item{text="item 2"}
        return smenu
    end}
]]--
pkg_upd_icons = wibox.widget.textbox()
--pkg_upd_icons:set_menu(menu1)
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
    vicious.register(pkg_upd_vicious, vicious.widgets.pkg, "$1", 100, "Arch")

--========= PKG =========--
--========= Net =========--
vicious.cache(vicious.widgets.net)

net_vicious = wibox.widget.textbox()
vicious.register(net_vicious, vicious.widgets.net, color1.."⬇ "..span_end..font2.."${enp3s0 rx_mb}M".." ✦ ".."${enp3s0 down_kb}K"..span_end..color3.." ✦ "..span_end..color2.."⬆ "..span_end..font2.."${enp3s0 tx_mb}M".." ✦ ".."${enp3s0 up_kb}K"..span_end, 1)


net_raph_d = wibox.widget {
            forced_height    = 25,
            forced_width     = 140,
            scale            = true,
            step_width = 2,
            step_spacing = 1,
            step_shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 2)
            end,
            border_color     = beautiful.widget_bg,
            background_color = beautiful.widget_bg,
            color            = ({
                                  type = "linear",
                                  from = { 0, 25 },
                                  to = { 0, 0 },
                                  stops = {
                                    { 0, "#268bd2" },
                                    { 0.25, "#b58900" },
                                    { 1, "#dc322f" }
                                          }
                                }),
            widget        = wibox.widget.graph,
}
vicious.register(net_raph_d, vicious.widgets.net, "${enp3s0 down_kb}", 1)

net_raph_u = wibox.widget {
            forced_height    = 25,
            forced_width     = 140,
            scale            = true,
            step_width = 3,
            step_spacing = 1,
            step_shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 2)
            end,
            border_color     = beautiful.widget_bg,
            background_color = beautiful.widget_bg,
            color            = ({
                                  type = "linear",
                                  from = { 0, 25 },
                                  to = { 0, 0 },
                                  stops = {
                                    { 0, "#268bd2" },
                                    { 0.25, "#b58900" },
                                    { 1, "#dc322f" }
                                          }
                                }),
            widget        = wibox.widget.graph,
}
vicious.register(net_raph_u, vicious.widgets.net, "${enp3s0 up_kb}", 1)
--=======
-- vnstat_image notification
local vnstat_image = {}
vnstat_image.notification = nil
local eth_if = "enp3s0"
local conn_stat = nil

function vnstat_image:hide()
    if self.notification ~= nil then
        naughty.destroy(self.notification)
        self.notification = nil
    end
end

function vnstat_image:show()
    self:hide()
    os.execute( 'LC_ALL=C vnstati -vs -ne -i ' .. eth_if .. ' -o /tmp/vnstat_summary.png' )
    local net_summary       = "/tmp/vnstat_summary.png"
    self.notification = naughty.notify({
    icon = net_summary,
    position = 'top_left',
    timeout = 20,
    })
end

function vnstat_image:show1()
    self:hide()
    os.execute( 'LC_ALL=C vnstati -t -ne -i ' .. eth_if .. ' -o /tmp/vnstat_summary_h.png' )
    local net_summary_h     = "/tmp/vnstat_summary_h.png"
    self.notification = naughty.notify({
    icon = net_summary_h,
    position = 'top_left',
    timeout = 20,
    })
end

function vnstat_image:show2()
    self:hide()
    local conn_stat = [[bash -c 'lsof -i |grep ESTABLISHED']]
    awful.spawn.easy_async(conn_stat, function(stdout, stderr, reason, exit_code)
      naughty.notify {
        text = color4 .. stdout .. span_end,
        position = 'top_right',
        timeout = 50, hover_timeout = 0.5, bg = beautiful.widget_bg,
      }
      end)
end

net_vicious:connect_signal("mouse::enter", function () vnstat_image:show() end)
net_vicious:connect_signal("mouse::leave", function () vnstat_image:hide() end)
net_vicious:buttons(awful.util.table.join(
    awful.button({ }, 1, function () vnstat_image:show1() end),
    awful.button({ }, 3, function () vnstat_image:show2() end)
    ))
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
local mem_vicious = wibox.widget.textbox()
    vicious.register(mem_vicious, vicious.widgets.mem, markup.big(markup.bold("Mem:$1% $2Mb Total:$3Mb Free:$4Mb $9")))

memwidget1 = wibox.widget.textbox()
-- Register widget
vicious.register(memwidget1, vicious.widgets.mem,
function (widget,args)
    if args[1] > 25 then
        local color = "#b58900"
        return string.format("  <span color='%s'>RAM: %s%% ( %sMB / %sMB )</span>  ",color,args[1],args[2],args[3] )
    else
        return string.format("  RAM: %s%% ( %sMB / %sMB )  ",args[1],args[2],args[3] )
    end
end , 5 )

uptimewidget = wibox.widget.textbox()
  vicious.register(uptimewidget, vicious.widgets.uptime,
    function (widget, args)
      return string.format("Uptime: %2dd %02d:%02d ", args[1], args[2], args[3])
    end, 61)

ctext = wibox.widget.textbox()
  cgraph = wibox.widget.graph()
  cgraph:set_width(100):set_height(20)
  cgraph:set_stack(true):set_max_value(100)
  cgraph:set_background_color("#494B4F")
  cgraph:set_stack_colors({ "#FF5656", "#88A175", "#AECF96" })
  vicious.register(ctext, vicious.widgets.cpu,
    function (widget, args)
      cgraph:add_value(args[2], 1) -- Core 1, color 1
      cgraph:add_value(args[3], 2) -- Core 2, color 2
      cgraph:add_value(args[4], 3) -- Core 3, color 3
    end, 3)
--========= vicious =========--
]]--
--font   = "xos4 Terminus Bold 12",