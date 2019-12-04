//fuck

#define MOB_STR "strength"
#define MOB_STM "stamina"
#define MOB_INT "intelligence"
#define MOB_DEX "dexterity"

// stats

/client/var/wpp = 0

/mob/living/carbon/human/var/list/dstats = list(MOB_STR = 10, MOB_STM = 10, MOB_INT = 10, MOB_DEX = 10)

// do this shit

/mob/living/carbon/human/Initialize()
	. = ..()
	for(var/S in dstats)
		S = rand(5, 14)

/mob/living/carbon/human/Stat()
	..()
	if(statpanel("Game"))
		stat(null, "--- \[Персонаж\] ---")
		stat(null, "Сила: [dstats["strength"]]")
		stat(null, "Выносливость: [dstats["stamina"]]")
		stat(null, "Интеллект: [dstats["intelligence"]]")
		stat(null, "Ловкость: [dstats["dexterity"]]")
		stat(null, "Сила воли: [src.wpp]")
