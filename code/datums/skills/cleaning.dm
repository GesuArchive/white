/datum/skill/cleaning
	name = "Уборка"
	title =  "Уборщик"
	desc = "Меня определяет не то, кем я являюсь, а то, что я вычищаю."
	modifiers = list(SKILL_SPEED_MODIFIER = list(1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.36)) //speed also touches probability in using up a soap's charge
	skill_cape_path = /obj/item/clothing/neck/cloak/skill_reward/cleaning
