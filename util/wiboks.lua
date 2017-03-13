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

local tag_menu = {
    { "Добавить тег",       function() lain.util.add_tag()     end },
    { "Переименовать тег",  function() lain.util.rename_tag()  end },
    { "Тег влево",          function() lain.util.move_tag(1)   end },
    { "Тег враво",          function() lain.util.move_tag(-1)  end },
    { "Удалить тег",        function() lain.util.delete_tag()  end }
}

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
                    --awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ }, 3, function(t) lain.util.menu_clients_current_tags(tag_menu) end),
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
                  mylauncher,
                  layout = wibox.container.margin(mylauncher,5,15,0,0),
                },
                bg = beautiful.base02,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height)
                end,
                widget = wibox.container.background
              },
              layout = wibox.container.margin(widget,-10,-16,0,0),
            },
            {
              {
                {
                  s.mytaglist,
                  layout = wibox.container.margin(s.mytaglist,15,15,0,0),
                },
                bg = beautiful.base02,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height)
                end,
                widget = wibox.container.background
              },
              layout = wibox.container.margin(widget,0,-13,0,0),
            },
            {
              {
                {
                  s.mypromptbox,
                  layout = wibox.container.margin(s.mypromptbox,15,15,0,0),
                },
                bg = beautiful.base03,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height)
                end,
                widget = wibox.container.background
              },
              layout = wibox.container.margin(widget,0,-13,0,0),
            },
        },
        --s.mytasklist, -- Middle widget
        nil,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,

            {
              {
                {
                  wibox.widget.systray(),
                  layout = wibox.container.margin(wibox.widget.systray(),15,15,2,2),
                },
                bg = beautiful.base02,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height, (height / 2) * (-1))
                  --gears.shape.powerline(cr, width, height, (height / 2) * (-1))
                end,
                widget = wibox.container.background
              },
              layout = wibox.container.margin(widget,0,-13,0,0),
            },
            {
              {
                {
                  pkg_upd_icons,
                  layout = wibox.container.margin(pkg_upd_count,9,15,2,2),
                },
                bg = beautiful.base03,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height, (height / 2) * (-1))
                end,
                widget = wibox.container.background
              },
              layout = wibox.container.margin(widget,0,-23,0,0),
            },
            {
              {
                {
                  pkg_upd_count,
                  layout = wibox.container.margin(pkg_upd_count,5,19,2,2),
                },
                bg = beautiful.base03,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height, (height / 2) * (-1))
                end,
                widget = wibox.container.background
              },
              layout = wibox.container.margin(widget,0,-13,0,0),
            },
            {
              {
                {
                  soundicon,
                  layout = wibox.container.margin(soundicon,10,17,0,0),
                },
                bg = beautiful.base02,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height, (height / 2) * (-1))
                end,
                widget = wibox.container.background
              },
              layout = wibox.container.margin(widget,0,-13,0,0),
            },
            {
              {
                {
                  volume.bar,
                  layout = wibox.container.margin(volume.bar,5,17,5,5),
                },
                bg = beautiful.base02,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height, (height / 2) * (-1))
                end,
                widget = wibox.container.background
              },
              layout = wibox.container.margin(widget,-3,-13,0,0),
            },
            {
              {
                {
                  myweather.widget,
                  layout = wibox.container.margin(myweather.widget,10,10,0,0),
                },
                bg = beautiful.base03,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height, (height / 2) * (-1))
                end,
                widget = wibox.container.background
              },
              layout = wibox.container.margin(widget,0,-13,0,0),
            },
            {
              {
                {
                  mytextclock,
                  layout = wibox.container.margin(mytextclock,10,17,0,0),
                },
                bg = beautiful.base02,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height)
                end,
                widget = wibox.container.background
              },
              layout = wibox.container.margin(widget,0,-13,0,0),
            },
            {
              {
                {
                  kbdcfg.image,
                  layout = wibox.container.margin(kbdcfg.image,0,10,0,0),
                },
                bg = beautiful.base02,
                set_shape = function(cr, width, height)
                  gears.shape.partially_rounded_rect(cr, width, height)
                end,
                widget = wibox.container.background
              },
              layout = wibox.container.margin(widget,0,-13,0,0),
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

    s.dock_wibox = wibox({ screen = s, x=0, y=s.workarea.height/2 - s.dockheight/2, width = 300, height = s.dockheight, fg = beautiful.menu_fg_normal, bg = beautiful.widget_bg1, ontop = true, visible = true, type = "dock" })
    gears.surface.apply_shape_bounding(s.dock_wibox, dockshape)

    if s.index > 1 and s.dock_wibox.y == 0 then
        s.dock_wibox.y = screen[1].dock_wibox.y
    end

    -- Add widgets to the vertical wibox
    s.dock_wibox:setup {
        layout = wibox.layout.fixed.vertical,
        {-- Система
          {
              {
                {
                  sys,
                  layout = wibox.container.margin(sys,7,0,3,3),
                },
                {
                  uptime,
                  layout = wibox.container.margin(uptime,15,0,3,3),
                },
                layout  = wibox.layout.fixed.horizontal,
              },
              set_shape = function(cr, width, height)
                    gears.shape.rounded_rect(cr, width, height)
                  end,
              bg                 = beautiful.widget_bg2,
              shape_border_color = beautiful.border_color,
              shape_border_width = 1,
              widget             = wibox.container.background,
          },
          layout = wibox.container.margin(widget,2,2,3,1),
        },
        {-- Память
          {
              {
                { -- Память текст
                  mem_txt,
                  layout = wibox.container.margin(mem_txt,4,4,3,3),
                },
                { -- Память график
                  mem_graph,
                  layout = wibox.container.margin(mem_graph,5,5,3,3),
                },
                layout  = wibox.layout.fixed.vertical,
              },
              set_shape = function(cr, width, height)
                    gears.shape.rounded_rect(cr, width, height)
                  end,
              bg                 = beautiful.widget_bg2,
              shape_border_color = beautiful.border_color,
              shape_border_width = 1,
              widget             = wibox.container.background,
          },
          layout = wibox.container.margin(widget,2,2,1,1),
        },
        {
        {
          {
              { -- Проц
                 { -- Говернер и частота
                     cpufreq_vicious,
                     layout = wibox.container.margin(cpufreq_vicious.widget,7,0,0,0),
                 },
                 { -- %
                     cpu,
                     layout = wibox.container.margin(cpu.widget,15,10,0,0),
                 },
                 layout  = wibox.layout.align.horizontal,
              },
                layout  = wibox.layout.align.vertical,
              { -- Проц
                 { -- темп проца
                    temp_cpu.widget,
                    layout = wibox.container.margin(temp_cpu.widget,5,0,0,0),
                 },
                 { -- темп матирнки
                    temp_mb,
                    layout = wibox.container.margin(temp_mb,15,0,0,0),
                 },
                 { -- темп видео
                    temp_gpu,
                    layout = wibox.container.margin(temp_gpu,10,6,0,0),
                 },
                 layout  = wibox.layout.align.horizontal,
              },
                layout  = wibox.layout.align.vertical,
            { --
              cpu_txt,
              layout = wibox.container.margin(cpu_txt,3,0,2,3),
            },
              layout  = wibox.layout.align.vertical,

             {
               -- Проц графики
                { -- цпу1 граф
                  cpugraph0,
                  layout = wibox.container.margin(cpugraph0,7,0,0,5),
                },
                {
                  {
                    cpupct0,
                    widget = wibox.container.margin(cpupct0,5,0,0,0)
                  },
                    layout = wibox.container.rotate(widget, 'east'),
                },
                  layout  = wibox.layout.fixed.horizontal,
                { -- цпу2 граф
                  cpugraph1,
                  layout = wibox.container.margin(cpugraph1,7,0,0,5),
                },
                {
                  {
                    cpupct1,
                    widget = wibox.container.margin(cpupct1,5,0,0,0)
                  },
                    layout = wibox.container.rotate(widget, 'east'),
                },
                  layout  = wibox.layout.fixed.horizontal,
                { -- цпу3 граф
                  cpugraph2,
                  layout = wibox.container.margin(cpugraph2,7,0,0,5),
                },
                {
                  {
                    cpupct2,
                    widget = wibox.container.margin(cpupct2,5,0,0,0)
                  },
                    layout = wibox.container.rotate(widget, 'east'),
                },
                  layout  = wibox.layout.fixed.horizontal,
                { -- цпу4 граф
                  cpugraph3,
                  layout = wibox.container.margin(cpugraph3,7,0,0,5),
                },
                {
                  {
                    cpupct3,
                    widget = wibox.container.margin(cpupct3,5,0,0,0)
                  },
                    layout = wibox.container.rotate(widget, 'east'),
                },
                  layout  = wibox.layout.fixed.horizontal,
             },
                layout  = wibox.layout.fixed.vertical,

          },
               set_shape = function(cr, width, height, radius)
                  gears.shape.rounded_rect(cr, width, height, radius)
                end,
                bg                 = beautiful.widget_bg2,
                shape_border_color = beautiful.border_color,
                shape_border_width = 1,
                widget             = wibox.container.background,
           },
          layout = wibox.container.margin(widget,2,2,1,1),
        },


        {-- Сеть
          {
              {
                { -- Сеть текст
                  net_vicious,
                  layout = wibox.container.margin(net_vicious,3,3,0,0),
                },
                  layout  = wibox.layout.align.vertical,
                {
                  { -- Сеть граф загр
                    net_raph_d,
                    layout = wibox.container.margin(net_raph_d,3,0,4,5),
                  },
                  { -- Сеть граф отдача
                    net_raph_u,
                    layout = wibox.container.margin(net_raph_u,5,2,3,5),
                  },
                  layout  = wibox.layout.fixed.horizontal,
                },
                layout  = wibox.layout.fixed.vertical,
              },
              set_shape = function(cr, width, height)
                    gears.shape.rounded_rect(cr, width, height)
                  end,
              bg                 = beautiful.widget_bg2,
              shape_border_color = beautiful.border_color,
              shape_border_width = 1,
              widget             = wibox.container.background,
          },
          layout = wibox.container.margin(widget,2,2,1,1),
        },
        {
          {
            {
              {
                { -- /
                  {-- / текст
                    fstext_r,
                    layout = wibox.container.margin(fstext_r,7,0,5,0),
                  },
                  { -- / I/O R
                    fs_stat_graph_r_read,
                    layout  = wibox.container.margin(fs_stat_graph_r_read,40,0,5,0),
                  },
                  { -- / I/O W
                    fs_stat_graph_r_write,
                    layout = wibox.container.margin(fs_stat_graph_r_write,5,0,5,0),
                  },
                  layout = wibox.layout.fixed.horizontal,
                },
                layout = wibox.layout.fixed.vertical,
              },
            { -- / бар
              fsbar_r,
              layout = wibox.container.margin(fsbar_r,3,3,0,0),
            },
            layout = wibox.layout.fixed.vertical,
            { -- /home
              {-- /home текст
                fstext_h,
                layout = wibox.container.margin(fstext_h,7,0,3,0),
              },
              { -- /home I/O R
                fs_stat_graph_h_read,
                layout = wibox.container.margin(fs_stat_graph_h_read,10,0,3,0),
              },
              { -- /home I/O W
                fs_stat_graph_h_write,
                layout = wibox.container.margin(fs_stat_graph_h_write,5,0,3,0),
              },
              layout = wibox.layout.fixed.horizontal,
            },
            { -- /home бар
              fsbar_h,
              layout = wibox.container.margin(fsbar_h,3,3,0,5),
            },
          },
              set_shape = function(cr, width, height, radius)
                    gears.shape.rounded_rect(cr, width, height, radius)
              end,
              bg                 = beautiful.widget_bg2,
              shape_border_color = beautiful.border_color,
              shape_border_width = 1,
              widget             = wibox.container.background,
          },
          layout = wibox.container.margin(widget,2,2,1,1),
        },

        {
          {
            { -- Список процессов
                process_htop,
                layout = wibox.container.margin(process_htop,15,0,3,5),
            },
              set_shape = function(cr, width, height)
                    gears.shape.rounded_rect(cr, width, height)
                  end,
              bg                 = beautiful.widget_bg2,
              shape_border_color = beautiful.border_color,
              shape_border_width = 1,
              widget             = wibox.container.background,
          },
          layout = wibox.container.margin(widget,2,2,1,3),
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
