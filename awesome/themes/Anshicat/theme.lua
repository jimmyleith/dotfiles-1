theme				= {}

themes_dir			= os.getenv("HOME") .. "/.config/awesome/themes/Anshicat/" 
theme.wallpaper			= os.getenv("HOME") .. "/Pictures/Wallpapers/wall10.png"
 
theme.useless_gap_width		= 10

theme.font			= "DejaVu Sans 9"

theme.bg_normal			= "#121212"
theme.fg_normal			= "#FFF"

theme.bg_focus			= "#121212"
theme.fg_focus			= "#D81860"

theme.fg_urgent			= "#FFF"
theme.bg_urgent			= "#121212"

theme.dmenu_fg_normal	= "#FFF"
theme.dmenu_bg_normal	= "#121212"

theme.dmenu_fg_focus	= "#FFF"
theme.dmenu_bg_focus	= "#D81860"


theme.tasklist_bg_normal	= "#121212"
theme.tasklist_fg_normal	= "#FFF"

theme.tasklist_bg_focus		= "#121212"
theme.tasklist_fg_focus		= "#FFF"

theme.tasklist_fg_minimize	= "#121212"

theme.tasklist_disable_icon	= true
theme.tasklist_floating		= "[F] "

theme.taglist_fg_focus		= "#D81860"

theme.border_width		= "0"
theme.border_normal		= "#e3e3e3"
theme.border_focus		= "#D81860"
theme.border_marked		= "#66AABB"

theme.titlebar_bg_normal	= "#262626"
theme.titlebar_bg_focus		= "#D81860"
theme.titlebar_fg_normal	= "#ffffff"
theme.titlebar_fg_focus		= "#ffffff"


theme.textbox_widget_margin_top	= 1

theme.notify_fg			= theme.fg_normal
theme.notify_bg			= theme.bg_normal
theme.notify_border		= theme.border_focus

theme.awful_widget_height	= 14
theme.awful_widget_margin_top	= 2

theme.mouse_finder_color	= "#CC9393"

theme.menu_height		= "18"
theme.menu_width		= "140"

return theme



