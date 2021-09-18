/*
Unused icons for new areas are "awaycontent1" ~ "awaycontent30"
*/


// Away Missions
/area/awaymission
	name = "Странное место"
	icon_state = "away"
	has_gravity = STANDARD_GRAVITY
	ambience_index = AMBIENCE_AWAY
	ambientsounds = AWAY_MISSION
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/awaymission/beach
	name = "Пляж"
	icon_state = "away"
	static_lighting = FALSE
	base_lighting_alpha = 255
	base_lighting_color = COLOR_WHITE
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	ambientsounds = list('sound/ambience/shore.ogg', 'sound/ambience/seag1.ogg','sound/ambience/seag2.ogg','sound/ambience/seag2.ogg','sound/ambience/ambiodd.ogg','sound/ambience/ambinice.ogg')

/area/awaymission/errorroom
	name = "Супер-секретная комната"
	static_lighting = FALSE
	base_lighting_alpha = 255
	base_lighting_color = COLOR_WHITE
	has_gravity = STANDARD_GRAVITY

