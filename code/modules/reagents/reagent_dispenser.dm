/obj/structure/reagent_dispensers
	name = "Раздатчик"
	desc = "..."
	icon = 'icons/obj/chemical_tanks.dmi'
	icon_state = "water"
	density = TRUE
	anchored = FALSE
	pressure_resistance = 2*ONE_ATMOSPHERE
	max_integrity = 300
	///In units, how much the dispenser can hold
	var/tank_volume = 1000
	///The ID of the reagent that the dispenser uses
	var/reagent_id = /datum/reagent/water
	///Can you turn this into a plumbing tank?
	var/can_be_tanked = TRUE
	///Is this source self-replenishing?
	var/refilling = FALSE
	///Can this dispenser be opened using a wrench?
	var/openable = FALSE
	///Is this dispenser slowly leaking its reagent?
	var/leaking = FALSE
	///How much reagent to leak
	var/amount_to_leak = 10

/obj/structure/reagent_dispensers/examine(mob/user)
	. = ..()
	if(can_be_tanked)
		. += "<hr><span class='notice'>Можно использовать лист метала, чтобы заставить это работать с химическими трубами.</span>"
	if(leaking)
		. += span_warning("<hr>Заглушка откручена!")

/obj/structure/reagent_dispensers/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	if(. && obj_integrity > 0)
		if(tank_volume && (damage_flag == BULLET || damage_flag == LASER))
			boom()

/obj/structure/reagent_dispensers/attackby(obj/item/W, mob/user, params)
	if(W.is_refillable())
		return FALSE //so we can refill them via their afterattack.
	if(istype(W, /obj/item/stack/sheet/iron) && can_be_tanked)
		var/obj/item/stack/sheet/iron/metal_stack = W
		metal_stack.use(1)
		var/obj/structure/reagent_dispensers/plumbed/storage/new_tank = new /obj/structure/reagent_dispensers/plumbed/storage(drop_location())
		new_tank.reagents.maximum_volume = reagents.maximum_volume
		reagents.trans_to(new_tank, reagents.total_volume)
		new_tank.name = "стационарный [name]"
		new_tank.update_overlays()
		new_tank.anchored = anchored
		qdel(src)
		return FALSE
	return ..()

/obj/structure/reagent_dispensers/Initialize(mapload)
	create_reagents(tank_volume, DRAINABLE | AMOUNT_VISIBLE)
	if(reagent_id)
		reagents.add_reagent(reagent_id, tank_volume)
	. = ..()
	if(icon_state == "water" && SSevents.holidays?[APRIL_FOOLS])
		icon_state = "water_fools"

/obj/structure/reagent_dispensers/proc/boom()
	visible_message(span_danger("<b>[capitalize(src)]</b> разрывается!"))
	chem_splash(loc, 5, list(reagents))
	qdel(src)

/obj/structure/reagent_dispensers/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(!disassembled)
			boom()
	else
		qdel(src)

/obj/structure/reagent_dispensers/proc/tank_leak()
	if(leaking && reagents && reagents.total_volume >= amount_to_leak)
		reagents.expose(get_turf(src), TOUCH, amount_to_leak / max(amount_to_leak, reagents.total_volume))
		reagents.remove_reagent(reagent_id, amount_to_leak)
		return TRUE
	return FALSE

/obj/structure/reagent_dispensers/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	if(!openable)
		return FALSE
	leaking = !leaking
	balloon_alert(user, "[leaking ? "открываю" : "закрываю"] заглушку [src]")
	log_game("[key_name(user)] [leaking ? "opened" : "closed"] [src]")
	tank_leak()
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/structure/reagent_dispensers/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	tank_leak()


/obj/structure/reagent_dispensers/watertank
	name = "бак с водой"
	desc = "С водой."
	icon_state = "water"
	openable = TRUE

/obj/structure/reagent_dispensers/watertank/high
	name = "огромный бак с водой"
	desc = "Бак, содержащий в себе ОЧЕНЬ много воды."
	icon_state = "water_high" //I was gonna clean my room...
	tank_volume = 100000

/obj/structure/reagent_dispensers/foamtank
	name = "бак с пеной для огнетушителей"
	desc = "Раствор используется для быстрого тушения пожаров."
	icon_state = "foam"
	reagent_id = /datum/reagent/firefighting_foam
	tank_volume = 500
	openable = TRUE

/obj/structure/reagent_dispensers/fueltank
	name = "топливный бак"
	desc = "Заполнен сварочным топливом. Не пить."
	icon_state = "fuel"
	reagent_id = /datum/reagent/fuel
	openable = TRUE
	//an assembly attached to the tank
	var/obj/item/assembly_holder/rig = null
	//whether it accepts assemblies or not
	var/accepts_rig = TRUE
	//overlay of attached assemblies
	var/mutable_appearance/assembliesoverlay
	/// The last person to rig this fuel tank - Stored with the object. Only the last person matters for investigation
	var/last_rigger = ""

/obj/structure/reagent_dispensers/fueltank/Initialize(mapload)
	. = ..()
	if(SSevents.holidays?[APRIL_FOOLS])
		icon_state = "fuel_fools"

/obj/structure/reagent_dispensers/fueltank/Destroy()
	QDEL_NULL(rig)
	return ..()

/obj/structure/reagent_dispensers/fueltank/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == rig)
		rig = null

/obj/structure/reagent_dispensers/fueltank/examine(mob/user)
	. = ..()
	if(get_dist(user, src) <= 2 && rig)
		. += span_notice("Здесь что-то приделано. Хм...")

/obj/structure/reagent_dispensers/fueltank/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!rig)
		return
	user.balloon_alert_to_viewers("отсоединяю сборку...")
	if(!do_after(user, 2 SECONDS, target = src))
		return
	user.balloon_alert_to_viewers("отсоединяю сборку")
	log_message("[key_name(user)] detached [rig] from [src]", LOG_GAME)
	if(!user.put_in_hands(rig))
		rig.forceMove(get_turf(user))
	rig = null
	last_rigger = null
	cut_overlays(assembliesoverlay)
	UnregisterSignal(src, COMSIG_IGNITER_ACTIVATE)

/obj/structure/reagent_dispensers/fueltank/boom()
	explosion(src, heavy_impact_range = 1, light_impact_range = 5, flame_range = 5)
	qdel(src)

/obj/structure/reagent_dispensers/fueltank/proc/rig_boom()
	log_bomber(last_rigger, "rigged fuel tank exploded", src)
	boom()

/obj/structure/reagent_dispensers/fueltank/blob_act(obj/structure/blob/B)
	boom()

/obj/structure/reagent_dispensers/fueltank/ex_act()
	boom()

/obj/structure/reagent_dispensers/fueltank/fire_act(exposed_temperature, exposed_volume)
	boom()

/obj/structure/reagent_dispensers/fueltank/zap_act(power, zap_flags)
	. = ..() //extend the zap
	if(ZAP_OBJ_DAMAGE & zap_flags)
		boom()

/obj/structure/reagent_dispensers/fueltank/bullet_act(obj/projectile/P)
	. = ..()
	if(!QDELETED(src)) //wasn't deleted by the projectile's effects.
		if(!P.nodamage && ((P.damage_type == BURN) || (P.damage_type == BRUTE)))
			log_bomber(P.firer, "detonated a", src, "via projectile")
			boom()

/obj/structure/reagent_dispensers/fueltank/attackby(obj/item/I, mob/living/user, params)
	if(I.tool_behaviour == TOOL_WELDER)
		if(!reagents.has_reagent(/datum/reagent/fuel))
			to_chat(user, span_warning("[capitalize(src.name)] пуст!"))
			return
		var/obj/item/weldingtool/W = I
		if(istype(W) && !W.welding)
			if(W.reagents.has_reagent(/datum/reagent/fuel, W.max_fuel))
				to_chat(user, span_warning("Мой [W.name] полон!"))
				return
			reagents.trans_to(W, W.max_fuel, transfered_by = user)
			user.visible_message(span_notice("[user] заправляет [user.ru_ego()] [W.name].") , span_notice("Заправляю [W]."))
			playsound(src, 'sound/effects/refill.ogg', 50, TRUE)
			W.update_icon()
		else
			user.visible_message(span_danger("[user] делает глупую ошибку пытаясь заправить [user.ru_ego()] [I.name]!") , span_userdanger("Это было глупо."))
			log_bomber(user, "detonated a", src, "via welding tool")
			SSspd.check_action(user?.client, SPD_FUEL_TANK_EXPLOSION)
			boom()
		return
	if(istype(I, /obj/item/assembly_holder) && accepts_rig)
		if(rig)
			user.balloon_alert("здесь уже есть что-то!")
			return ..()
		user.balloon_alert_to_viewers("присоединяю сборку...")
		if(!do_after(user, 2 SECONDS, target = src))
			return
		user.balloon_alert_to_viewers("присоединяю сборку")
		var/obj/item/assembly_holder/holder = I
		if(locate(/obj/item/assembly/igniter) in holder.contents)
			rig = holder
			if(!user.transferItemToLoc(holder, src))
				return
			log_bomber(user, "rigged [name] with [holder.name] for explosion", src)
			SSspd.check_action(user?.client, SPD_FUEL_TANK_EXPLOSION)
			last_rigger = user
			assembliesoverlay = holder
			assembliesoverlay.pixel_x += 6
			assembliesoverlay.pixel_y += 1
			add_overlay(assembliesoverlay)
			RegisterSignal(src, COMSIG_IGNITER_ACTIVATE, PROC_REF(rig_boom))
		return
	return ..()

/obj/structure/reagent_dispensers/fueltank/attackby_secondary(obj/item/I, mob/user, params)
	. = ..()
	if(I.tool_behaviour == TOOL_WELDER)
		var/obj/item/weldingtool/W = I
		if(istype(W) && W.welding)
			. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
			user.visible_message(span_danger("[user] начинает ТАКТИКУЛЬНО греть [src] с помощью [user.ru_ego()] [I.name]!"), span_userdanger("Прикол инбаунд."))
			SSspd.check_action(user?.client, SPD_FUEL_TANK_EXPLOSION)
			if(do_after(user, 10 SECONDS, src))
				explosion(src, devastation_range = 1, heavy_impact_range = 3, light_impact_range = 7, flame_range = 7)
				qdel(src)

/obj/structure/reagent_dispensers/fueltank/large
	name = "бак с топливом под высоким давлением"
	desc = "Заполнен сварочным топливом под высоким давлением. Держать вдали от огня."
	icon_state = "fuel_high"
	tank_volume = 5000

/obj/structure/reagent_dispensers/fueltank/large/boom()
	explosion(src, devastation_range = 1, heavy_impact_range = 2, light_impact_range = 7, flame_range = 12)
	qdel(src)

/obj/structure/reagent_dispensers/fueltank/limitka
	name = "фуелтанк-лимитка"
	desc = "<font size=+2><b>Пиздец блядь нахуй!</b></font>"
	icon_state = "fuel_pizdec"
	tank_volume = 100000

/obj/structure/reagent_dispensers/fueltank/limitka/boom()
	explosion(src, heavy_impact_range = 7, light_impact_range = 14, flame_range = 21, flash_range = 34)
	qdel(src)

/obj/structure/reagent_dispensers/peppertank
	name = "бак с капсаицином"
	desc = "Содержит конденсированный капсаицин для \"правосудия.\""
	icon_state = "pepper"
	anchored = TRUE
	density = FALSE
	reagent_id = /datum/reagent/consumable/condensedcapsaicin

/obj/structure/reagent_dispensers/peppertank/directional/north
	dir = SOUTH
	pixel_y = 30

/obj/structure/reagent_dispensers/peppertank/directional/south
	dir = NORTH
	pixel_y = -30

/obj/structure/reagent_dispensers/peppertank/directional/east
	dir = WEST
	pixel_x = 30

/obj/structure/reagent_dispensers/peppertank/directional/west
	dir = EAST
	pixel_x = -30

/obj/structure/reagent_dispensers/peppertank/Initialize(mapload)
	. = ..()
	if(prob(1))
		desc = "ВРЕМЯ ПЕРЦА, СУКА!"


/obj/structure/reagent_dispensers/water_cooler
	name = "кулер"
	desc = "Машина, которая раздаёт воду. Да."
	icon = 'icons/obj/vending.dmi'
	icon_state = "water_cooler"
	anchored = TRUE
	tank_volume = 1500
	var/paper_cups = 25 //Paper cups left from the cooler

/obj/structure/reagent_dispensers/water_cooler/examine(mob/user)
	. = ..()
	. += "<hr>"
	if (paper_cups > 1)
		. += "Внутри осталось [paper_cups] бумажных стаканчиков."
	else if (paper_cups == 1)
		. += "Внутри остался один бумажный стаканчик."
	else
		. += "Внутри больше нет бумажных стаканчиков."

/obj/structure/reagent_dispensers/water_cooler/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!paper_cups)
		to_chat(user, span_warning("Внутри нет стаканчиков!"))
		return
	user.visible_message(span_notice("[user] достаёт стаканчик из [src].") , span_notice("Достаю стаканчик из [src]."))
	var/obj/item/reagent_containers/food/drinks/sillycup/S = new(get_turf(src))
	user.put_in_hands(S)
	paper_cups--

/obj/structure/reagent_dispensers/beerkeg
	name = "пивная кега"
	desc = "Пиво это жидкий хлеб, оно полезное..."
	icon_state = "beer"
	reagent_id = /datum/reagent/consumable/ethanol/beer
	openable = TRUE

/obj/structure/reagent_dispensers/beerkeg/attack_animal(mob/living/simple_animal/M)
	if(isdog(M))
		explosion(src, light_impact_range = 3, flame_range = 5, flash_range = 10)
		if(!QDELETED(src))
			qdel(src)
		return TRUE
	. = ..()

/obj/structure/reagent_dispensers/beerkeg/blob_act(obj/structure/blob/B)
	explosion(src, light_impact_range = 3, flame_range = 5, flash_range = 10)
	if(!QDELETED(src))
		qdel(src)


/obj/structure/reagent_dispensers/virusfood
	name = "раздатчик питательных веществ для вирусов"
	desc = "Для слабых мутаций вирусов."
	icon_state = "virus_food"
	anchored = TRUE
	density = FALSE
	reagent_id = /datum/reagent/consumable/virus_food

/obj/structure/reagent_dispensers/virusfood/directional/north
	dir = SOUTH
	pixel_y = 30

/obj/structure/reagent_dispensers/virusfood/directional/south
	dir = NORTH
	pixel_y = -30

/obj/structure/reagent_dispensers/virusfood/directional/east
	dir = WEST
	pixel_x = 30

/obj/structure/reagent_dispensers/virusfood/directional/west
	dir = EAST
	pixel_x = -30

/obj/structure/reagent_dispensers/cooking_oil
	name = "бочка с маслом"
	desc = "Огромная металлическая бочка заполненная маслом, которое используется для жарки еды."
	icon_state = "vat"
	anchored = TRUE
	reagent_id = /datum/reagent/consumable/cooking_oil
	openable = TRUE

/obj/structure/reagent_dispensers/servingdish
	name = "посудина с чем-то"
	desc = "Заполнена вкусняхой."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "serving"
	anchored = TRUE
	reagent_id = /datum/reagent/consumable/nutraslop

/obj/structure/reagent_dispensers/plumbed
	name = "стационарный бак с водой"
	anchored = TRUE
	icon_state = "water_stationary"
	desc = "Для химических задач."
	can_be_tanked = FALSE

/obj/structure/reagent_dispensers/plumbed/wrench_act(mob/living/user, obj/item/I)
	..()
	default_unfasten_wrench(user, I)
	return TRUE

/obj/structure/reagent_dispensers/plumbed/ComponentInitialize()
	AddComponent(/datum/component/plumbing/simple_supply)

/obj/structure/reagent_dispensers/plumbed/storage
	name = "стационарный бак"
	icon_state = "tank_stationary"
	reagent_id = null //start empty

/obj/structure/reagent_dispensers/plumbed/storage/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/simple_rotation, ROTATION_ALTCLICK | ROTATION_CLOCKWISE | ROTATION_COUNTERCLOCKWISE | ROTATION_VERBS, null, CALLBACK(src, PROC_REF(can_be_rotated)))

/obj/structure/reagent_dispensers/plumbed/storage/update_overlays()
	. = ..()
	if(!reagents)
		return

	if(!reagents.total_volume)
		return

	var/mutable_appearance/tank_color = mutable_appearance('icons/obj/chemical_tanks.dmi', "tank_chem_overlay")
	tank_color.color = mix_color_from_reagents(reagents.reagent_list)
	. += tank_color

/obj/structure/reagent_dispensers/plumbed/storage/proc/can_be_rotated(mob/user, rotation_type)
	if(anchored)
		to_chat(user, span_warning("It is fastened to the floor!"))
	return !anchored

/obj/structure/reagent_dispensers/plumbed/fuel
	name = "стационарный топливный бак"
	icon_state = "fuel_stationary"
	reagent_id = /datum/reagent/fuel
