/datum/smite/valid_hunt
	name = "Valid Hunt"

/datum/smite/valid_hunt/effect(client/user, mob/living/target)
	. = ..()
	var/bounty = input("Награда в кредитах (выдавать руками пока):", "Жопа", 50) as num|null
	if(bounty)
		target.color = "#ff0000"
		target.light_system = MOVABLE_LIGHT
		target.light_range = 3
		target.set_light_color(COLOR_SOFT_RED)
		target.set_light_on(TRUE)
		priority_announce("За голову [target] назначена награда в размере [bounty] кредитов. Он будет подсвечен лазерной наводкой для удобства.", "Охота за головами",'sound/ai/announcer/alert.ogg')
