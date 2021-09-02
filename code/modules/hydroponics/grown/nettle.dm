/obj/item/seeds/nettle
	name = "Пачка семян крапивы"
	desc = "Эти семена вырастают в крапиву."
	icon_state = "seed-nettle"
	species = "nettle"
	plantname = "Nettles"
	product = /obj/item/food/grown/nettle
	lifespan = 30
	endurance = 40 // tuff like a toiger
	yield = 4
	instability = 25
	growthstages = 5
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/plant_type/weed_hardy)
	mutatelist = list(/obj/item/seeds/nettle/death)
	reagents_add = list(/datum/reagent/toxin/acid = 0.5)
	graft_gene = /datum/plant_gene/trait/plant_type/weed_hardy

/obj/item/seeds/nettle/death
	name = "Пачка семян смертельной крапивы"
	desc = "Эти семена вырастают в смертельную крапиву."
	icon_state = "seed-deathnettle"
	species = "deathnettle"
	plantname = "Death Nettles"
	product = /obj/item/food/grown/nettle/death
	endurance = 25
	maturation = 8
	yield = 2
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/plant_type/weed_hardy, /datum/plant_gene/trait/stinging)
	mutatelist = list()
	reagents_add = list(/datum/reagent/toxin/acid/fluacid = 0.5, /datum/reagent/toxin/acid = 0.5)
	rarity = 20
	graft_gene = /datum/plant_gene/trait/stinging

/obj/item/food/grown/nettle // "snack"
	seed = /obj/item/seeds/nettle
	name = "Крапива"
	desc = "Явно <B>НЕ</B> стоит касаться голыми руками..."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "nettle"
	lefthand_file = 'icons/mob/inhands/weapons/plants_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/plants_righthand.dmi'
	damtype = BURN
	force = 15
	hitsound = 'sound/weapons/bladeslice.ogg'
	throwforce = 5
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3
	attack_verb_continuous = list("жалит")
	attack_verb_simple = list("жалит")

/obj/item/food/grown/nettle/Initialize(mapload, obj/item/seeds/new_seed)
	. = ..()
	force = round((5 + seed.potency / 5), 1)
	AddElement(/datum/element/plant_backfire, /obj/item/food/grown/nettle.proc/burn_holder, list(TRAIT_PIERCEIMMUNE))

/obj/item/food/grown/nettle/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] ест [src]! Кажется, [user.p_theyre()] пытается покончить с собой!"))
	return (BRUTELOSS|TOXLOSS)

/*
 * Burn the person holding the nettle's hands. Their active hand takes burn = the nettle's force.
 *
 * user - the carbon who is holding the nettle.
 */
/obj/item/food/grown/nettle/proc/burn_holder(mob/living/carbon/user)
	to_chat(user, span_danger("[src] жжёт мою руку!"))
	var/obj/item/bodypart/affecting = user.get_active_hand()
	if(affecting?.receive_damage(0, force, wound_bonus = CANT_WOUND))
		user.update_damage_overlays()

/obj/item/food/grown/nettle/afterattack(atom/A as mob|obj, mob/user,proximity)
	. = ..()
	if(!proximity)
		return
	if(force > 0)
		force -= rand(1, (force / 3) + 1) // When you whack someone with it, leaves fall off
	else
		to_chat(usr, span_warning("Все листья опали с [src] после сильного удара."))
		qdel(src)

/obj/item/food/grown/nettle/death
	seed = /obj/item/seeds/nettle/death
	name = "Смертельная крапива"
	desc = "<span class='danger'>Крапива</span> сильно <span class='boldannounce'>раздражает</span> тебя от одного лишь взгляда!"
	icon_state = "deathnettle"
	force = 30
	wound_bonus = CANT_WOUND
	throwforce = 15

/obj/item/food/grown/nettle/death/Initialize(mapload, obj/item/seeds/new_seed)
	. = ..()
	force = round((5 + seed.potency / 2.5), 1)

/obj/item/food/grown/nettle/death/burn_holder(mob/living/carbon/user)
	. = ..()
	if(prob(50))
		user.Paralyze(100)
		to_chat(user, span_userdanger("[capitalize(src.name)] обжигает мою руку, когда я пытаюсь дотронуться до неё!"))

/obj/item/food/grown/nettle/death/attack(mob/living/carbon/M, mob/user)
	if(!..())
		return
	if(isliving(M))
		to_chat(M, span_danger("Кислота сочится из [src], когда я пытаюсь дотронуться до неё и очень сильно обжигает мою руку!"))
		log_combat(user, M, "attacked", src)

		M.adjust_blurriness(force/7)
		if(prob(20))
			M.Unconscious(force / 0.3)
			M.Paralyze(force / 0.75)
		M.drop_all_held_items()
