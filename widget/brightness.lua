--[[

     Licensed under GNU General Public License v2
      * (c) 2013, Luke Bonham
      * (c) 2010, Adrian C. <anrxc@sysphere.org>

--]]

local helpers = require("lain.helpers")
local shell   = require("awful.util").shell
local wibox   = require("wibox")
local string  = { match  = string.match,
                  format = string.format }

-- Screen brightness
-- lain.widget.brightness

local function factory(args)
    local light    = { widget = wibox.widget.textbox() }
    local args     = args or {}
    local timeout  = args.timeout or 5
    local settings = args.settings or function() end

    light.cmd      = args.cmd or "xbacklight"

    local format_cmd = string.format("%s -get", light.cmd)

    light.last = {}

    function light.update()
        helpers.async(format_cmd, function(xbacklight)
            local l = tonumber(string.format("%.0f", xbacklight))
            if light.last.level ~= l then
                brightness_now = { level = l }
                widget = light.widget
                settings()
                light.last = brightness_now
            end
        end)
    end

    helpers.newtimer(string.format("%s -get", light.cmd), timeout, light.update)

    return light
end

return factory
