/datum/smite/valid_hunt
	name = "Valid Hunt"

/datum/smite/valid_hunt/effect(client/user, mob/living/target)
	. = ..()
	var/bounty = input("Награда в кредитах (выдавать руками пока):", "Жопа", 50) as num|null
	if(bounty)
		target.color = COLOR_RED
		target.set_light(1.4, 4, COLOR_RED, TRUE)
		priority_announce("За голову [target] назначена награда в размере [bounty] кредит[get_num_string(bounty)]. Он будет подсвечен лазерной наводкой для удобства.", "Охота за головами",'sound/ai/announcer/alert.ogg')
