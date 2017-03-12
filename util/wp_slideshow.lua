local WallpaperSlide = {}
WallpaperSlide.__index = WallpaperSlide

function WallpaperSlide:new( basedir, align ,interval )
  local obj = {}
  local timer = require('gears').timer
  setmetatable(obj, WallpaperSlide)
  obj.basedir = basedir                    -- Set wallpaper scanning basedir
  obj.align = align                        -- Send to gears.wallpaper
  obj.timer = timer({timeout=interval})    -- Set timer
  obj.handle = require('gears').wallpaper  -- Wallpaper handle
  obj.target = screen                      --
  obj.notifier = require('naughty').notify -- notify handle
  obj:scandir()
  return obj
end

function WallpaperSlide:scandir()
  local i, t = 0, {}

  handle = io.popen("find " .. self.basedir .. " -name \"*.jpg\" -or -name \"*.png\"")
  result = handle:lines()
  for filename in result do
    i = i + 1
    t[i] = filename
  end
  self.wp_list = t
  handle:close()


end

function WallpaperSlide:nextWallpaper()

    -- get random index
    math.randomseed(os.clock()*100000000000)
    self.wp_index = math.random( 1, #self.wp_list)

    for s = 1, screen.count() do
      self.handle[self.align](self.wp_list[self.wp_index], s)
    end

    self.notifier({text = self.wp_list[self.wp_index]})
    os.execute(table.concat({
      "gsettings",
      "set",
      "org.cinnamon.desktop.background",
      "picture-uri",
      "'file://" ..
      self.wp_list[self.wp_index],
      }, " ").."'")

end

function WallpaperSlide:run()
  self.notifier({text = "Слайдшоу запущено"})
  self.notifier({text = "Картинки меняются через " .. self.timer.timeout .. " сек."})
  self.notifier({text = #self.wp_list .. " картинок в списке."})

  self.timer:connect_signal("timeout", function()
    self:nextWallpaper()
  end)

  self.timer:start()
end

return WallpaperSlide
