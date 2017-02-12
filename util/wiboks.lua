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

-- {{{ Wibox
-- Create a wibox for each screen and add it

taglist_buttons = awful.util.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
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
                    widget = mytextclock
                  },
                  left   = 10,
                  right  = 17,
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

end)
-- }}}
