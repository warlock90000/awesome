---------------------------------------------------
-- Licensed under the GNU General Public License v2
--  * (c) 2010, Adrian C. <anrxc@sysphere.org>
---------------------------------------------------
local helpers      = require("lain.helpers")
-- {{{ Grab environment
local io = { popen = io.popen }
local math = { max = math.max }
local setmetatable = setmetatable
local mark1 = "<span color=\"#80d9d8\" font=\"xos4 Terminus Bold 11\">"
local mark2 = "</span>"
-- }}}


-- Pkg: provides number of pending updates on UNIX systems
-- vicious.widgets.pkg
local pkg = {}

function pkgbase_update()
            local com = "kdesu yaourt -Sy"
            helpers.async(com, function(f)
            end)
        return
    end

-- {{{ Packages widget type
local function worker(format, warg)
    if not warg then return "Not warg"
    end

    -- Initialize counters
    local updates = 0
    local manager = {
        ["Arch"]   = { cmd = "yaourt -Qua" },
        ["Arch C"] = { cmd = "checkupdates" },
        ["Arch S"] = { cmd = "yes | pacman -Sup", sub = 1 }
    }

    -- Check if updates are available
    --pkgbase_update()
    local _pkg = manager[warg]
    local f = io.popen(_pkg.cmd)

    for line in f:lines() do
        updates = updates + 1
    end
    f:close()
updates = mark1 .. updates .. mark2
    return {_pkg.sub and math.max(updates-_pkg.sub, 0) or updates}
end
-- }}}

return setmetatable(pkg, { __call = function(_, ...) return worker(...) end })
