/datum/skill/gaming
	name = "Гейминг"
	title = "Геймер"
	desc = "Мой опыт геймера. Это помогает мне с легкостью побеждать боссов, играть в Powergame в Orion Trail и заставляет меня хотеть потратить немного топлива для геймеров."
	modifiers = list(SKILL_PROBS_MODIFIER = list(0, 5, 10, 15, 15, 20, 25),
				SKILL_RANDS_MODIFIER = list(0, 1, 2, 3, 4, 5, 7))
	skill_cape_path = /obj/item/clothing/neck/cloak/skill_reward/gaming

/datum/skill/gaming/New()
	. = ..()
	levelUpMessages[1] = span_nicegreen("Начинаю разбираться в управлении этими играми...")
	levelUpMessages[4] = span_nicegreen("Начинаю понимать мету этих аркад. Если бы я минимизировал оптимальную стратегию и сосредоточил свой стиль игры на хорошо отработанных технологиях...")
	levelUpMessages[6] = span_nicegreen("Благодаря невероятной решимости и усилиям я достиг пика Геймера. Интересно, как можно стать сильнее... Может быть, топливо для геймеров действительно поможет мне лучше играть..?")
