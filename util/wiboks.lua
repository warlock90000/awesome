local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local lain          = require("lain")
local radical       = require("radical")
local vicious       = require("vicious")

--[[ -- Radical tag
local rad_taglist  = require( "radical.impl.taglist"       )
local rad_tag      = require( "radical.impl.common.tag"    )
]]-- -- Radical tag

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

local tag_menu = radical.context {
        width = 170,
        layout = radical.layout.vertical,
        border_width = 2,
        border_color = "#88aa00",
        item_layout = radical.layout.centerred
    }
tag_menu:add_item{text="Add tag", button1 = function() lain.util.add_tag(); tag_menu.visible = false end}
tag_menu:add_item{text="Ren tag", button1 = function() lain.util.rename_tag(); tag_menu.visible = false end}
tag_menu:add_item{text="Tag left", button1 = function() lain.util.move_tag(1); tag_menu.visible = false end}
tag_menu:add_item{text="Tag right", button1 = function() lain.util.move_tag(-1); tag_menu.visible = false end}
tag_menu:add_item{text="Del tag", button1 = function() lain.util.delete_tag(); tag_menu.visible = false end}
tag_menu:add_item{text="Mv client->new tag", button1 = function() lain.util.move_to_new_tag(); tag_menu.visible = false end}
tag_menu:add_item{text="Cancel", button1 = function() tag_menu.visible = false end}

local l_m = wibox.widget.imagebox()
local l_menu = radical.context {
        width = 35,
        layout = radical.layout.vertical,
        border_width = 2,
        border_color = "#88aa00",
        item_layout = radical.layout.centerred
    }
  l_menu:add_item{icon = beautiful.layout_floating, button1 = function() awful.layout.set(awful.layout.suit.floating); l_menu.visible = false end}
  l_menu:add_item{icon = beautiful.layout_tile, button1 = function() awful.layout.set(awful.layout.suit.tile); l_menu.visible = false end}
  l_menu:add_item{icon = beautiful.layout_tileleft, button1 = function() awful.layout.set(awful.layout.suit.tile.left); l_menu.visible = false end}
  l_menu:add_item{icon = beautiful.layout_tilebottom, button1 = function() awful.layout.set(awful.layout.suit.tile.bottom); l_menu.visible = false end}
  l_menu:add_item{icon = beautiful.layout_tiletop, button1 = function() awful.layout.set(awful.layout.suit.tile.top); l_menu.visible = false end}
  l_menu:add_item{icon = beautiful.layout_fairv, button1 = function() awful.layout.set(awful.layout.suit.fair); l_menu.visible = false end}
  l_menu:add_item{icon = beautiful.layout_fairh, button1 = function() awful.layout.set(awful.layout.suit.fair.horizontal); l_menu.visible = false end}
  l_menu:add_item{icon = beautiful.layout_spiral, button1 = function() awful.layout.set(awful.layout.suit.spiral); l_menu.visible = false end}
  l_menu:add_item{icon = beautiful.layout_dwindle, button1 = function() awful.layout.set(awful.layout.suit.spiral.dwindle); l_menu.visible = false end}
  l_menu:add_item{icon = beautiful.layout_max, button1 = function() awful.layout.set(awful.layout.suit.max); l_menu.visible = false end}
  l_menu:add_item{icon = beautiful.layout_fullscreen, button1 = function() awful.layout.set(awful.layout.suit.max.fullscreen); l_menu.visible = false end}
  l_menu:add_item{icon = beautiful.layout_magnifier, button1 = function() awful.layout.set(awful.layout.suit.magnifier); l_menu.visible = false end}
  --[[
  l_menu:add_item{icon = beautiful.layout_cornernw, button1 = function() awful.layout.set(awful.layout.suit.corner.nw); l_menu.visible = false end}

  l_menu:add_item{icon = beautiful.layout_cornerse, button1 = function() awful.layout.set(lain.layout.cascade); l_menu.visible = false end}
  l_menu:add_item{icon = beautiful.layout_cornerse, button1 = function() awful.layout.set(lain.layout.cascade.tile); l_menu.visible = false end}
  l_menu:add_item{icon = beautiful.layout_cornerse, button1 = function() awful.layout.set(lain.layout.centerwork); l_menu.visible = false end}
  l_menu:add_item{icon = beautiful.layout_cornerse, button1 = function() awful.layout.set(lain.layout.centerwork.horizontal); l_menu.visible = false end}
  l_menu:add_item{icon = beautiful.layout_cornerse, button1 = function() awful.layout.set(lain.layout.termfair); l_menu.visible = false end}
  l_menu:add_item{icon = beautiful.layout_cornerse, button1 = function() awful.layout.set(lain.layout.termfair.center); l_menu.visible = false end}
  ]]--
  l_menu:add_item{text="Cnl", button1 = function() l_menu.visible = false end}


l_m.menu = l_menu


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
                    awful.button({ }, 3, function(t) tag_menu.visible = true end),
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
                           --awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           --awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    s.mylayoutbox.menu = l_menu
    --========= Create a taglist widget =========--
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)
    --========= Create a taglist widget =========--
    --========= Create a tasklist widget =========--
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons, { bg_focus = "#393f3f" })
    --s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.focused, tasklist_buttons, { align = "center" }, { bg_focus = "#00000000" })
    --========= Create a tasklist widget =========--
    local delim = {
                    {
                      {
                       widget = wibox.widget.textbox,
                       layout = wibox.container.margin(widget,8,8,0,0),
                      },
                       bg = beautiful.base00,
                       set_shape = function(cr, width, height)
                       gears.shape.powerline(cr, width, height, (height / 2) * (-1))
                       --gears.shape.powerline(cr, width, height, (height / 2) * (-1))
                      end,
                     widget = wibox.container.background
                    },
                    layout = wibox.container.margin(widget,0,-10,0,0),
                  }
    --========= Create the wibox =========--
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 20 })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.align.horizontal,
            {
              {
                {
                  START_btn,
                  layout = wibox.container.margin(mylauncher,15,15,0,0),
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
            --[[ -- Radical tag
            {
              {
                { --
                    rad_taglist(s)._internal.margin,
                    layout = wibox.container.margin(nil,0,0,0,0),
                },
                  bg = beautiful.base02,
                    set_shape = function(cr, width, height)
                      gears.shape.rounded_bar(cr, width, height)
                    end,
                  widget             = wibox.container.background,
              },
              layout = wibox.container.margin(widget,12,5,1,1),
            },
            ]]-- -- Radical tag
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
        -----------------------------------------------
            {
              {
                {
                  {
                    { -- MPD toggle
                      icon_control_toggle,
                      layout = wibox.container.margin(icon_control_toggle,7,0,1,1),
                    },
                    { -- MPD prev
                      icon_control_prev,
                      layout = wibox.container.margin(icon_control_prev,1,0,1,1),
                    },
                    { -- MPD next
                      icon_control_next,
                      layout = wibox.container.margin(icon_control_next,1,0,1,1),
                    },
                    { -- MPD next
                      icon_control_stop,
                      layout = wibox.container.margin(icon_control_stop,1,7,1,1),
                    },
                    layout  = wibox.layout.fixed.horizontal,
                  },
                    bg = beautiful.base02,
                      set_shape = function(cr, width, height)
                        gears.shape.rounded_bar(cr, width, height)
                      end,
                    widget = wibox.container.background,
                },
                layout = wibox.container.margin(widget,0,0,0,0),
              },
              {
                  {
                    {
                      mpdwidget.widget,
                      layout = wibox.container.place,
                    },
                    bg = beautiful.base02,
                    set_shape = function(cr, width, height)
                      gears.shape.rounded_bar(cr, width, height, (height / 2) * (-1))
                      --gears.shape.powerline(cr, width, height, (height / 2) * (-1))
                    end,
                    widget = wibox.container.background
                  },
                  layout = wibox.container.margin(widget,0,0,0,0),
              },
              layout = wibox.layout.align.horizontal,
          },
      -----------------------------------------------
          { -- Right widgets
            layout = wibox.layout.fixed.horizontal,

            {
              {
                {
                  wibox.widget.systray(),
                  layout = wibox.container.margin(wibox.widget.systray(),9,20,2,2),
                },
                bg = beautiful.base02,
                set_shape = function(cr, width, height)
                  gears.shape.rounded_bar(cr, width, height, (height / 2) * (-1))
                  --gears.shape.powerline(cr, width, height, (height / 2) * (-1))
                end,
                widget = wibox.container.background
              },
              layout = wibox.container.margin(widget,0,-14,0,0),
            },
            {
              {
                {
                  udisks.widget,
                  layout = wibox.container.margin(udisks.widget,7,14,2,2),
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
                  pkg_upd_count,
                  layout = wibox.container.margin(pkg_upd_count,5,19,0,2),
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
                  {
                    icon_widget,
                    layout = wibox.container.margin(icon_widget,10,-7,0,0),
                  },
                  {
                    myweather.widget,
                    layout = wibox.container.margin(myweather.widget,10,10,0,0),
                  },
                  layout  = wibox.layout.fixed.horizontal,
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
        ------local clock = require("util.clock")
        ------clock.new({ screen = s })
       --------------------------- Create the vertical wibox
    s.dockheight = (51 *  s.workarea.height)/100

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
                  layout = wibox.container.margin(sys,10,0,3,3),
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
                  layout = wibox.container.margin(mem_txt,10,4,3,3),
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
                     cpu,
                     layout = wibox.container.margin(cpu.widget,1,0,2,2),
                 },
                 { -- %
                     cpufreq_vicious,
                     layout = wibox.container.margin(cpufreq_vicious.widget,77,10,0,0),
                 },
                 layout  = wibox.layout.stack,
              },
                layout  = wibox.layout.align.vertical,
              { -- Проц, мать, видео - датчики
                    cpu_all,
                    layout = wibox.container.margin(test,11,0,0,3),
              },
                layout  = wibox.layout.align.vertical,
            {
              { -- Проц нагрузки
                cpu_txt,
                layout = wibox.container.margin(cpu_txt,4,0,2,6),
              },
               {
                 -- Проц графики
                  { -- цпу1 граф
                    cpugraph0,
                    layout = wibox.container.margin(cpugraph0,7,0,0,5),
                  },
                  { -- цпу2 граф
                    cpugraph1,
                    layout = wibox.container.margin(cpugraph1,7,0,0,5),
                  },
                  { -- цпу3 граф
                    cpugraph2,
                    layout = wibox.container.margin(cpugraph2,7,0,0,5),
                  },
                  { -- цпу4 граф
                    cpugraph3,
                    layout = wibox.container.margin(cpugraph3,7,7,0,5),
                  },
                    layout  = wibox.layout.flex.horizontal,
               },
                  layout  = wibox.layout.stack,
            },
              layout  = wibox.layout.align.vertical,
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
                {
                  {-- сеть загр
                    net_vicious1,
                    layout = wibox.container.margin(net_vicious1,7,0,2,0),
                  },
                  { -- сеть отдача
                    net_vicious2,
                    layout  = wibox.container.margin(net_vicious2,149,0,2,0),
                  },
                    layout = wibox.layout.stack,
                },
                layout  = wibox.layout.fixed.horizontal,
                {
                  { -- Сеть граф загр
                    net_raph_d,
                    layout = wibox.container.margin(net_raph_d,8,0,4,5),
                  },
                  { -- Сеть граф отдача
                    net_raph_u,
                    layout = wibox.container.margin(net_raph_u,8,0,4,5),
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
                    layout = wibox.container.margin(fstext_r,7,-8,5,0),
                  },
                  { -- / I/O R
                    fs_stat_graph_r_read,
                    layout  = wibox.container.margin(fs_stat_graph_r_read,153,76,5,0),
                  },
                  { -- / I/O W
                    fs_stat_graph_r_write,
                    layout = wibox.container.margin(fs_stat_graph_r_write,227,6,5,0),
                  },
                  layout = wibox.layout.stack,
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
                layout = wibox.container.margin(fs_stat_graph_h_read,153,76,5,0),
              },
              { -- /home I/O W
                fs_stat_graph_h_write,
                layout = wibox.container.margin(fs_stat_graph_h_write,227,6,5,0),
              },
              layout = wibox.layout.stack,
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
                layout = wibox.container.margin(process_htop,16,0,5,-3),
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

        { --
          {
              {
                {
                  net_icon,
                  layout = wibox.container.margin(net_icon,7,0,3,3),
                },
                {
                  ext_ip,
                  layout = wibox.container.margin(ext_ip,2,0,3,3),
                },
                { -- Баланс
                  balans_widget,
                  layout = wibox.container.margin(balans_widget,12,5,3,3),
                },
                layout  = wibox.layout.align.horizontal,
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

    }

    -- Add toggling functionalities
    s.docktimer = gears.timer{ timeout = 13 }
    s.dock_wibox_timer = gears.timer{ timeout = 6 }

    s.docktimer:connect_signal("timeout", function()
        s = awful.screen.focused()
        s.dock_wibox.width = 1
        s.dock_wibox.y = s.workarea.height/2 - s.dockheight/2
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
        s.dock_wibox_timer:start()
        s.dock_wibox.width = 1
        --vicious.suspend()
    end)

    s.dock_wibox:connect_signal("mouse::enter", function()
        --vicious.activate()
        s = awful.screen.focused()
        s.dock_wibox.width = 300
        s.dock_wibox.y = s.workarea.height/2 - s.dockheight/2
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
    --[[
    local dockshape_1 = function(cr, width, height)
      gears.shape.rounded_bar(cr, width, width)
    end

    s.dockheight_2 = (51 *  s.workarea.height)/100

    s.dock_wibox_2 = wibox({ screen = s, x=1000, y=s.workarea.height/2 - s.dockheight/2, width = 300, height = s.dockheight, fg = beautiful.menu_fg_normal, bg = beautiful.widget_bg1, ontop = true, visible = true, type = "dock" })
    gears.surface.apply_shape_bounding(s.dock_wibox_2, dockshape_1)

    if s.index > 1 and s.dock_wibox_2.y == 0 then
        s.dock_wibox_2.y = screen[1].dock_wibox_2.y
    end
    s.dock_wibox_2:setup {
        layout = wibox.layout.fixed.vertical,
        analogclock,
    }
    ]]--
end)
-- }}}