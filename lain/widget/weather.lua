
--[[

     Licensed under GNU General Public License v2
      * (c) 2015, Luke Bonham

--]]

local helpers  = require("lain.helpers")
local json     = require("lain.util").dkjson
local awful         = require("awful")
local focused  = require("awful.screen").focused
local naughty  = require("naughty")
local wibox    = require("wibox")

local math     = { floor    = math.floor }
local os       = { time     = os.time,
                   date     = os.date,
                   difftime = os.difftime }
local string   = { format   = string.format,
                   gsub     = string.gsub }
local tonumber = tonumber

-- OpenWeatherMap
-- current weather and X-days forecast
-- lain.widget.weather

local function factory(args)
    local weather               = { widget = wibox.widget.textbox() }
    local args                  = args or {}
    local APPID                 = args.APPID or "3e321f9414eaedbfab34983bda77a66e" -- lain default
    local timeout               = args.timeout or 900   -- 15 min
    local timeout_forecast      = args.timeout or 86400 -- 24 hrs
    local current_call          = args.current_call  or "curl -s 'http://api.openweathermap.org/data/2.5/weather?id=%s&units=%s&lang=%s&APPID=%s'"
    local forecast_call         = args.forecast_call or "curl -s 'http://api.openweathermap.org/data/2.5/forecast/daily?id=%s&units=%s&lang=%s&cnt=%s&APPID=%s'"
    local city_id               = args.city_id or 0 -- placeholder
    local utc_offset            = args.utc_offset or
                                  function ()
                                      local now = os.time()
                                      return os.difftime(now, os.time(os.date("!*t", now))) + ((os.date("*t").isdst and 1 or 0) * 3600)
                                  end
    local units                 = args.units or "metric"
    local lang                  = args.lang or "ru"
    local cnt                   = args.cnt or 5
    local date_cmd              = args.date_cmd or "date -u -d @%d +'%%a %%d'"
    local icons_path            = args.icons_path or helpers.icons_dir .. "openweathermap/"
    local notification_preset   = args.notification_preset or {}
    local notification_text_fun = args.notification_text_fun or
                                  function (wn)
                                      local day = os.date("%a %d", wn["dt"])
                                      local tmin = math.floor(wn["temp"]["min"])
                                      local tmax = math.floor(wn["temp"]["max"])
                                      local desc = wn["weather"][1]["description"]
                                      local pres = math.floor(wn["pressure"])
                                      local humi = wn["humidity"]
                                      local tnight = math.floor(wn["temp"]["night"])
                                      local teve = math.floor(wn["temp"]["eve"])
                                      local tmorn = math.floor(wn["temp"]["morn"])
                                      return string.format("<b>%s</b>: %s, %d | %d  н: %s д: %s у: %s", day, desc, tmin, tmax, tnight, teve, tmorn)
                                  end
    local weather_na_markup     = args.weather_na_markup or " N/A "
    local followtag             = args.followtag or false
    local settings              = args.settings or function() end

    weather.widget:set_markup(weather_na_markup)
    weather.icon_path = icons_path .. "na.png"
    weather.icon = wibox.widget.imagebox(weather.icon_path)

    function weather.show(t_out)
        weather.hide()

        if followtag then
            notification_preset.screen = focused()
        end

        if not weather.notification_text then
            weather.update()
            weather.forecast_update()
        end

        weather.notification = naughty.notify({
            text    = weather.notification_text,
            icon    = weather.icon_path,
            timeout = t_out,
            preset  = notification_preset
        })
    end

    function weather.hide()
        if weather.notification then
            naughty.destroy(weather.notification)
            weather.notification = nil
        end
    end

    local color3     = "<span color=\"#ffffff\">"
    local span_end   = "</span>"

    function weather.show_txt()
        local conn_stat   = [[zsh -c 'curl -H "Accept-Language: ru" wttr.in/"Нижний Тагил?T?1?Q" | head -n15']]
        awful.spawn.easy_async(conn_stat, function(stdout)
          naughty.notify {
            text          = color3 .. stdout .. span_end,
            position      = 'top_right',
            timeout       = 20,
            bg            = "#202020"
          }
          end)
    end
    function weather.show_full_txt()
        local conn_stat   = [[zsh -c 'curl -H "Accept-Language: ru" wttr.in/"Нижний Тагил?T?Q" | head -n35']]
        awful.spawn.easy_async(conn_stat, function(stdout)
          naughty.notify {
            text          = color3 .. stdout .. span_end,
            position      = 'top_right',
            timeout       = 20,
            bg            = "#202020dF"
          }
          end)
    end
    function weather.attach(obj)
        obj:buttons(awful.util.table.join(
            awful.button({ }, 1, function () weather.show_txt() end),
            awful.button({ }, 3, function () weather.show_full_txt() end),
            awful.button({ }, 9, function () weather.show(0) end),
            awful.button({ }, 8, function () weather.hide() end)
        ))
    end

--[[
info.weather.yandex.net/11168/2.ru.png?domain=ru
http://www.yr.no/place/Russia/Sverdlovsk/Nizhniy_Tagil/meteogram.png
http://www.meteoinfo.ru/informer/informer.php?ind=28240&type=4&color=0
http://www.realmeteo.ru/ntagil/2/informers

curl -s 'http://api.openweathermap.org/data/2.5/forecast/daily?id=520494&units=metric&lang=ru&cnt=5&APPID=3e321f9414eaedbfab34983bda77a66e'
{"city":{"id":520494,
        "name":"Nizhniy Tagil",
        "coord":{"lon":59.965,"lat":57.919441},
        "country":"RU","population":0},
        "cod":"200",
        "message":0.015,
        "cnt":5,
        "list":[{"dt":1486454400,
                "temp":{"day":-20.31,"min":-30.76,"max":-20.31,"night":-30.76,"eve":-26.07,"morn":-22.03},
                "pressure":1014.6,
                "humidity":62,
                "weather":[{"id":600,"main":"Snow","description":"небольшой снегопад","icon":"13d"}],
                "speed":1.61,"deg":26,"clouds":32,"snow":0.05},{"dt":1486540800,
                "temp":{"day":-20.98,"min":-31.62,"max":-20.98,"night":-30.79,"eve":-28.48,"morn":-31.62},"pressure":1014.47,"humidity":71,"weather":[{"id":800,"main":"Clear","description":"ясно","icon":"01d"}],"speed":1.56,"deg":59,"clouds":12,"snow":0.02},{"dt":1486627200,"temp":{"day":-21.26,"min":-27.3,"max":-21.26,"night":-24.19,"eve":-22.95,"morn":-27.3},"pressure":1010.24,"humidity":58,"weather":[{"id":600,"main":"Snow","description":"небольшой снегопад","icon":"13d"}],"speed":1.58,"deg":88,"clouds":64,"snow":0.64},{"dt":1486713600,"temp":{"day":-29.05,"min":-31.45,"max":-21.92,"night":-28.51,"eve":-21.92,"morn":-31.45},"pressure":1008.13,"humidity":0,"weather":[{"id":800,"main":"Clear","description":"ясно","icon":"01d"}],"speed":1.03,"deg":241,"clouds":5},{"dt":1486800000,"temp":{"day":-26.24,"min":-30.53,"max":-22.6,"night":-28.63,"eve":-22.6,"morn":-30.53},"pressure":1006.58,"humidity":0,"weather":[{"id":800,"main":"Clear","description":"ясно","icon":"01d"}],"speed":1.03,"deg":11,"clouds":47,"snow":0.01}]}
]]--
    function weather.forecast_update()
        local cmd = string.format(forecast_call, city_id, units, lang, cnt, APPID)
        helpers.async(cmd, function(f)
            local pos, err
            weather_now, pos, err = json.decode(f, 1, nil)

            if not err and type(weather_now) == "table" and tonumber(weather_now["cod"]) == 200 then
                weather.notification_text = ''
                for i = 1, weather_now["cnt"] do
                    weather.notification_text = weather.notification_text ..
                                                notification_text_fun(weather_now["list"][i])

                    if i < weather_now["cnt"] then
                        weather.notification_text = weather.notification_text .. "\n"
                    end
                end
            end
        end)
    end
--[[
http://api.openweathermap.org/data/2.5/weather?id=520494&appid=3e321f9414eaedbfab34983bda77a66e&lang=ru&units=metric
{"coord":
    {"lon":59.97,"lat":57.92},
    "weather":[{"id":802,"main":"Clouds","description":"слегка облачно","icon":"03d"}],
    "base":"stations",
    "main":{"temp":-22.04,"pressure":1014.6,"humidity":62,"temp_min":-22.04,"temp_max":-22.04,"sea_level":1047.86,"grnd_level":1014.6},
    "wind":{"speed":1.61,"deg":25.5012},
    "clouds":{"all":32},"dt":1486453286,
    "sys":{"message":0.0152,"country":"RU","sunrise":1486439374,"sunset":1486471191},
    "id":520494,"name":"Nizhniy Tagil","cod":200
}
]]--
    function weather.update_meteogram()
            local com = "curl -s 'http://www.yr.no/place/Russia/Sverdlovsk/Nizhniy_Tagil/meteogram.png' -o /tmp/1.png"
            helpers.async(com, function(f)
            end)
        return
    end

    function weather.update()
        local cmd = string.format(current_call, city_id, units, lang, APPID)
        helpers.async(cmd, function(f)
            local pos, err, icon
            weather_now, pos, err = json.decode(f, 1, nil)

            if not err and type(weather_now) == "table" and tonumber(weather_now["cod"]) == 200 then
                -- weather icon based on localtime
                local now     = os.time()
                local sunrise = tonumber(weather_now["sys"]["sunrise"])
                local sunset  = tonumber(weather_now["sys"]["sunset"])
                local icon    = weather_now["weather"][1]["icon"]
                local loc_m   = os.time { year = os.date("%Y"), month = os.date("%m"), day = os.date("%d"), hour = 0 }
                local offset  = utc_offset()
                local utc_m   = loc_m - offset
--[[
                if offset > 0 and (now - utc_m)>=86400 then
                    utc_m = utc_m + 86400
                elseif offset < 0 and (utc_m - now)>=86400 then
                    utc_m = utc_m - 86400
                end

                -- if we are 1 day after the GMT, return 1 day back, and viceversa
                if offset > 0 and loc_m >= utc_m then
                    now = now - 86400
                elseif offset < 0 and loc_m <= utc_m then
                    now = now + 86400
                end

                if sunrise <= now and now <= sunset then
                    icon = string.gsub(icon, "n", "d")
                else
                    icon = string.gsub(icon, "d", "n")
                end

                weather.icon_path = icons_path .. icon .. ".png"
                widget = weather.widget
                settings()
            else
                weather.icon_path = icons_path .. "na.png"
                weather.widget:set_markup(weather_na_markup)
]]--
                weather.update_meteogram()
                weather.icon_path = "/tmp/1.png"
                widget = weather.widget
                settings()
            end
            weather.icon:set_image(weather.icon_path)
        end)
    end

    weather.attach(weather.widget)

    weather.timer = helpers.newtimer("weather-" .. city_id, timeout, weather.update, false, true)
    weather.timer_forecast = helpers.newtimer("weather_forecast-" .. city_id, timeout, weather.forecast_update, false, true)

    return weather
end

return factory
