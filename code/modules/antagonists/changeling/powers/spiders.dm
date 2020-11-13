/datum/action/changeling/spiders
	name = "Распространение заражения"
	desc = "Наша форма разделяется, создавая паукообразных, которые превратятся в смертельных зверей. Стоит 45 химикатов."
	helptext = "Пауки - бездумные существа и могут полностью атаковать своих создателей. Требуется как минимум 3 поглощения ДНК."
	button_icon_state = "spread_infestation"
	chemical_cost = 45
	dna_cost = 1
	req_absorbs = 3

//Makes a spider egg cluster. Allows you enable further general havok by introducing spiders to the station.
/datum/action/changeling/spiders/sting_action(mob/user)
	..()
	new /obj/structure/spider/eggcluster/bloody(user.loc)
	return TRUE
