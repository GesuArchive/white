
//sets you on fire, does burn damage, explodes into flame when burnt, weak to water
/datum/blobstrain/reagent/blazing_oil
	name = "Пылающее масло"
	description = "нанесет средний урон от ожога и подожжет цели."
	effectdesc = "также будет выпускать вспышки пламени при горении, но получает урон от воды."
	analyzerdescdamage = "Наносит средний урон от ожога и поджигает цели."
	analyzerdesceffect = "Вызывает огонь при горении, но получает повреждения от воды и других средств пожаротушения."
	color = "#B68D00"
	complementary_color = "#BE5532"
	blobbernaut_message = "брызгается"
	message = "Масса обливает меня горящим маслом"
	message_living = " и моя кожа горит"
	reagent = /datum/reagent/blob/blazing_oil
	fire_based = TRUE

/datum/blobstrain/reagent/blazing_oil/extinguish_reaction(obj/structure/blob/B)
	B.take_damage(4.5, BURN, ENERGY)

/datum/blobstrain/reagent/blazing_oil/damage_reaction(obj/structure/blob/B, damage, damage_type, damage_flag)
	if(damage_type == BURN && damage_flag != ENERGY)
		for(var/turf/open/T in range(1, B))
			var/obj/structure/blob/C = locate() in T
			if(!(C && C.overmind && C.overmind.blobstrain.type == B.overmind.blobstrain.type) && prob(80))
				new /obj/effect/hotspot(T)
	if(damage_flag == FIRE)
		return 0
	return ..()

/datum/reagent/blob/blazing_oil
	name = "Пылающее масло"
	enname = "Blazing Oil"
	taste_description = "горящее масло"
	color = "#B68D00"

/datum/reagent/blob/blazing_oil/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message, touch_protection, mob/camera/blob/overmind)
	. = ..()
	reac_volume = return_mob_expose_reac_volume(exposed_mob, methods, reac_volume, show_message, touch_protection, overmind)
	exposed_mob.adjust_fire_stacks(round(reac_volume/10))
	exposed_mob.ignite_mob()
	if(exposed_mob)
		exposed_mob.apply_damage(0.8*reac_volume, BURN, wound_bonus=CANT_WOUND)
	if(iscarbon(exposed_mob))
		exposed_mob.emote("agony")
