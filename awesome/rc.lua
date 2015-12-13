-- Anshicat theme

-- MPD widget is broken btw

-- Required libraries
local gears = require("gears")
local lain = require ("lain")

local awful = require ("awful") 
local vicious = require ("vicious")
local naughty = require ("naughty")

awful.rules = require("awful.rules")
              require("awful.autofocus")
local blingbling = require("blingbling")

local wibox = require("wibox")
local beautiful = require("beautiful")


local xdg_menu = require("archmenu")

do
    local sterr = false
    awesome.connect_signal("debug::error", function(err)
        if sterr then return end
        sterr = true
        naughty.notify({ preset = naughty.config.presets.critical,
                       title = "Error",
                       text = err })
        sterr = false
    end)
end


-- Vars 
os.setlocale(os.getenv("LANG"))
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/Anshicat/theme.lua")

autohide_titlebars = true
autohide_topbar = false

modkey     = "Mod4"
altkey     = "Mod1"
terminal   = "urxvt"
align_widgets_screen_1 = true
wallpaper_1 = os.getenv("HOME") .. "/Pictures/Wallpapers/japanedit3.png"
wallpaper_2 = ""

-- Tags
local layouts = {
	--1
    awful.layout.suit.floating,
	--2
    awful.layout.suit.tile,
	--3
    awful.layout.suit.tile.bottom,
	--4
    awful.layout.suit.fair,
	--5
    awful.layout.suit.magnifier,
	--6
    awful.layout.suit.max,
	--7
    lain.layout.termfair,
	--8
    lain.layout.centerwork,
	--9
    lain.layout.uselessfair
}

tags = {
   names = { "1", "2", "3", "4", "5"},
}

for s = 1, screen.count() do
    tags[s] = awful.tag(tags.names, s, layouts[1])
end


-- Wallpaper setup

if wallpaper_1 ~= "" and wallpaper_2 == "" then

    for s = 1, screen.count() do
        gears.wallpaper.maximized(wallpaper_1, s)
    end

elseif wallpaper_1 ~= "" and wallpaper_2 ~= "" then
    
        gears.wallpaper.maximized(wallpaper_1, 1)
        gears.wallpaper.maximized(wallpaper_2, 2) 
end

-- Menu

mymainmenu = awful.menu({ items = { 

{ "applications", xdgmenu },
{ "open terminal", terminal },
{ "firefox", 'firefox'}
     
}})
                                                                                                      
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- Wibox

mpd = wibox.widget.textbox()
--mpdupdater = timer({ timeout = 2 })
--mpdupdater:connect_signal("timeout", function() mpd:set_text(crrSong()) end )
--mpdupdater:start()

function crrSong() 

    local s = string.sub(awful.util.pread("ncmpcpp --current-song"), 8, -1)

    return s
end

markup = lain.util.markup

memory = lain.widgets.mem({
    settings = function()
        widget:set_text(" " .. mem_now.used .. "MB ")
    end
})

cpu = lain.widgets.cpu({
    settings = function()
        widget:set_text(" " .. cpu_now.usage .. "% ")
    end
})

cpu_graph = blingbling.line_graph({ 
 height = 18,
 width = 100,
 show_text = false,
 rounded_size = 1,
 graph_background_color = beautiful.bg_focus
})
cpu_graph:set_graph_line_color("#B00042")
cpu_graph:set_graph_color("#B00042")
vicious.register(cpu_graph, vicious.widgets.cpu,'$1',2)

temp = lain.widgets.temp({
    settings = function()
        widget:set_text(" CORE: " .. coretemp_now .. "°C ")
    end
})



spr = wibox.widget.textbox()
spr:set_markup("<span color='#D81860'> II </span>")
sprb = wibox.widget.textbox ('  ')

bar = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(

                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ }, 3, awful.tag.viewtoggle))
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, 
                        function (c)
                            if c == client.focus then
                                c.minimized = true
                            else
                                -- Without this, the following
                                -- :isvisible() makes no sense
                                c.minimized = false
                                if not c:isvisible() then
                                    awful.tag.viewonly(c:tags()[1])
                                end
                                    -- This will also un-minimize
                                    -- the client, if needed
                                    client.focus = c
                                    c:raise()
                            end
                        end),

                     awful.button({ }, 3, 
                        function ()
                            if instance then
                                instance:hide()
                                instance = nil
                            else
                                instance = awful.menu.clients({ 
                                theme={ width=250 }
                                                  })
                            end
                        end),

                     awful.button({ }, 4, 
                        function ()
                            awful.client.focus.byidx(1)
                            if client.focus then 
                                client.focus:raise() 
                            end
                        end),

                     awful.button({ }, 5, 
                        function ()
                            awful.client.focus.byidx(-1)
                            if client.focus then 
                                client.focus:raise() 
                            end
                        end))


for s = 1, screen.count() do

    mypromptbox[s] = awful.widget.prompt()
    mylayoutbox[s] = awful.widget.layoutbox(s)

    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.alltags, mytasklist.buttons)

    bar[s] = awful.wibox({ position = "top", screen = s, height = 20})

    local left_layout = wibox.layout.fixed.horizontal()
    local right_layout = wibox.layout.fixed.horizontal()
    
    -- Adds the left layout items and right layout items 
    if not align_widgets_screen_1 then
        if s == 1 then

            left_layout:add(mytaglist[s])
        end

        if s == 2 then 
    
            right_layout:add(memory)
            right_layout:add(spr)
            right_layout:add(cpu)
            right_layout:add(spr)
            right_layout:add(temp)
            right_layout:add(spr)
            right_layout:add(sprb)
            right_layout:add(mylayoutbox[s])
        end
        -- Adds all layout items to wibox
        local layout = wibox.layout.align.horizontal()

        layout:set_left(left_layout)
        layout:set_middle(mytasklist[s])
        layout:set_right(right_layout)
        bar[s]:set_widget(layout)

    else
        if s == 1 then

            left_layout:add(mytaglist[s])
            left_layout:add(sprb)
            left_layout:add(mpd)
            left_layout:add(sprb)
            right_layout:add(memory)
            right_layout:add(spr)
            right_layout:add(cpu)
            --right_layout:add(spr)
            --right_layout:add(cpu_graph)
            right_layout:add(spr)
            right_layout:add(temp)
            right_layout:add(sprb)
            right_layout:add(sprb)
            left_layout:add(mylayoutbox[s])
        end

        -- Adds all layout items to wibox
        local layout = wibox.layout.align.horizontal()

        layout:set_left(left_layout)
        --layout:set_middle(mytasklist[s])
        layout:set_right(right_layout)
        bar[s]:set_widget(layout)
    end


    if autohide_topbar then
        bar[s].visible = false
    end
end

--Mouse Bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
))

--Key bindings

globalkeys = awful.util.table.join(
    

--Time

awful.key({ modkey }, "b", function() naughty.notify({ 
	text=string.format("%s %s", "The time is", os.date ("%I:%M"))})
end),
						
    
awful.key({ modkey },"x",     

function ()

awful.util.spawn("dmenu_run -i -fn 'Cousine-9' -p 'Run command:' -nb '" .. 
 	beautiful.dmenu_bg_normal .. "' -nf '" .. beautiful.dmenu_fg_normal .. 
	"' -sb '" .. beautiful.dmenu_bg_focus .. 
	"' -sf '" .. beautiful.dmenu_fg_focus .. "'") 
end),

awful.key({ modkey } , "e" , function () awful.util.spawn('thunar')    end),

  
awful.key({ altkey }, "p", function() awful.util.spawn("scrot") end),
awful.key({ altkey }, "l", function() awful.util.spawn_with_shell("python ~/movess.py") end),

    
awful.key({ modkey }, "Left", function () lain.util.tag_view_nonempty(-1) end),
awful.key({ modkey }, "Right", function () lain.util.tag_view_nonempty(1) end),

-- Default client focus
    
awful.key({ altkey }, "k",
    function ()
        awful.client.focus.byidx( 1)
        if client.focus then client.focus:raise() end
    end),
awful.key({ altkey }, "j",
    function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),

    -- By direction client focus
    awful.key({ modkey }, "j",
    function()
        awful.client.focus.bydirection("down")
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "k",
    function()
        awful.client.focus.bydirection("up")
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "h",
    function()
        awful.client.focus.bydirection("left")
        if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "l",
    function()
        awful.client.focus.bydirection("right")
        if client.focus then client.focus:raise() end
    end),

    
    awful.key({ modkey }, "z", function ()
        for s=1, screen.count() do 
            bar[s].visible = not bar[s].visible
        end
    end),

-- Layout manipulation
    
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () beautiful.useless_gap_width = beautiful.useless_gap_width + 5 end),
    awful.key({ modkey, "Control" }, "k", function () beautiful.useless_gap_width = beautiful.useless_gap_width - 5 end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",

        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    awful.key({ altkey, "Shift"   }, "l",      function () awful.tag.incmwfact( 0.05)     end),
    awful.key({ altkey, "Shift"   }, "h",      function () awful.tag.incmwfact(-0.05)     end),
    awful.key({ modkey, "Shift"   }, "l",      function () awful.tag.incnmaster(-1)       end),
    awful.key({ modkey, "Shift"   }, "h",      function () awful.tag.incnmaster( 1)       end),
    awful.key({ modkey, "Control" }, "l",      function () awful.tag.incncol(-1)          end),
    awful.key({ modkey, "Control" }, "h",      function () awful.tag.incncol( 1)          end),
    awful.key({ modkey,           }, "space",  function () awful.layout.inc(layouts,  1)  end),
    awful.key({ modkey, "Shift"   }, "space",  function () awful.layout.inc(layouts, -1)  end),
    awful.key({ modkey, "Control" }, "n",      awful.client.restore),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r",      awesome.restart),
    awful.key({ modkey, "Shift"   }, "q",      awesome.quit),
    awful.key({ modkey }, "",

        function ()
            awful.prompt.run({ prompt = "Run Lua code: " },
            mypromptbox[mouse.screen].widget,
            awful.util.eval, nil,
            awful.util.getdir("cache") .. "/history_eval")
        end)
)


clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "p",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "n",

        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),


    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),

    awful.key({ modkey }, "t",
        function (c)
            -- toggle titlebar
            awful.titlebar.toggle(c)
        end)
)



-- Bind all key numbers to tags.
-- be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9,

        function ()
            local screen = mouse.screen
            local tag = awful.tag.gettags(screen)[i]
                if tag then
                    awful.tag.viewonly(tag)
                end
        end),

        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,

            function ()
                local screen = mouse.screen
                local tag = awful.tag.gettags(screen)[i]
                    if tag then
                        awful.tag.viewtoggle(tag)
                    end
            end),

        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,

                function ()
                    if client.focus then
                        local tag = awful.tag.gettags(client.focus.screen)[i]
                        if tag then
                              awful.client.movetotag(tag)
                    end
                end

end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,

            function ()
                if client.focus then
                    local tag = awful.tag.gettags(client.focus.screen)[i]
                        if tag then
                              awful.client.toggletag(tag)
                        end
                end
            end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))




-- Rules

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
    properties = { border_width = beautiful.border_width,
    border_color = beautiful.border_normal,
    focus = awful.client.focus.filter,
    raise = true,
    keys = clientkeys,
    buttons = clientbuttons,
    size_hints_honor = false },
    callback = awful.client.setslave},

}

-- Signals

client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = true
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local middle_layout = wibox.layout.flex.horizontal()

        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")

        --middle_layout:add(title)
        middle_layout:buttons(buttons)

        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_middle(middle_layout)
        awful.titlebar(c):set_widget(layout)

        if autohide_titlebars then
            awful.titlebar.hide(c)
        end
    end
end)

-- No border for maximized clients

client.connect_signal("focus",
    function(c)
        if c.maximized_horizontal == true and c.maximized_vertical == true then
            c.border_width = 0
        else
            c.border_color = beautiful.border_focus
        end
    end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

root.keys(globalkeys)

-- Hide wibox

for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
        local clients = awful.client.visible(s)
        local layout  = awful.layout.getname(awful.layout.get(s))

        if #clients > 0 then -- Fine grained borders and floaters control
            for _, c in pairs(clients) do -- Floaters always have borders
                if awful.client.floating.get(c) or layout == "floating" then
                    c.border_width = beautiful.border_width

                -- No borders with only one visible client
                elseif #clients == 1 or layout == "max" then
                    c.border_width = 0
                else
                    c.border_width = beautiful.border_width
                end
            end
        end
      end)
end


