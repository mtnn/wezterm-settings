local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.use_ime = true

----------------------------------------------------
-- Window
----------------------------------------------------
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20
config.initial_cols = 180
config.initial_rows = 50

----------------------------------------------------
-- Font
----------------------------------------------------
config.font = wezterm.font_with_fallback({
  "JetBrainsMono Nerd Font",
  "Noto Color Emoji",
})
config.font_size = 12.0

----------------------------------------------------
-- Cursor
----------------------------------------------------
config.default_cursor_style = "SteadyBlock"

----------------------------------------------------
-- Tab
----------------------------------------------------
-- タイトルバーを非表示
config.window_decorations = "RESIZE"
-- タブバーの表示
config.show_tabs_in_tab_bar = true
-- タブが一つの時は非表示
config.hide_tab_bar_if_only_one_tab = true
-- falseにするとタブバーの透過が効かなくなる
-- config.use_fancy_tab_bar = false

-- タブバーの透過
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}

-- タブバーを背景色に合わせる
config.window_background_gradient = {
  colors = { "#000000" },
}

-- タブの追加ボタンを非表示
config.show_new_tab_button_in_tab_bar = false
-- nightlyのみ使用可能
-- タブの閉じるボタンを非表示
config.show_close_tab_button_in_tabs = false

-- タブ同士の境界線を非表示
config.colors = {
  tab_bar = {
    inactive_tab_edge = "none",
  },
}

-- タブの形をカスタマイズ
-- タブの左側の装飾
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
-- タブの右側の装飾
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"
  local foreground = "#FFFFFF"
  local edge_background = "none"
  if tab.is_active then
    background = "#ae8b2d"
    foreground = "#FFFFFF"
  end
  local edge_foreground = background
  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

----------------------------------------------------
-- Keybinds
----------------------------------------------------
config.disable_default_key_bindings = true
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

----------------------------------------------------
-- Window Position
----------------------------------------------------
wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  -- 起動直後のwindow情報不足時のUIズレ対策
  wezterm.sleep_ms(48)
  local gui_window = window:gui_window()

  -- 画面サイズ取得
  local screen = wezterm.gui.screens().active
  local screen_width = screen.width
  local screen_height = screen.height

  -- ウィンドウサイズ（ピクセル）
  local window_dims = gui_window:get_dimensions()
  local window_width = window_dims.pixel_width
  local window_height = window_dims.pixel_height

  -- 中央座標を計算
  local x = (screen_width - window_width) / 2
  local y = (screen_height - window_height) / 2

  -- 配置
  gui_window:set_position(x, y)
end)

return config