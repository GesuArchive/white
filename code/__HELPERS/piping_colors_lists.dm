///All colors available to pipes and atmos components
GLOBAL_LIST_INIT(pipe_paint_colors, sort_list(list(
	"grey" = COLOR_VERY_LIGHT_GRAY,
	"blue" = COLOR_BLUE,
	"red" = COLOR_RED,
	"green" = COLOR_VIBRANT_LIME,
	"orange" = COLOR_TAN_ORANGE,
	"cyan" = COLOR_CYAN,
	"dark" = COLOR_DARK,
	"yellow" = COLOR_YELLOW,
	"brown" = COLOR_BROWN,
	"pink" = COLOR_LIGHT_PINK,
	"purple" = COLOR_PURPLE,
	"violet" = COLOR_STRONG_VIOLET
)))

///List that sorts the colors and is used for setting up the pipes layer so that they overlap correctly
GLOBAL_LIST_INIT(pipe_colors_ordered, sort_list(list(
	COLOR_AMETHYST = -6,
	COLOR_BLUE = -5,
	COLOR_BROWN = -4,
	COLOR_CYAN = -3,
	COLOR_DARK = -2,
	COLOR_VIBRANT_LIME = -1,
	COLOR_VERY_LIGHT_GRAY = 0,
	COLOR_TAN_ORANGE = 1,
	COLOR_PURPLE = 2,
	COLOR_RED = 3,
	COLOR_STRONG_VIOLET = 4,
	COLOR_YELLOW = 5
)))

///Names shown in the examine for every colored atmos component
GLOBAL_LIST_INIT(pipe_color_name, sort_list(list(
	COLOR_VERY_LIGHT_GRAY = "серая",
	COLOR_BLUE = "синяя",
	COLOR_RED = "красная",
	COLOR_VIBRANT_LIME = "зелёная",
	COLOR_TAN_ORANGE = "оранжевая",
	COLOR_CYAN = "голубая",
	COLOR_DARK = "тёмная",
	COLOR_YELLOW = "жёлтая",
	COLOR_BROWN = "коричневая",
	COLOR_LIGHT_PINK = "розовая",
	COLOR_PURPLE = "пурпурная",
	COLOR_STRONG_VIOLET = "фиолетовая"
)))
