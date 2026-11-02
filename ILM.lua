--[[

ILM - Iris's Lighting Magic
Copyright (C) 2026 by Iris Morelle <iris@irydacea.me>

See COPYING for usage terms.

]]

local T = wml.tag
local _ = wesnoth.textdomain "wesnoth-Iris_Lighting_Magic"

local HEX_ICON = "icons/action/minimap-draw-terrain_25.png"

local function color_clamp(c)
	return mathx.clamp(c, 0, 255)
end

local function make_color_preview(r, g, b, a)
	local res = ("~SCALE(%d, %d)~BG(%d,%d,%d)"):format(
			20, 20, color_clamp(r), color_clamp(g), color_clamp(b))
	if a == nil then
		-- Solid preview
		res = "misc/blank-hex.png" .. res
	else
		-- Tint on alpha checkerboard
		res = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAOUlEQVQ4y2NsaGj4z4AEDhw4gMxlcHBwYCBFnomBymDwG8hCaZihy4/EMKQ0zEbT4Wg6HE2Hg8JAAFVyJq9PTe3xAAAAAElFTkSuQmCC~BLIT(misc/blank-hex.png" .. res .. ("~O(%0.2f%%)"):format(a / 255 * 100) .. ")"
	end
	return res
end

local function tod_slider_factory(id)
	return T.slider {
		id = id,
		minimum_value = -512,
		maximum_value = 512,
	}
end

local function fade_slider_factory(id)
	return T.slider {
		id = id,
		minimum_value = 0,
		maximum_value = 255,
	}
end

local col_adjust_grid = {
	T.row {
		T.column {
			grow_factor = 0,
			horizontal_alignment = "right",
			border = "all",
			border_size = 5,
			T.label {
				definition = "gold_small",
				label = _ "Red:"
			}
		},
		T.column {
			grow_factor = 1,
			horizontal_grow = true,
			border = "all",
			border_size = 5,
			tod_slider_factory("tod_red")
		}
	},
	T.row {
		T.column {
			grow_factor = 0,
			horizontal_alignment = "right",
			border = "all",
			border_size = 5,
			T.label {
				definition = "gold_small",
				label = _ "Green:"
			}
		},
		T.column {
			grow_factor = 1,
			horizontal_grow = true,
			border = "all",
			border_size = 5,
			tod_slider_factory("tod_green")
		}
	},
	T.row {
		T.column {
			grow_factor = 0,
			horizontal_alignment = "right",
			border = "all",
			border_size = 5,
			T.label {
				definition = "gold_small",
				label = _ "Blue:"
			}
		},
		T.column {
			grow_factor = 1,
			horizontal_grow = true,
			border = "all",
			border_size = 5,
			tod_slider_factory("tod_blue")
		}
	}
}

local scr_fade_grid = {
	T.row {
		T.column {
			grow_factor = 0,
			horizontal_alignment = "right",
			border = "all",
			border_size = 5,
			T.label {
				definition = "gold_small",
				label = _ "Red:"
			}
		},
		T.column {
			grow_factor = 1,
			horizontal_grow = true,
			border = "all",
			border_size = 5,
			fade_slider_factory("fade_red")
		}
	},
	T.row {
		T.column {
			grow_factor = 0,
			horizontal_alignment = "right",
			border = "all",
			border_size = 5,
			T.label {
				definition = "gold_small",
				label = _ "Green:"
			}
		},
		T.column {
			grow_factor = 1,
			horizontal_grow = true,
			border = "all",
			border_size = 5,
			fade_slider_factory("fade_green")
		}
	},
	T.row {
		T.column {
			grow_factor = 0,
			horizontal_alignment = "right",
			border = "all",
			border_size = 5,
			T.label {
				definition = "gold_small",
				label = _ "Blue:"
			}
		},
		T.column {
			grow_factor = 1,
			horizontal_grow = true,
			border = "all",
			border_size = 5,
			fade_slider_factory("fade_blue")
		}
	},
	T.row {
		T.column {
			grow_factor = 0,
			horizontal_alignment = "right",
			border = "all",
			border_size = 5,
			T.label {
				definition = "gold_small",
				label = _ "Alpha:"
			}
		},
		T.column {
			grow_factor = 1,
			horizontal_grow = true,
			border = "all",
			border_size = 5,
			fade_slider_factory("fade_alpha")
		}
	},
	T.row {
		T.column {
			grow_factor = 0,
			horizontal_alignment = "right",
			border = "all",
			border_size = 5,
			T.label {
				definition = "gold_small",
				label = _ "Duration:"
			}
		},
		T.column {
			grow_factor = 1,
			horizontal_grow = true,
			border = "all",
			border_size = 5,
			T.text_box {
				id = "fade_time"
			}
		}

	}
}

local ilm_dlg = {
	--definition = "menu",
	maximum_width = 640,
	maximum_height = 600,

	T.helptip { id = "tooltip" },
	T.tooltip { id = "tooltip" },

	T.grid {
		T.row {
			T.column {
				grow_factor = 1,
				horizontal_grow = true,
				T.grid {
					T.row {
						T.column {
							grow_factor = 1,
							horizontal_grow = true,
							border = "all",
							border_size = 5,
							T.label {
								definition = "title",
								label = _ "Iris’s Lighting Magic",
							}
						},
						T.column {
							grow_factor = 0,
							horizontal_alignment = "right",
							border = "all",
							border_size = 5,
							T.label {
								definition = "default_tiny",
								label = "v" .. ILM_VERSION
							}
						},
						T.column {
							grow_factor = 0,
							horizontal_alignment = "right",
							border = "all",
							border_size = 5,
							T.button {
								id = "apply",
								definition = "naia_mini_ok",
								label = _ "Apply"
							}
						},
						T.column {
							grow_factor = 0,
							horizontal_alignment = "right",
							border = "all",
							border_size = 5,
							T.button {
								id = "ok",
								definition = "naia_mini_close",
								label = wesnoth.textdomain("wesnoth")("Close")
							}
						}
					}
				}
			}
		},
		T.row {
			T.column {
				grow_factor = 1,
				horizontal_grow = true,
				border = "all",
				border_size = 5,
				T.grid {
					T.row {
						T.column {
							border = "left,right",
							border_size = 5,
							vertical_alignment = "top",
							T.grid {
								T.row {
									T.column {
										horizontal_grow = true,
										T.grid {
											T.row {
												T.column {
													grow_factor = 0,
													border = "all",
													border_size = 5,
													horizontal_alignment = "left",
													T.image {
														id = "col_adjust_preview"
													}
												},
												T.column {
													grow_factor = 0,
													border = "all",
													border_size = 5,
													horizontal_alignment = "left",
													T.toggle_button {
														id = "col_adjust_toggle",
														label = _ "Map color adjust"
													}
												},
												T.column {
													grow_factor = 0,
													border = "all",
													border_size = 5,
													horizontal_alignment = "right",
													T.button {
														id = "col_adjust_reset",
														definition = "naia_small",
														label = _ "Reset"
													}
												}
											}
										}
									}
								},
								T.row {
									T.column {
										grow_factor = 1,
										horizontal_grow = true,
										vertical_alignment = "top",
										T.grid(col_adjust_grid)
									}
								}
							}
						},
						T.column {
							border = "left,right",
							border_size = 10,
							vertical_grow = true,
							T.drawing {
								width = 1,
								height = "(height)",
								T.draw {
									T.line {
										x1 = 0, y1 = 1,
										x2 = 0, y2 = "(height - 1)",
										color = "114, 79, 46, 255",
										thickness = 1
									}
								}
							}
						},
						T.column {
							border = "left,right",
							border_size = 5,
							vertical_alignment = "top",
							T.grid {
								T.row {
									T.column {
										horizontal_grow = true,
										T.grid {
											T.row {
												T.column {
													grow_factor = 0,
													border = "all",
													border_size = 5,
													horizontal_alignment = "left",
													T.image {
														id = "scr_fade_preview"
													}
												},
												T.column {
													grow_factor = 0,
													border = "all",
													border_size = 5,
													horizontal_alignment = "left",
													T.toggle_button {
														id = "scr_fade_toggle",
														label = _ "Viewport color fade"
													}
												},
												T.column {
													grow_factor = 0,
													border = "all",
													border_size = 5,
													horizontal_alignment = "right",
													T.button {
														id = "scr_fade_reset",
														definition = "naia_small",
														label = _ "Reset"
													}
												}
											}
										}
									}
								},
								T.row {
									T.column {
										grow_factor = 1,
										horizontal_grow = true,
										vertical_alignment = "top",
										T.grid(scr_fade_grid)
									}
								}
							}
						}
					}
				}

			}
		},
		T.row {
			T.column {
				grow_factor = 1,
				horizontal_grow = true,
				border = "all",
				border_size = 5,
				T.label {
					definition = "default_small",
					wrap = true,
					label = _ "Note: Due to Wesnoth Lua API limitations, changes will not be reflected on the viewport until you press Apply. If a fade duration is specified, this popup will be hidden while the fade animation plays."
				}
			}
		}
	}
}

local state = {
	color_adj = { r = 0, g = 0, b = 0 },
	fade      = { r = 0, g = 0, b = 0, a = 0, t = 0 },
	do_adj    = false,
	do_fade   = false,
	apply     = false,
}

local function preshow(self)
	local col_adjust_preview = function()
		self.col_adjust_preview.label = make_color_preview(
			127 + state.color_adj.r,
			127 + state.color_adj.g,
			127 + state.color_adj.b)
	end

	local scr_fade_preview = function()
		self.scr_fade_preview.label = make_color_preview(
			state.fade.r,
			state.fade.g,
			state.fade.b,
			state.fade.a)
	end

	for k, v in pairs({r = "tod_red", g = "tod_green", b = "tod_blue"}) do
		self[v].value = state.color_adj[k]
		self[v].on_modified = function()
			state.color_adj[k] = self[v].value
			col_adjust_preview()
		end
	end

	for k, v in pairs({r = "fade_red", g = "fade_green", b = "fade_blue", a = "fade_alpha", t = "fade_time"}) do
		if v ~= "fade_time" then
			self[v].value = state.fade[k]
			self[v].on_modified = function()
				state.fade[k] = self[v].value
				scr_fade_preview()
			end
		else
			self[v].text = string.format("%d", state.fade[k])
			self[v].on_modified = function()
				state.fade[k] = tonumber(self[v].text)
			end
		end
	end

	local col_adjust_func = function()
		state.do_adj = self.col_adjust_toggle.selected
		for i, name in ipairs({"col_adjust_reset", "tod_red", "tod_green", "tod_blue"}) do
			self[name].enabled = state.do_adj
		end
	end
	self.col_adjust_toggle.selected = state.do_adj
	self.col_adjust_toggle.on_modified = col_adjust_func
	col_adjust_func()
	col_adjust_preview()

	self.col_adjust_reset.on_button_click = function()
		for k, v in pairs({r = "tod_red", g = "tod_green", b = "tod_blue"}) do
			state.color_adj[k] = 0
			self[v].value = 0
		end
	end

	local scr_fade_func = function()
		state.do_fade = self.scr_fade_toggle.selected
		for i, name in ipairs({"scr_fade_reset", "fade_red", "fade_green", "fade_blue", "fade_alpha", "fade_time"}) do
			self[name].enabled = state.do_fade
		end
	end
	self.scr_fade_toggle.selected = state.do_fade
	self.scr_fade_toggle.on_modified = scr_fade_func
	scr_fade_func()
	scr_fade_preview()

	self.scr_fade_reset.on_button_click = function()
		for k, v in pairs({r = "fade_red", g = "fade_green", b = "fade_blue", a = "fade_alpha", t = "fade_time"}) do
			state.fade[k] = 0
			if v ~= "fade_time" then
				self[v].value = 0
			else
				self[v].text = "0"
			end
		end
	end

	self.apply.on_button_click = function()
		state.apply = true
		self:close()
	end
end

function Iris_Lighting_Magic()
	::start::
	gui.show_dialog(ilm_dlg, preshow)

	if state.do_adj then
		wesnoth.wml_actions.color_adjust {
			red      = state.color_adj.r,
			green    = state.color_adj.g,
			blue     = state.color_adj.b,
		}
	end

	if state.do_fade then
		wesnoth.wml_actions.screen_fade {
			red      = state.fade.r,
			green    = state.fade.g,
			blue     = state.fade.b,
			alpha    = state.fade.a,
			duration = state.fade.t,
		}
	end

	if state.apply then
		state.apply = false
		goto start
	end

	state.do_adj = false
	state.do_fade = false
end

wesnoth.wml_actions.set_menu_item {
	id = "naia:90_99_ilm",
	description = _ "debug^Iris’s Lighting Magic",
	image = HEX_ICON,
	T.show_if {
		T.lua {
			code = "return wesnoth.game_config.debug"
		}
	},
	T.command {
		T.lua {
			code = "Iris_Lighting_Magic()"
		}
	}
}
