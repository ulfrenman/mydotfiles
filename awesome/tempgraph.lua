--------------------------------------------------------------------
-- TemperatureGraph
--
-- This widget is built as a learning project just to test out some
-- different ways of how a widget can be built. It is meant to show
-- current temperature readings of all sensors in the computer. I
-- guess lots of things could be enhanced and simplified.
--
-- To get it working I had to install sensors
--      $ sudo apt install sensors
--
-- To use it you first "import" it into the rc.lua together with
-- the other "imports" at the top:
--      local tempgraph = require("tempgraph")
-- Then use it in the wibox something like this;
--      s.mywibox:setup {
--          ...
--          { -- Right widgets
--              layout = wibox.layout.fixed.horizontal,
--              tempgraph{},
--              tempgraph(),
--              tempgraph({}),
--              tempgraph({timeout = 2}),
--              tempgraph({timeout = 2, test_spike = true}),
--
-- Everything here is hugely influenced by other widgets and
-- documentation:
--      https://awesomewm.org/doc/api/classes/awful.widget.watch.html
--      https://github.com/streetturtle/awesome-wm-widgets/
--      https://github.com/deficient/cpuinfo
--
-- Ulf Renman
--------------------------------------------------------------------
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local function TemperatureGraph(args)

    local args = args or {}
    local tooltip_prepend = args.tooltip_prepend or ''
    local timeout = args.timeout or 1
    local test_spike = args.test_spike or false

    local widget = wibox.widget{
        min_value = 0,
        max_value = 100,
        step_width = 2,
        step_spacing = 1,
        widget = wibox.widget.graph,
        color = {
            type = 'linear',
            from = {0,0},
            to = {0,40},
            stops = {
                {0.0, '#ff0000'},
                {0.6, '#8888ff'},
            }
        }
    }

    -- Create an initial spike just to show how it could look like
    if test_spike then
        widget:add_value(20)
        widget:add_value(40)
        widget:add_value(60)
        widget:add_value(80)
        widget:add_value(100)
        widget:add_value(120)
        widget:add_value(140)
    end

    -- Create the tooltip-thing. The tooltip content is then set in the watch
    -- function.
    tooltip = awful.tooltip({objects={widget}})

    awful.widget.watch(
        'sensors',
        timeout,
        function(w, stdout, stderr, exitreason, exitcode)
            tooltip:set_text(stdout)
            for line in stdout:gmatch("[^\r\n]+") do
                local m = line:match("Package id 0: *+(%d+)")
                if m then
                    -- cast m from string to int with 0+m
                    w:add_value(0+m)
                end
            end
        end,
        widget
    )

    return widget
end

return TemperatureGraph
