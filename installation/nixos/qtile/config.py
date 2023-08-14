# Wodajo's Qtile config file - kali edition, enjoy
# https://www.utf8icons.com/subsets for icons

#from libqtile import qtile
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
import os  # for autostart hook
import subprocess  # for autostart hook

mod = "mod4"
terminal = "alacritty"

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
#    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "n", lazy.window.toggle_floating(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "b", lazy.spawn('firefox'), desc="Firefox"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
#    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
         ### Switch focus to specific monitor (out of three)
         Key([mod], "w",
             lazy.to_screen(0),
             desc='Keyboard focus to monitor 1'
             ),
         Key([mod], "e",
             lazy.to_screen(1),
             desc='Keyboard focus to monitor 2'
             ),
         Key([mod], "r",
             lazy.to_screen(2),
             desc='Keyboard focus to monitor 3'
             ),
         ### Switch focus of monitors
         Key([mod], "period",
             lazy.prev_screen(),
             desc='Move focus to prev monitor'
             ),
         Key([mod], "comma",
             lazy.next_screen(),
             desc='Move focus to next monitor'
             ),

    Key([mod], "r", lazy.spawn('rofi -show drun'), desc="Rofi app luncher"),
    Key([mod], "f", lazy.spawn('thunar'), desc="Thunar luncher"),
    Key([mod], "o", lazy.spawn('obsidian'), desc="Obsidian luncher"),
    Key([mod], "p", lazy.spawn('okular'), desc="Okular luncher"),
    Key([mod], "c", lazy.spawn('betterlockscreen --lock'), desc="Screen lock"),
    #    Key([mod], "m", lazy.spawn('alacritty alsamixer'), desc="alsamixer (mainly for mic control"),
    Key([], "Print", lazy.spawn('flameshot gui'), desc="For screenshots"),
    # Sound
    Key([], "XF86AudioMute", lazy.spawn("amixer -q set Master toggle")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -q set Master 5%-")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -q set Master 5%+")),
    #  Brightness
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl s +5%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl s 5%-")),
]

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    layout.Max(),
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=3),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

# COLORS FOR THE BAR
def init_colors():
    return [["#282c34", "#282c34"], # color 0  
            ["#9ca0a4", "#979797"], # color 1  
            ["#c0c5ce", "#c0c5ce"], # color 2
            ["#DFDFDF", "#dfdfdf"], # color 3 
            ["#fcd71c", "#fcd71c"], # color 4  
            ["#ff6c6b", "#ff6655"], # color 5
            ["#da8548", "#dd8844"], # color 6
            ["#98be65", "#99bb66"], # color 7
            ["#4db5bd", "#44b9b1"], # color 8
            ["#46D9FF", "#46D9FF"], # color 9
            ["#51afef", "#51afef"], # color 10
            ["#2257A0", "#2257A0"], # color 11
            ["#c678dd", "#c678dd"], # color 12
            ["#a9a1e1", "#a9a1e1"]] # color 13


colors = init_colors()

# Functions (I have no idea why alsamixer spawning don't work:<)
#def open_alsamixer(qtile):  # spawn alsamixer widget
#	qtile.cmd_spawn('alsamixer')
#
#def close_calendar(qtile):  # kill calendar widget
#    qtile.cmd_spawn('killall -q gsimplecal')


screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    highlight_method='text',  # uses *_border color settings
                    this_current_screen_border='#1cb909',  # when focused
                    #this_screen_border='',  # when unfocused
                    #other_current_screen_border='',  # on other screen, when focused
                    #other_screen_border='',  # on other screen, when unfocused
                    urgent_border='#ff0000',  # urgent alert on that window
                    #highlight_method='line',  # alternative windows highlighting
		),
                widget.Prompt(),
		widget.WindowName(),
                widget.CPU(
                        foreground=colors[12],
                        padding=0,
                        format='  {load_percent}%  ',
                        update_interval=1,
                ),
#		widget.CPUGraph(
#			type='line',
#			line_width=1,
#			border_width=1,
#			border_color="#000000",
#			frequency=2,
#			samples=50,
#		),
                widget.Memory(
                        foreground=colors[4],
                        padding=0,
                        format='  {MemUsed: .1f}{mm}/{MemTotal: .1f}{mm}  ',
                        measure_mem='G',
#                        mouse_callbacks = {'Button1': lambda : qtile.cmd_spawn(terminal + ' -e htop')},
                ),
		widget.Net(
                        foreground=colors[10],
                        padding=0,
                        format='  ↓ {down} ↑ {up}  ',
                        prefix='M',
                ),
                widget.Battery(
                    foreground=colors[7],
                    format='  {percent:2.0%}  ',
                    update_interval=1,
                ),
                widget.Systray(),
                widget.Clock(
			format=" %d/%m/%y %H:%M ",
		),
#		widget.Moc(),
#		widget.Mpris2(
#			foreground=colors[7],
#		),
#		widget.Bluetooth(),
                widget.Volume(
                        foreground=colors[8],
                        padding=0,
                        fmt='  {}  ',
                        scroll=True,
                        mouse_callbacks = {'Button3': lazy.spawn("pavucontrol")},
                ),
#                widget.TextBox(
#			text = '*',
#			mouse_callbacks = {'Button1': open_alsamixer},  # don't work (I tried to bind with with a function)
#			mouse_callbacks = {'Button1': lazy.spawn("amixer -q set Capture toggle"), 'Button4': lazy.spawn("amixer -q set Capture 1%+"), 'Button5': lazy.spawn("amixer -q set Capture 1%-")},
#                ),
            ],
            24,
            background='#000000.3', opacity=1
         #  background='#000000',  #before opacity & without bar borders
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    	Match(wm_class='galculator'),  # Galculator
#        Match(wm_class='pavucontrol')  # Mic and audio controller
        Match(wm_class='blueman-manager'),  # Bluetooth manager
        Match(wm_class='xfreerdp'),  # RDP window (kinda annoying bcos other keybindings inside)
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

@hook.subscribe.startup
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call([home])

#@hook.subscribe.startup_once
#def autostart():
#    home = os.path.expanduser('~/.config/qtile/autostart.sh')
#    subprocess.Popen([home])
