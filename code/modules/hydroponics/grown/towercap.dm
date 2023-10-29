/obj/item/seeds/tower
	name = "Пачка мицелия древошляпника"
	desc = "Этот мицелий вырастает в древошляпника."
	icon_state = "mycelium-tower"
	species = "towercap"
	plantname = "Tower Caps"
	product = /obj/item/grown/log
	lifespan = 80
	endurance = 50
	maturation = 15
	production = 1
	yield = 5
	potency = 50
	growthstages = 3
	growing_icon = 'icons/obj/hydroponics/growing_mushrooms.dmi'
	icon_dead = "towercap-dead"
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism, /datum/plant_gene/trait/oxygenerator)
	mutatelist = list(/obj/item/seeds/tower/steel)
	reagents_add = list(/datum/reagent/cellulose = 0.05)
	graft_gene = /datum/plant_gene/trait/plant_type/fungal_metabolism

/obj/item/seeds/tower/steel
	name = "Пачка мицелия металлошляпника"
	desc = "Этот мицелий вырастает в металлические брёвна."
	icon_state = "mycelium-steelcap"
	species = "steelcap"
	plantname = "Steel Caps"
	product = /obj/item/grown/log/steel
	genes = list(/datum/plant_gene/trait/plant_type/fungal_metabolism, /datum/plant_gene/trait/cogenerator)
	mutatelist = list()
	reagents_add = list(/datum/reagent/cellulose = 0.05, /datum/reagent/iron = 0.05)
	rarity = 20




/obj/item/grown/log
	seed = /obj/item/seeds/tower
	name = "Бревно древошляпника"
	desc = "Лучше, чем плохо, это хорошо!"
	icon_state = "logs"
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 2
	throw_range = 3
	attack_verb_continuous = list("колотит", "бьёт", "ударяет", "вмазывает")
	attack_verb_simple = list("колотит", "бьёт", "ударяет", "вмазывает")
	var/plank_type = /obj/item/stack/sheet/mineral/wood
	var/plank_name = "доски"
	var/static/list/accepted = typecacheof(list(/obj/item/food/grown/tobacco,
	/obj/item/food/grown/tea,
	/obj/item/food/grown/ambrosia/vulgaris,
	/obj/item/food/grown/ambrosia/deus,
	/obj/item/food/grown/wheat))

/obj/item/grown/log/Initialize(mapload, obj/item/seeds/new_seed)
	. = ..()
	register_context()

/obj/item/grown/log/add_context(
	atom/source,
	list/context,
	obj/item/held_item,
	mob/living/user,
)

	if(isnull(held_item))
		return NONE

	if(held_item.get_sharpness())
		// May be a little long, but I think "cut into planks" for steel caps may be confusing.
		context[SCREENTIP_CONTEXT_LMB] = "Порубить на [plank_name]"
		return CONTEXTUAL_SCREENTIP_SET

	if(CheckAccepted(held_item))
		context[SCREENTIP_CONTEXT_LMB] = "Сделать факел"
		return CONTEXTUAL_SCREENTIP_SET

	return NONE

/obj/item/grown/log/attackby(obj/item/W, mob/user, params)
	if(W.get_sharpness())
		user.show_message(span_notice("Заготавливаю [plank_name] из <b>[src.name]</b>!") , MSG_VISUAL)
		var/seed_modifier = 0
		if(seed)
			seed_modifier = round(seed.potency / 25)
		var/obj/item/stack/plank = new plank_type(user.loc, 1 + seed_modifier)
		var/old_plank_amount = plank.amount
		for(var/obj/item/stack/ST in user.loc)
			if(ST != plank && istype(ST, plank_type) && ST.amount < ST.max_amount)
				ST.attackby(plank, user) //we try to transfer all old unfinished stacks to the new stack we created.
		if(plank.amount > old_plank_amount)
			to_chat(user, span_notice("Добавляю новую [plank_name] в кучу. Теперь тут [plank.amount] [plank_name]."))
		qdel(src)

	if(CheckAccepted(W))
		var/obj/item/food/grown/leaf = W
		if(HAS_TRAIT(leaf, TRAIT_DRIED))
			user.show_message(span_notice("Оборачиваю [W] вокруг бревна и получаю факел!"))
			var/obj/item/flashlight/flare/torch/T = new /obj/item/flashlight/flare/torch(user.loc)
			usr.dropItemToGround(W)
			usr.put_in_active_hand(T)
			qdel(leaf)
			qdel(src)
			return
		else
			to_chat(usr, span_warning("Сначала надо высушить!"))
	else
		return ..()

/obj/item/grown/log/proc/CheckAccepted(obj/item/I)
	return is_type_in_typecache(I, accepted)

/obj/item/grown/log/tree
	seed = null
	name = "деревянное бревно"
	desc = "ДЕ-РЕ-ВО!"

/obj/item/grown/log/steel
	seed = /obj/item/seeds/tower/steel
	name = "металлическое бревно"
	desc = "Сделано из металла."
	icon_state = "steellogs"
	plank_type = /obj/item/stack/rods
	plank_name = "стержни"

/obj/item/grown/log/steel/CheckAccepted(obj/item/I)
	return FALSE

/obj/item/seeds/bamboo
	name = "Пачка семян бамбука"
	desc = "Растение, знаменитое его быстрым ростом и ассоциацией с пандами."
	icon_state = "seed-bamboo"
	species = "bamboo"
	plantname = "Bamboo"
	product = /obj/item/grown/log/bamboo
	lifespan = 80
	endurance = 70
	maturation = 15
	production = 2
	yield = 5
	potency = 50
	growthstages = 2
	growing_icon = 'icons/obj/hydroponics/growing.dmi'
	icon_dead = "bamboo-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/oxygenerator)

/obj/item/grown/log/bamboo
	seed = /obj/item/seeds/bamboo
	name = "Бревно бамбука"
	desc = "Длинное и прочное бамбуковое бревно."
	icon_state = "bamboo"
	plank_type = /obj/item/stack/sheet/mineral/bamboo
	plank_name = "бамбуковые палочки"

/obj/item/grown/log/bamboo/CheckAccepted(obj/item/I)
	return FALSE

/obj/structure/punji_sticks
	name = "Ловушка пунджи"
	desc = "Сраные гуки..."
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "punji"
	resistance_flags = FLAMMABLE
	max_integrity = 30
	density = FALSE
	anchored = TRUE
	buckle_lying = 90
	/// Overlay we apply when impaling a mob.
	var/mutable_appearance/stab_overlay

/obj/structure/punji_sticks/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/caltrop, min_damage = 20, max_damage = 30, flags = CALTROP_BYPASS_SHOES)
	build_stab_overlay()

/obj/structure/punji_sticks/proc/build_stab_overlay()
	stab_overlay = mutable_appearance(icon, "[icon_state]_stab", layer = ABOVE_MOB_LAYER, offset_spokesman = src, plane = GAME_PLANE_FOV_HIDDEN)

/obj/structure/punji_sticks/on_changed_z_level(turf/old_turf, turf/new_turf, same_z_layer, notify_contents)
	. = ..()
	if(same_z_layer)
		return
	build_stab_overlay()
	update_appearance()

/obj/structure/punji_sticks/post_buckle_mob(mob/living/M)
	update_appearance()
	return ..()

/obj/structure/punji_sticks/post_unbuckle_mob(mob/living/M)
	update_appearance()
	return ..()

/obj/structure/punji_sticks/update_overlays()
	. = ..()
	if(length(buckled_mobs))
		. += stab_overlay

/obj/structure/punji_sticks/intercept_zImpact(list/falling_movables, levels)
	. = ..()
	for(var/mob/living/fallen_mob in falling_movables)
		if(LAZYLEN(buckled_mobs))
			return
		if(buckle_mob(fallen_mob, TRUE))
			to_chat(fallen_mob, span_userdanger("You are impaled by [src]!"))
			fallen_mob.apply_damage(25 * levels, BRUTE, sharpness = SHARP_POINTY)
			if(iscarbon(fallen_mob))
				var/mob/living/carbon/fallen_carbon = fallen_mob
				fallen_carbon.emote("scream")
				fallen_carbon.bleed(30)
	. |= FALL_INTERCEPTED | FALL_NO_MESSAGE

/obj/structure/punji_sticks/unbuckle_mob(mob/living/buckled_mob, force, can_fall)
	if(force)
		return ..()
	to_chat(buckled_mob, span_warning("You begin climbing out of [src]."))
	buckled_mob.apply_damage(5, BRUTE, sharpness = SHARP_POINTY)
	if(!do_after(buckled_mob, 5 SECONDS, target = src))
		to_chat(buckled_mob, span_userdanger("You fail to detach yourself from [src]."))
		return
	return ..()

/obj/structure/punji_sticks/spikes
	name = "Деревянные шипы"
	icon_state = "woodspike"
