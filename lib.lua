--
-- GUI2 widget definitions used by Naia GUI elements
--
-- codename Naia - Project Ethea phase 1 campaigns shared library
-- Copyright (C) 2020 - 2026 by Iris Morelle <iris@irydacea.me>
--
-- See COPYING for usage terms.
--

local T = wml.tag

local INTRO_TEXT_COLOR = "186, 172, 125"

--
-- Helper to avoid code duplication and odd semantics in GUI2 calls.
--
local function G_widget(widget_class, id, cfg)
	gui.add_widget_definition(widget_class, id, {
		-- id and description are duplicated in order to prevent a WML error:
		-- "In section '[styled_widget]' the mandatory key 'id/description' isn't set."
		id          = id,
		description = "a decade and a half later, gui2 still sucks",
		T.resolution(cfg)
	})
end

--
-- Helper to build a full canvas by combining both WML tables and individual
-- WML nodes in the argument list.
--
local function C_vcanvas(...)
	local result = {}
	local args = {...}

	for i, item in ipairs(args) do
		if type(item) ~= "table" then
			wml.error("input does not look like WML")
		end
		-- If one of the arguments is the result of wml.tag, it should look
		-- like this: { 'tagname', { <contents> } }, which is a 2-item array.
		local is_single_wml_tag =
			#item == 2 and
			type(item[1]) == "string" and
			type(item[2]) == "table"

		if is_single_wml_tag then
			table.insert(result, item)
		else
			-- Append children to result
			for j, child in ipairs(item) do
				table.insert(result, child)
			end
		end
	end

	return T.draw(result)
end

local function C_line(x1, y1, x2, y2, color)
	return T.line {
		x1 = x1,
		y1 = y1,
		x2 = x2,
		y2 = y2,
		thickness = 1,
		color = color
	}
end

local function C_point(x1, y1, color)
	return C_line(x1, y1, x1, y1, color)
end

local FRAME_BORDER_BG = "1, 10, 16, 255"

--
-- Helper to generate a button frame in the Wesnoth 1.18 style.
-- (Based on GUI__BUTTON_NORMAL_FRAME.)
--
local function C_button_frame(params)
	local background_image_path = ("buttons/button_normal/%s"):format(params.background_image_path)
	local border_color          = params.border_color
	local border_color_dark     = params.border_color_dark
	local highlight_line_color  = params.highlight_line_color
	local ipf = params.ipf or ""

	return {
		T.image {
			x = 2,
			y = 2,
			w = "(width - 2)",
			h = "(height - 2)",
			name = ("%s.png%s"):format(background_image_path, ipf)
		},
		-- Dark background borders
		C_line(0,             1,              0,             "(height - 2)", FRAME_BORDER_BG),
		C_line(2,             1,              "(width - 2)", 1,              FRAME_BORDER_BG),
		C_line(1,             "(height - 1)", "(width - 2)", "(height - 1)", FRAME_BORDER_BG),
		C_line("(width - 2)", 1,              "(width - 2)", "(height - 1)", FRAME_BORDER_BG),
		-- Gold colored borders
		C_line(2,             0,              "(width - 2)", 0,              border_color),
		C_line("(width - 1)", 1,              "(width - 1)", "(height - 3)", border_color),
		C_line(1,             1,              1,             "(height - 3)", border_color_dark),
		C_line(2,             "(height - 2)", "(width - 2)", "(height - 2)", border_color_dark),
		-- Blue tint borders on the top and right
		C_line(3,             2,              "(width - 3)", 2,              highlight_line_color),
		C_line("(width - 3)", 2,              "(width - 3)", "(height - 4)", highlight_line_color),
		-- Round the corners
		C_point(2,             1,              border_color_dark),
		C_point(2,             "(height - 3)", border_color_dark),
		C_point("(width - 2)", 1,              border_color),
		C_point("(width - 2)", "(height - 3)", border_color)
	}
end

local function mini_button_text(text, color)
	return T.text {
		x               = 0,
		y               = "(max((height - text_height - 2) / 2, 0))",
		w               = "(width)",
		h               = "(text_height)",
		maximum_width   = "(width)",
		font_size       = 20,
		font_style      = "bold",
		color           = ("%s, 255"):format(color),
		text            = text,
		text_markup     = false,
		text_alignment  = "center"
	}
end

local function G_mini_button(id, label)
	G_widget("button", id, {
		min_width         = 30,
		min_height        = 30,
		default_width     = 30,
		default_height    = 30,
		max_width         = 30,
		max_height        = 30,
		text_extra_width  = 0,
		text_extra_height = 0,
		text_font_size    = 20,

		T.state_enabled {
			C_vcanvas(
				C_button_frame({
					background_image_path = "background",
					border_color          = "162, 127, 68, 255",   -- GUI__BORDER_COLOR
					border_color_dark     = "114, 79, 46, 255",    -- GUI__BORDER_COLOR_DARK
					highlight_line_color  = "21, 79, 109, 255"
				}),
				mini_button_text(label, INTRO_TEXT_COLOR)
			)
		},
		T.state_focused {
			C_vcanvas(
				C_button_frame({
					background_image_path = "background-active",
					border_color          = "162, 127, 68, 255",   -- GUI__BORDER_COLOR
					border_color_dark     = "114, 79, 46, 255",    -- GUI__BORDER_COLOR_DARK
					highlight_line_color  = "12, 108, 157, 255"
				}),
				mini_button_text(label, INTRO_TEXT_COLOR)
			)
		},
		T.state_pressed {
			C_vcanvas(
				C_button_frame({
					background_image_path = "background-pressed",
					border_color          = "162, 127, 68, 255",   -- GUI__BORDER_COLOR
					border_color_dark     = "114, 79, 46, 255",    -- GUI__BORDER_COLOR_DARK
					highlight_line_color  = "1, 10, 16, 255"
				}),
				mini_button_text(label, INTRO_TEXT_COLOR)
			)
		},
		T.state_disabled {
			C_vcanvas(
				C_button_frame({
					background_image_path = "background",
					border_color          = "128, 128, 128, 255",  -- GUI__FONT_COLOR_DISABLED__DEFAULT
					border_color_dark     = "89, 89, 89, 255",
					highlight_line_color  = "60, 60, 60, 255",
					ipf                   = "~GS()"
				}),
				mini_button_text(label, "128, 128, 128")
			)
		}
	})
end

local function small_button_text(color)
	return T.text {
		x               = "(max((width - text_width) / 2, 0))",
		y               = "(max((height - text_height - 2) / 2, 0))",
		w               = "(text_width)",
		h               = "(text_height)",
		font_size       = 15,
		font_style      = "",
		color           = ("%s, 255"):format(color),
		text            = "(text)",
		text_markup     = false,
		text_alignment  = "center"
	}
end

local function G_small_button(id, label)
	G_widget("button", id, {
		min_width         = 30,
		min_height        = 30,
		default_width     = 30,
		default_height    = 30,
		max_width         = 0,
		max_height        = 30,
		text_extra_width  = 10,
		text_extra_height = 0,
		text_font_size    = 20,

		T.state_enabled {
			C_vcanvas(
				C_button_frame({
					background_image_path = "background",
					border_color          = "162, 127, 68, 255",   -- GUI__BORDER_COLOR
					border_color_dark     = "114, 79, 46, 255",    -- GUI__BORDER_COLOR_DARK
					highlight_line_color  = "21, 79, 109, 255"
				}),
				small_button_text(INTRO_TEXT_COLOR)
			)
		},
		T.state_focused {
			C_vcanvas(
				C_button_frame({
					background_image_path = "background-active",
					border_color          = "162, 127, 68, 255",   -- GUI__BORDER_COLOR
					border_color_dark     = "114, 79, 46, 255",    -- GUI__BORDER_COLOR_DARK
					highlight_line_color  = "12, 108, 157, 255"
				}),
				small_button_text(INTRO_TEXT_COLOR)
			)
		},
		T.state_pressed {
			C_vcanvas(
				C_button_frame({
					background_image_path = "background-pressed",
					border_color          = "162, 127, 68, 255",   -- GUI__BORDER_COLOR
					border_color_dark     = "114, 79, 46, 255",    -- GUI__BORDER_COLOR_DARK
					highlight_line_color  = "1, 10, 16, 255"
				}),
				small_button_text(INTRO_TEXT_COLOR)
			)
		},
		T.state_disabled {
			C_vcanvas(
				C_button_frame({
					background_image_path = "background",
					border_color          = "128, 128, 128, 255",  -- GUI__FONT_COLOR_DISABLED__DEFAULT
					border_color_dark     = "89, 89, 89, 255",
					highlight_line_color  = "60, 60, 60, 255",
					ipf                   = "~GS()"
				}),
				small_button_text("128, 128, 128")
			)
		}
	})
end

G_mini_button("naia_mini_close",   "×")
G_mini_button("naia_mini_ok",      "✓")

G_small_button("naia_small")

