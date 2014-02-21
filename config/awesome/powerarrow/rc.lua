-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")

-- Theme handling library
require("beautiful")

-- Notification library
require("naughty")

-- Load Debian menu entries
require("debian.menu")

-- Load Widgets
require("vicious")
require('couth.couth')
require('couth.alsa')
require("blingbling")

-- Additional file with functions
require("helpers")

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Theme
config_dir = ("/home/agalitsyn/.config/awesome/")
themes_dir = (config_dir .. "/themes")
beautiful.init(themes_dir .. "/powerarrow/theme.lua")
-- }}}

-- {{{ Variable definitions
modkey = "Mod4"
altkey = "Mod1"

terminal = "x-terminal-emulator"
editor = os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor

--  Couth Alsa volume applet
couth.CONFIG.ALSA_CONTROLS = { 'Master', 'PCM' }

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
tags = {}
for s = 1, screen.count() do
    tags[s] = awful.tag({ "main»", "dev»", "term»", "mail»", "misc»" }, s, layouts[1])
end
-- }}}

-- {{{ Naughty theme
naughty.config.default_preset.font = beautiful.notify_font
naughty.config.default_preset.fg = beautiful.notify_fg
naughty.config.default_preset.bg = beautiful.notify_bg
naughty.config.presets.normal.border_color = beautiful.notify_border
naughty.config.presets.normal.opacity = 0.8
naughty.config.presets.low.opacity = 0.8
naughty.config.presets.critical.opacity = 0.8
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
  { "appearance", "lxappearance" },
  { "manual", terminal .. " -e man awesome" },
  { "edit config", editor_cmd .. " " .. awesome.conffile },
  {"hibernate",  "sudo pm-hibernate"},
  {"restart", awesome.restart },
  {"reboot", "sudo reboot"},
  {"quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Debian", debian.menu.Debian_menu.Debian },
                                    { "PCmanFM", "pcmanfm" },
                                    { "Terminal", terminal },
                                    { "Firefox", "firefox", beautiful.firefox_icon },
                                    { "Chrome", "google-chrome", beautiful.chromium_icon },
                                    {" Luakit", "luakit", beautiful.luakit_icon},
                                    { "Claws", "claws-mail" },
                                    { "Skype", "skype", beautiful.skype_icon },
                                    {" Droppox", "dropbox", beautiful.dropbox_icon},
                                    { "PhpStorm", "phpstorm" },
                                    {" SublimeText", "sublime_text", beautiful.sublime_icon},
                                    {" Gimp", "gimp", beautiful.gimp_icon},
                                    {" Inkscape", "inkscape", beautiful.inkscape_icon},
                                    {" VLC", "vlc", beautiful.vlc_icon}
                                    {" LibreOffice Base", "libreoffice --base", beautiful.librebase_icon},
                                    {" LibreOffice Calc", "libreoffice --calc", beautiful.librecalc_icon},
                                    {" LibreOffice Draw", "libreoffice --draw", beautiful.libredraw_icon},
                                    {" LibreOffice Impress", "libreoffice --impress", beautiful.libreimpress_icon},
                                    {" LibreOffice Math", "libreoffice --math", beautiful.libremath_icon},  
                                    {" LibreOffice Writer", "libreoffice --writer", beautiful.librewriter_icon}
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ Widgets

--{{---| Chat widget |------------------------------------------------------------------------------

chaticon = widget ({type = "imagebox" })
chaticon.image = image(beautiful.widget_chat)
chaticon:buttons(awful.util.table.join(awful.button({ }, 1,
                 function () awful.util.spawn_with_shell(chat) end)))

--{{---| Mail widget |------------------------------------------------------------------------------

mailicon = widget ({type = "imagebox" })
mailicon.image = image(beautiful.widget_mail)
mailicon:buttons(awful.util.table.join(awful.button({ }, 1, 
                 function () awful.util.spawn_with_shell(mailmutt) end)))

--{{---| Music widget |-----------------------------------------------------------------------------

music = widget ({type = "imagebox" })
music.image = image(beautiful.widget_music)
music:buttons(awful.util.table.join(
              awful.button({ }, 1, function () awful.util.spawn_with_shell(musicplr) end),
              awful.button({ modkey }, 1, function () awful.util.spawn_with_shell("ncmpcpp toggle") end),
              awful.button({ }, 3, function () couth.notifier:notify( couth.alsa:setVolume('Master','toggle')) end),
              awful.button({ }, 4, function () couth.notifier:notify( couth.alsa:setVolume('PCM','2dB+')) end),
              awful.button({ }, 5, function () couth.notifier:notify( couth.alsa:setVolume('PCM','2dB-')) end),
              awful.button({ }, 4, function () couth.notifier:notify( couth.alsa:setVolume('Master','2dB+')) end),
              awful.button({ }, 5, function () couth.notifier:notify( couth.alsa:setVolume('Master','2dB-')) end)))

--{{---| TaskWarrior widget |-----------------------------------------------------------------------

task_warrior = blingbling.task_warrior.new(beautiful.widget_task)
task_warrior:set_task_done_icon(beautiful.task_done_icon)
task_warrior:set_task_icon(beautiful.task_icon)
task_warrior:set_project_icon(beautiful.project_icon)

--{{---| MEM widget |-------------------------------------------------------------------------------

memwidget = widget({ type = "textbox" })
vicious.register(memwidget, vicious.widgets.mem, '<span background="#777E76" font="Terminus 12"> <span font="Terminus 9" color="#EEEEEE" background="#777E76">$2MB </span></span>', 13)
memicon = widget ({type = "imagebox" })
memicon.image = image(beautiful.widget_mem)

--{{---| CPU / sensors widget |---------------------------------------------------------------------

cpuwidget = widget({ type = "textbox" })
vicious.register(cpuwidget, vicious.widgets.cpu,
                 '<span background="#4B696D" font="Terminus 12"> <span font="Terminus 9" color="#DDDDDD">$2% <span color="#888888">·</span> $3% </span></span>', 3)
cpuicon = widget ({type = "imagebox" })
cpuicon.image = image(beautiful.widget_cpu)
sensors = widget({ type = "textbox" })
vicious.register(sensors, vicious.widgets.sensors)
tempicon = widget ({type = "imagebox" })
tempicon.image = image(beautiful.widget_temp)
blingbling.popups.htop(cpuwidget,
                       { title_color = beautiful.notify_font_color_1, 
                       user_color = beautiful.notify_font_color_2, 
                       root_color = beautiful.notify_font_color_3, 
                       terminal   = "terminal --geometry=130x56-10+26"})

--{{---| FS's widget / udisks-glue menu |-----------------------------------------------------------

fswidget = widget({ type = "textbox" })
vicious.register(fswidget, vicious.widgets.fs,
                 '<span background="#D0785D" font="Terminus 12"> <span font="Terminus 9" color="#EEEEEE">${/mnt/storage avail_gb}GB </span></span>', 8)
udisks_glue = blingbling.udisks_glue.new(beautiful.widget_hdd)
udisks_glue:set_mount_icon(beautiful.accept)
udisks_glue:set_umount_icon(beautiful.cancel)
udisks_glue:set_detach_icon(beautiful.cancel)
udisks_glue:set_Usb_icon(beautiful.usb)
udisks_glue:set_Cdrom_icon(beautiful.cdrom)
awful.widget.layout.margins[udisks_glue.widget] = { top = 0}
udisks_glue.widget.resize = false

--{{---| Battery widget |---------------------------------------------------------------------------  

baticon = widget ({type = "imagebox" })
baticon.image = image(beautiful.widget_battery)
batwidget = widget({ type = "textbox" })
vicious.register( batwidget, vicious.widgets.bat, '<span background="#92B0A0" font="Terminus 12"> <span font="Terminus 9" color="#FFFFFF" background="#92B0A0">$1$2% </span></span>', 1, "BAT0" )

--{{---| Net widget |-------------------------------------------------------------------------------

netwidget = widget({ type = "textbox" })
vicious.register(netwidget, 
                 vicious.widgets.net,
                 '<span background="#C2C2A4" font="Terminus 12"> <span font="Terminus 9" color="#FFFFFF">${eth0 down_kb} ↓↑ ${eth0 up_kb}</span> </span>', 3)
neticon = widget ({type = "imagebox" })
neticon.image = image(beautiful.widget_net)
netwidget:buttons(awful.util.table.join(awful.button({ }, 1,
                  function () awful.util.spawn_with_shell(iptraf) end)))

--{{---| Binary Clock |-----------------------------------------------------------------------------

binaryclock = {}
binaryclock.widget = widget({type = "imagebox"})
binaryclock.w = 42  
binaryclock.h = 16  
binaryclock.show_sec = true 
binaryclock.color_active = beautiful.binclock_fga
binaryclock.color_bg = beautiful.binclock_bg
binaryclock.color_inactive = beautiful.binclock_fgi
binaryclock.dotsize = math.floor(binaryclock.h / 5)
binaryclock.step = math.floor(binaryclock.dotsize / 3)
binaryclock.widget.image = image.argb32(binaryclock.w, binaryclock.h, nil) 
if (binaryclock.show_sec) then binaryclock.timeout = 1 else binaryclock.timeout = 20 end 
binaryclock.DEC_BIN = function(IN) 
local B,K,OUT,I,D=2,"01","",0
while IN>0 do
  I=I+1
  IN,D=math.floor(IN/B),math.mod(IN,B)+1
  OUT=string.sub(K,D,D)..OUT
end
return OUT
end
binaryclock.paintdot = function(val,shift,limit) 
local binval = binaryclock.DEC_BIN(val)
local l = string.len(binval)
local height = 0 
if (l < limit) then
  for i=1,limit - l do binval = "0" .. binval end
end
for i=0,limit-1 do
  if (string.sub(binval,limit-i,limit-i) == "1") then
    binaryclock.widget.image:draw_rectangle(shift,
                                            binaryclock.h - binaryclock.dotsize - height, 
                                            binaryclock.dotsize, binaryclock.dotsize, true, binaryclock.color_active)
  else
    binaryclock.widget.image:draw_rectangle(shift,
                                            binaryclock.h - binaryclock.dotsize - height, 
                                            binaryclock.dotsize,binaryclock.dotsize, true, binaryclock.color_inactive)
  end
  height = height + binaryclock.dotsize + binaryclock.step
end
end
binaryclock.drawclock = function ()
binaryclock.widget.image:draw_rectangle(0, 0, binaryclock.w, binaryclock.h, true, binaryclock.color_bg)
local t = os.date("*t")
local hour = t.hour
if (string.len(hour) == 1) then
  hour = "0" .. t.hour
end
local min = t.min
if (string.len(min) == 1) then
  min = "0" .. t.min
end
local sec = t.sec
if (string.len(sec) == 1) then
  sec = "0" .. t.sec
end
local col_count = 6
if (not binaryclock.show_sec) then col_count = 4 end
local step = math.floor((binaryclock.w - col_count * binaryclock.dotsize) / 8)
binaryclock.paintdot(0 + string.sub(hour, 1, 1), step, 2)
binaryclock.paintdot(0 + string.sub(hour, 2, 2), binaryclock.dotsize + 2 * step, 4)
binaryclock.paintdot(0 + string.sub(min, 1, 1),binaryclock.dotsize * 2 + 4 * step, 3)
binaryclock.paintdot(0 + string.sub(min, 2, 2),binaryclock.dotsize * 3 + 5 * step, 4)
if (binaryclock.show_sec) then
  binaryclock.paintdot(0 + string.sub(sec, 1, 1), binaryclock.dotsize * 4 + 7 * step, 3)
  binaryclock.paintdot(0 + string.sub(sec, 2, 2), binaryclock.dotsize * 5 + 8 * step, 4)
end
binaryclock.widget.image = binaryclock.widget.image
end
binarytimer = timer { timeout = binaryclock.timeout }
binarytimer:add_signal("timeout", function()
                       binaryclock.drawclock()
                       end)
binarytimer:start()

-- binaryclock.widget:buttons(awful.util.table.join(
--   awful.button({ }, 1, function () 
--   end)
-- ))

--{{---| Calendar widget |--------------------------------------------------------------------------

-- my_cal = blingbling.calendar.new({type = "imagebox", image = beautiful.widget_cal})
-- my_cal:set_cell_padding(4)
-- my_cal:set_title_font_size(9)
-- my_cal:set_title_text_color("#4F98C1")
-- my_cal:set_font_size(9)
-- my_cal:set_inter_margin(1)
-- my_cal:set_columns_lines_titles_font_size(8)
-- my_cal:set_columns_lines_titles_text_color("#d4aa00ff")
-- my_cal:set_link_to_external_calendar(true) --{{ <-- popup reminder

--{{---| Separators widgets |-----------------------------------------------------------------------

spr = widget({ type = "textbox" })
spr.text = ' '
sprd = widget({ type = "textbox" })
sprd.text = '<span background="#313131" font="Terminus 12"> </span>'
spr3f = widget({ type = "textbox" })
spr3f.text = '<span background="#777e76" font="Terminus 12"> </span>'
arr1 = widget ({type = "imagebox" })
arr1.image = image(beautiful.arr1)
arr2 = widget ({type = "imagebox" })
arr2.image = image(beautiful.arr2)
arr3 = widget ({type = "imagebox" })
arr3.image = image(beautiful.arr3)
arr4 = widget ({type = "imagebox" })
arr4.image = image(beautiful.arr4)
arr5 = widget ({type = "imagebox" })
arr5.image = image(beautiful.arr5)
arr6 = widget ({type = "imagebox" })
arr6.image = image(beautiful.arr6)
arr7 = widget ({type = "imagebox" })
arr7.image = image(beautiful.arr7)
arr8 = widget ({type = "imagebox" })
arr8.image = image(beautiful.arr8)
arr9 = widget ({type = "imagebox" })
arr9.image = image(beautiful.arr9)
arr0 = widget ({type = "imagebox" })
arr0.image = image(beautiful.arr0)

clockwidget = awful.widget.textclock({ align = "right" })
require('calendar2')
calendar2.addCalendarToWidget(clockwidget)

weatherwidget = widget({ type = "textbox" })
weather_t = awful.tooltip({ objects = { weatherwidget },})

vicious.register(weatherwidget, vicious.widgets.weather, 
                function (widget, args)
                    weather_t:set_text("City: " .. args["{city}"] .."\nWind: " .. args["{windkmh}"] .. "km/h " .. args["{wind}"] .. "\nSky: " .. args["{sky}"] .. "\nHumidity: " .. args["{humid}"] .. "%")
                    return "Nsk: " .. args["{tempc}"] .. "C" 
                end, 1800, "UNNT")

-- }}}

-- {{{ Wibox
mysystray = widget({ type = "systray" })

mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        -- clockwidget,
        -- weatherwidget,
        arr1,
        spr3f,
        binaryclock.widget,
        spr3f, 
        -- arrl, 
        -- my_cal.widget,
        arr2, 
        netwidget,
        neticon,
        arr3,
        batwidget,
        baticon,
        arr4, 
        fswidget,
        udisks_glue.widget,
        arr5,
        sensors,
        tempicon,
        arr6,
        cpuwidget,
        cpuicon,
        arr7,
        memwidget,
        memicon,
        arr8,
        task_warrior.widget,
        arr9,
        music,
        arr0,
        mailicon, 
        arr9,
        spr,zX
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ altkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Screen lock
    awful.key({ altkey, "Control" }, "l", function () awful.util.spawn("xscreensaver-command -lock") end),
    
    -- Keyboard layout
    --awful.key({ "Mod1",           }, "Shift_L", function () kbdcfg.switch() end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
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
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "Shutter" },
      properties = { floating = true } },

    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
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
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- }}}

--{{--| Autostart |---------------------------------------------------------------------------------

-- os.execute("pkill compton")
os.execute("xrandr --output VGA-0 --mode 1920x1080 --right-of DVI-0 &")
os.execute("setxkbmap -option grp:switch,grp:alt_shift_toggle,grp_led:caps,caps:none us,ru &")

run_once("wmname", "LG3D") -- java fix

run_once("xscreensaver", "-no-splash")
run_once("numlockx")
run_once("udisks-glue")

-- run_once("kbdd")
-- run_once("qlipper")
-- run_once("compton")

-- }}}