local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local lain          = require("lain")

-- {{{ Theme definitions
beautiful.init(awful.util.get_configuration_dir() .. "/themes/multicolor/theme.lua")
-- }}}
-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 350 } })
        end
    end
end
-- }}}

local dockshape = function(cr, width, height)
    gears.shape.partially_rounded_rect(cr, width, height, true, true, true, true, 8)
end

local lspace1 = wibox.widget.textbox()
local lspace2 = wibox.widget.textbox()
local lspace3 = wibox.widget.textbox()
local lspace4 = wibox.widget.textbox()
local lspace5 = wibox.widget.textbox()
lspace1.forced_height = 10
lspace2.forced_height = 16
lspace3.forced_height = 18
lspace4.forced_height = 2
lspace5.forced_height = 5

-- {{{ Wibox
-- Create a wibox for each screen and add it

taglist_buttons = awful.util.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
 --[[                   awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                                          ]]--
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

tasklist_buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

awful.screen.connect_for_each_screen(function(s)
    -- Quake application
    s.quake = lain.util.quake({ app = terminal })

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons, { bg_focus = "#00000000" })

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 20 })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.align.horizontal,
            {
              {
                {
                  {
                    widget = mylauncher
                  },
                  left   = 5,
                  right  = 15,
                  top    = 0,
                  bottom = 0,
                  widget = wibox.container.margin
                },
                bg = beautiful.base02,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height)
                end,
                widget = wibox.container.background
              },
              left   = -10,
              right  = -16,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
            },
            {
              {
                {
                  {
                    widget = s.mytaglist,
                  },
                  left   = 15,
                  right  = 15,
                  top    = 0,
                  bottom = 0,
                  widget = wibox.container.margin
                },
                bg = beautiful.base02,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height)
                end,
                widget = wibox.container.background
              },
              left   = 0,
              right  = -13,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
            },
            {
              {
                {
                  {
                    widget = s.mypromptbox
                  },
                  left   = 15,
                  right  = 15,
                  top    = 0,
                  bottom = 0,
                  widget = wibox.container.margin
                },
                bg = beautiful.base03,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height)
                end,
                widget = wibox.container.background
              },
              left   = 0,
              right  = -13,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
            },
        },
        --s.mytasklist, -- Middle widget
        nil,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,

            {
              {
                {
                  {
                    widget = wibox.widget.systray()
                  },
                  left   = 15,
                  right  = 15,
                  top    = 2,
                  bottom = 2,
                  widget = wibox.container.margin
                },
                bg = beautiful.base02,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height, (height / 2) * (-1))
                  --gears.shape.powerline(cr, width, height, (height / 2) * (-1))
                end,
                widget = wibox.container.background
              },
              left   = 0,
              right  = -13,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
            },
            {
              {
                {
                  {
                    widget = pkg_upd_icons
                  },
                  left   = 9,
                  right  = 15,
                  top    = 2,
                  bottom = 2,
                  widget = wibox.container.margin
                },
                bg = beautiful.base03,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height, (height / 2) * (-1))
                  --gears.shape.powerline(cr, width, height, (height / 2) * (-1))
                end,
                widget = wibox.container.background
              },
              left   = 0,
              right  = -23,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
            },
            {
              {
                {
                  {
                    widget = pkg_upd_vicious
                  },
                  left   = 5,
                  right  = 19,
                  top    = 2,
                  bottom = 2,
                  widget = wibox.container.margin
                },
                bg = beautiful.base03,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height, (height / 2) * (-1))
                  --gears.shape.powerline(cr, width, height, (height / 2) * (-1))
                end,
                widget = wibox.container.background
              },
              left   = 0,
              right  = -13,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
            },
            {
              {
                {
                  {
                    widget = volumewidget
                  },
                  left   = 10,
                  right  = 17,
                  top    = 0,
                  bottom = 0,
                  widget = wibox.container.margin
                },
                bg = beautiful.base02,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height, (height / 2) * (-1))
                end,
                widget = wibox.container.background
              },
              left   = 0,
              right  = -13,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
            },
            {
              {
                {
                  {
                    widget = volumewidget1
                  },
                  left   = 5,
                  right  = 17,
                  top    = 0,
                  bottom = 0,
                  widget = wibox.container.margin
                },
                bg = beautiful.base02,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height, (height / 2) * (-1))
                end,
                widget = wibox.container.background
              },
              left   = -3,
              right  = -13,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
            },
--[[
            {
              {
                {
                  {
                    widget = memory.widget
                  },
                  left   = 10,
                  right  = 10,
                  top    = 0,
                  bottom = 0,
                  widget = wibox.container.margin
                },
                bg = beautiful.base03,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height, (height / 2) * (-1))
                end,
                widget = wibox.container.background
              },
              left   = 0,
              right  = -13,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
            },
            {
              {
                {
                  {
                    widget = cpu.widget
                  },
                  left   = 10,
                  right  = 10,
                  top    = 0,
                  bottom = 0,
                  widget = wibox.container.margin
                },
                bg = beautiful.base02,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height, (height / 2) * (-1))
                end,
                widget = wibox.container.background
              },
              left   = 0,
              right  = -13,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
            },
            {
              {
                {
                  {
                    widget = fsroot.widget
                  },
                  left   = 10,
                  right  = 10,
                  top    = 0,
                  bottom = 0,
                  widget = wibox.container.margin
                },
                bg = beautiful.base03,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height, (height / 2) * (-1))
                end,
                widget = wibox.container.background
              },
              left   = 0,
              right  = -13,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
            },
]]--
            {
              {
                {
                  {
                    widget = myweather.widget
                  },
                  left   = 10,
                  right  = 10,
                  top    = 0,
                  bottom = 0,
                  widget = wibox.container.margin
                },
                bg = beautiful.base03,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height, (height / 2) * (-1))
                end,
                widget = wibox.container.background
              },
              left   = 0,
              right  = -13,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
            },
            {
              {
                {
                  {
                    widget = mytextclock
                  },
                  left   = 10,
                  right  = 17,
                  top    = 0,
                  bottom = 0,
                  widget = wibox.container.margin
                },
                bg = beautiful.base02,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height)
                end,
                widget = wibox.container.background
              },
              left   = 0,
              right  = -13,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
            },
            {
              {
                {
                  {
                    widget = kbdcfg.image
                  },
                  left   = 0,
                  right  = 10,
                  top    = 0,
                  bottom = 0,
                  widget = wibox.container.margin
                },
                bg = beautiful.base02,
                set_shape = function(cr, width, height)
                  gears.shape.partially_rounded_rect(cr, width, height)
                end,
                widget = wibox.container.background
              },
              left   = 0,
              right  = -13,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
            },
        },
    }

    -- Create the bottom wibox
    s.mybottomwibox = awful.wibar({ position = "bottom", screen = s, border_width = 0, height = 20 })

    -- Add widgets to the bottom wibox
    s.mybottomwibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            s.mylayoutbox,
        },
    }

       --------------------------- Create the vertical wibox
    s.dockheight = (49 *  s.workarea.height)/100

    s.dock_wibox = wibox({ screen = s, x=0, y=s.workarea.height/2 - s.dockheight/2, width = 300, height = s.dockheight, fg = beautiful.menu_fg_normal, bg = beautiful.widget_bg, ontop = true, visible = true, type = "dock" })

    if s.index > 1 and s.dock_wibox.y == 0 then
        s.dock_wibox.y = screen[1].dock_wibox.y
    end

    -- Add widgets to the vertical wibox
    s.dock_wibox:setup {
        layout = wibox.layout.fixed.vertical,
        { --
          { --
            {
              widget = sys,
            },
              left   = 7,
              right  = 0,
              top    = 8,
              bottom = 7,
              widget = wibox.container.margin
          },
          { --
            {
              widget = uptime,
            },
              left   = 15,
              right  = 0,
              top    = 8,
              bottom = 7,
              widget = wibox.container.margin
          },
          layout  = wibox.layout.fixed.horizontal,
        },
        { -- Память текст
            layout = wibox.layout.align.horizontal,
            mem_txt,
        },
        lspace4,
        { -- Память график
            layout = wibox.layout.align.horizontal,
            mem_graph,
        },
        lspace5,
        { -- Проц
          {
            {
              widget = cpufreq_vicious,
            },
              left   = 7,
              right  = 0,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
          },
          { -- Говернер и частота
            {
              widget = temp_cpu.widget,
            },
              left   = 40,
              right  = 0,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
          },
          { -- темп проца
            {
              widget = cpu,
            },
              left   = 15,
              right  = 10,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
          },
          layout  = wibox.layout.align.horizontal
        },
        lspace5,
        cpu_txt,
        { -- Проц графики
          { -- цпу1 граф
            {
              widget = cpugraph0,
            },
              left   = 7,
              right  = 0,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
          },
          { -- цпу1 текст
              cpupct0,
              layout = wibox.container.rotate(cpupct0, 'east'),
          },
          { -- цпу2 граф
            {
              widget = cpugraph1,
            },
              left   = 7,
              right  = 0,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
          },
          { -- цпу2 текст
              cpupct1,
              layout = wibox.container.rotate(cpupct1, 'east'),
          },
          { -- цпу3 граф
            {
              widget = cpugraph2,
            },
              left   = 7,
              right  = 0,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
          },
          { -- цпу3 текст
              cpupct2,
              layout = wibox.container.rotate(cpupct2, 'east'),
          },
          { -- цпу4 граф
            {
              widget = cpugraph3,
            },
              left   = 7,
              right  = 0,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
          },
          { -- цпу4 текст
              cpupct3,
              layout = wibox.container.rotate(cpupct3, 'east'),
          },
          layout  = wibox.layout.fixed.horizontal
        },
        lspace5,
        { -- Сеть текст
          {
            widget = net_vicious,
          },
            left   = 5,
            right  = 0,
            top    = 0,
            bottom = 0,
            widget = wibox.container.margin
        },
        lspace5,
        { -- Сеть граф
          { -- Сеть граф загр
            {
              widget = net_raph_d,
            },
              left   = 7,
              right  = 0,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
          },
          { -- Сеть граф отдача
            {
              widget = net_raph_u,
            },
              left   = 7,
              right  = 0,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
          },
          layout  = wibox.layout.fixed.horizontal,
        },
        lspace5,
        { -- /
          {-- / текст
            {
              widget = fstext_r,
            },
              left   = 7,
              right  = 0,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
          },
          { -- / I/O R
            {
              widget = fs_stat_graph_r_read,
            },
              left   = 68,
              right  = 0,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
          },
          { -- / I/O W
            {
              widget = fs_stat_graph_r_write,
            },
              left   = 5,
              right  = 0,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
          },
          layout  = wibox.layout.fixed.horizontal,
        },
        { -- / бар
            layout = wibox.layout.align.horizontal,
            fsbar_r,
        },
        { -- /home
          {-- /home текст
            {
              widget = fstext_h,
            },
              left   = 7,
              right  = 0,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
          },
          { -- /home I/O R
            {
              widget = fs_stat_graph_h_read,
            },
              left   = 12,
              right  = 0,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
          },
          { -- /home I/O W
            {
              widget = fs_stat_graph_h_write,
            },
              left   = 5,
              right  = 0,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
          },
          layout  = wibox.layout.fixed.horizontal,
        },
        { -- /home бар
            layout = wibox.layout.align.horizontal,
            fsbar_h,
        },

        { -- Список процессов
            {
              widget = process_htop,
            },
              left   = 15,
              right  = 0,
              top    = 9,
              bottom = 0,
              widget = wibox.container.margin
        },
--[[ fs_stat_graph_h_read
        {
          {
            {
              widget = cpugraph0,
            },
              left   = 2,
              right  = 160,
              top    = 10,
              bottom = 10,
              widget = wibox.container.margin
          },
          {
            {
              widget = cpupct0,
            },
              left   = -150,
              right  = 0,
              top    = 0,
              bottom = 0,
              widget = wibox.container.margin
          },
                left   = 0,
                right  = 0,
                top    = 0,
                bottom = 0,
                widget = wibox.container.margin
        },
]]--
    }

    -- Add toggling functionalities
    s.docktimer = gears.timer{ timeout = 3 }
    s.dock_wibox_timer = gears.timer{ timeout = 3 }

    s.docktimer:connect_signal("timeout", function()
        s = awful.screen.focused()
        s.dock_wibox.width = 1
        if not s.docktimer.started then
            s.docktimer:start()
        end
        s.docktimer:stop()
    end)
--[[
    tag.connect_signal("property::selected", function(t)
        s = t.screen or awful.screen.focused()
        s.dock_wibox.width = 300
        gears.surface.apply_shape_bounding(s.dock_wibox, dockshape)
        s.docktimer = gears.timer{ timeout = 10 }
        if not s.docktimer.started then
            s.docktimer:start()
        end
    end)
]]--
    s.dock_wibox:connect_signal("mouse::leave", function()
        s = awful.screen.focused()
        s.dock_wibox.width = 1
    end)

    s.dock_wibox:connect_signal("mouse::enter", function()
        s = awful.screen.focused()
        s.dock_wibox.width = 300
        gears.surface.apply_shape_bounding(s.dock_wibox, dockshape)
          s.dock_wibox_timer:connect_signal("timeout", function()
            s.dock_wibox.width = 1
            if not s.dock_wibox_timer.started then
                s.dock_wibox_timer:start()
            end
          end)
          s.dock_wibox_timer:stop()
    end)
    ------------------------------

end)
-- }}}
