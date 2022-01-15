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
	desc = "Это лучше, чем плохо, это хорошо!"
	icon_state = "logs"
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 2
	throw_range = 3
	attack_verb_continuous = list("колотит", "бьёт", "ударяет", "вмазывает")
	attack_verb_simple = list("колотит", "бьёт", "ударяет", "вмазывает")
	var/plank_type = /obj/item/stack/sheet/mineral/wood
	var/plank_name = "wooden planks"
	var/static/list/accepted = typecacheof(list(/obj/item/food/grown/tobacco,
	/obj/item/food/grown/tea,
	/obj/item/food/grown/ambrosia/vulgaris,
	/obj/item/food/grown/ambrosia/deus,
	/obj/item/food/grown/wheat))

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
	name = "Деревянное бревно"
	desc = "ДЕ-РЕ-ВО!"

/obj/item/grown/log/steel
	seed = /obj/item/seeds/tower/steel
	name = "Металлическое бревно"
	desc = "Это сделано из металла."
	icon_state = "steellogs"
	plank_type = /obj/item/stack/rods
	plank_name = "rods"

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
	plank_name = "bamboo sticks"

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

/obj/structure/punji_sticks/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/caltrop, min_damage = 20, max_damage = 30, flags = CALTROP_BYPASS_SHOES)

/obj/structure/punji_sticks/spikes
	name = "Деревянные шипы"
	icon_state = "woodspike"

/////////BONFIRES//////////

/obj/structure/bonfire
	name = "Костёр"
	desc = "Для гриля, жарки, обугливания, копчения, нагрева, поджаривания, кипения, обжигания, плавления и иногда сжигания вещей."
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "bonfire"
	light_color = LIGHT_COLOR_FIRE
	density = FALSE
	anchored = TRUE
	buckle_lying = 0
	pass_flags_self = PASSTABLE | LETPASSTHROW
	var/burning = 0
	var/burn_icon = "bonfire_on_fire" //for a softer more burning embers icon, use "bonfire_warm"
	var/grill = FALSE
	var/fire_stack_strength = 5

/obj/structure/bonfire/bluespace
	name = "блюспейс костёр"

/obj/structure/bonfire/dense
	density = TRUE

/obj/structure/bonfire/prelit/Initialize()
	. = ..()
	spawn(10)
		StartBurning()

/obj/structure/bonfire/Initialize()
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/on_entered,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/bonfire/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/stack/rods) && !can_buckle && !grill)
		var/obj/item/stack/rods/R = W
		var/choice = input(user, "What would you like to construct?", "Bonfire") as null|anything in list("Stake","Grill")
		switch(choice)
			if("Stake")
				R.use(1)
				can_buckle = TRUE
				buckle_requires_restraints = TRUE
				to_chat(user, span_notice("Добавляю прутик в <b>[src.name]</b>."))
				var/mutable_appearance/rod_underlay = mutable_appearance('icons/obj/hydroponics/equipment.dmi', "bonfire_rod")
				rod_underlay.pixel_y = 16
				underlays += rod_underlay
			if("Grill")
				R.use(1)
				grill = TRUE
				to_chat(user, span_notice("Добавляю гриль в <b>[src.name]</b>."))
				add_overlay("bonfire_grill")
			else
				return ..()
	if(W.get_temperature())
		StartBurning()
	if(grill)
		if(user.a_intent != INTENT_HARM && !(W.item_flags & ABSTRACT))
			if(user.temporarilyRemoveItemFromInventory(W))
				W.forceMove(get_turf(src))
				var/list/click_params = params2list(params)
				//Center the icon where the user clicked.
				if(!click_params || !click_params["icon-x"] || !click_params["icon-y"])
					return
				//Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
				W.pixel_x = W.base_pixel_x + clamp(text2num(click_params["icon-x"]) - 16, -(world.icon_size/2), world.icon_size/2)
				W.pixel_y = W.base_pixel_y + clamp(text2num(click_params["icon-y"]) - 16, -(world.icon_size/2), world.icon_size/2)
		else
			return ..()


/obj/structure/bonfire/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(burning)
		to_chat(user, span_warning("Нужно потушить [src], чтобы достать брёвна!"))
		return
	if(!has_buckled_mobs() && do_after(user, 50, target = src))
		for(var/obj/item/grown/log/L in contents)
			L.forceMove(drop_location())
			L.pixel_x += rand(1,4)
			L.pixel_y += rand(1,4)
		if(can_buckle || grill)
			new /obj/item/stack/rods(loc, 1)
		qdel(src)
		return

/obj/structure/bonfire/proc/CheckOxygen()
	if(isopenturf(loc))
		var/turf/open/O = loc
		if(O.air)
			if(O.air.get_moles(/datum/gas/oxygen) > 13)
				return TRUE
	return FALSE

/obj/structure/bonfire/proc/StartBurning()
	if(!burning && CheckOxygen())
		icon_state = burn_icon
		burning = TRUE
		set_light(6)
		Burn()
		START_PROCESSING(SSobj, src)

/obj/structure/bonfire/fire_act(exposed_temperature, exposed_volume)
	StartBurning()

/obj/structure/bonfire/proc/on_entered(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(burning & !grill)
		Burn()

/obj/structure/bonfire/proc/Burn(delta_time = 2)
	var/turf/current_location = get_turf(src)
	current_location.hotspot_expose(1000, 250 * delta_time, 1)
	for(var/A in current_location)
		if(A == src)
			continue
		if(isobj(A))
			var/obj/O = A
			O.fire_act(1000, 250 * delta_time)
		else if(isliving(A))
			var/mob/living/L = A
			L.adjust_fire_stacks(fire_stack_strength * 0.5 * delta_time)
			L.IgniteMob()

/obj/structure/bonfire/proc/Cook(delta_time = 2)
	var/turf/current_location = get_turf(src)
	for(var/A in current_location)
		if(A == src)
			continue
		else if(isliving(A)) //It's still a fire, idiot.
			var/mob/living/L = A
			L.adjust_fire_stacks(fire_stack_strength * 0.5 * delta_time)
			L.IgniteMob()
		else if(istype(A, /obj/item))
			var/obj/item/grilled_item = A
			SEND_SIGNAL(grilled_item, COMSIG_ITEM_GRILLED, src, delta_time) //Not a big fan, maybe make this use fire_act() in the future.

/obj/structure/bonfire/process(delta_time)
	if(!CheckOxygen())
		extinguish()
		return
	if(!grill)
		Burn(delta_time)
	else
		Cook(delta_time)

/obj/structure/bonfire/extinguish()
	if(burning)
		icon_state = "bonfire"
		burning = 0
		set_light(0)
		STOP_PROCESSING(SSobj, src)

/obj/structure/bonfire/buckle_mob(mob/living/M, force = FALSE, check_loc = TRUE)
	if(..())
		M.pixel_y += 13

/obj/structure/bonfire/unbuckle_mob(mob/living/buckled_mob, force = FALSE, can_fall = TRUE)
	if(..())
		buckled_mob.pixel_y -= 13
