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

/obj/structure/reagent_dispensers/examine(mob/user)
	. = ..()
	if(can_be_tanked)
		. += "<hr><span class='notice'>Можно использовать лист метала, чтобы заставить это работать с химическими трубами.</span>"

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
	else
		return ..()

/obj/structure/reagent_dispensers/Initialize()
	create_reagents(tank_volume, DRAINABLE | AMOUNT_VISIBLE)
	if(reagent_id)
		reagents.add_reagent(reagent_id, tank_volume)
	. = ..()

/obj/structure/reagent_dispensers/proc/boom()
	visible_message(span_danger("<b>[src.name]</b> разрывается!"))
	chem_splash(loc, 5, list(reagents))
	qdel(src)

/obj/structure/reagent_dispensers/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(!disassembled)
			boom()
	else
		qdel(src)

/obj/structure/reagent_dispensers/watertank
	name = "бак с водой"
	desc = "С водой."
	icon_state = "water"

/obj/structure/reagent_dispensers/watertank/high
	name = "бак с водой под высоким давлением"
	desc = "Эта штука может хранить ОЧЕНЬ много воды."
	icon_state = "water_high" //I was gonna clean my room...
	tank_volume = 100000

/obj/structure/reagent_dispensers/foamtank
	name = "бак с пеной для огнетушителей"
	desc = "Раствор используется для быстрого тушения пожаров."
	icon_state = "foam"
	reagent_id = /datum/reagent/firefighting_foam
	tank_volume = 500

/obj/structure/reagent_dispensers/fueltank
	name = "топливный бак"
	desc = "Заполнен сварочным топливом. Не пить."
	icon_state = "fuel"
	reagent_id = /datum/reagent/fuel

/obj/structure/reagent_dispensers/fueltank/boom()
	explosion(get_turf(src), 0, 1, 5, flame_range = 5)
	qdel(src)

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
			boom()
		return
	return ..()

/obj/structure/reagent_dispensers/fueltank/attackby_secondary(obj/item/I, mob/user, params)
	. = ..()
	if(I.tool_behaviour == TOOL_WELDER)
		var/obj/item/weldingtool/W = I
		if(istype(W) && W.welding)
			. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
			user.visible_message(span_danger("[user] начинает ТАКТИКУЛЬНО греть [src] с помощью [user.ru_ego()] [I.name]!"), span_userdanger("Прикол инбаунд."))
			if(do_after(user, 10 SECONDS, src))
				explosion(get_turf(src), 1, 3, 7, flame_range = 9)
				qdel(src)

/obj/structure/reagent_dispensers/fueltank/large
	name = "бак с топливом под высоким давлением"
	desc = "Заполнен сварочным топливом под высоким давлением. Держать вдали от огня."
	icon_state = "fuel_high"
	tank_volume = 5000

/obj/structure/reagent_dispensers/fueltank/large/boom()
	explosion(get_turf(src), 1, 2, 7, flame_range = 12)
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

/obj/structure/reagent_dispensers/peppertank/Initialize()
	. = ..()
	if(prob(1))
		desc = "ВРЕМЯ ПЕРЦА, СУКА!"


/obj/structure/reagent_dispensers/water_cooler
	name = "кулер"
	desc = "Машина, которая раздаёт воду. Да."
	icon = 'icons/obj/vending.dmi'
	icon_state = "water_cooler"
	anchored = TRUE
	tank_volume = 500
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

/obj/structure/reagent_dispensers/beerkeg/attack_animal(mob/living/simple_animal/M)
	if(isdog(M))
		explosion(src.loc,0,3,5,7,10)
		if(!QDELETED(src))
			qdel(src)
		return TRUE
	. = ..()

/obj/structure/reagent_dispensers/beerkeg/blob_act(obj/structure/blob/B)
	explosion(src.loc,0,3,5,7,10)
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
	AddComponent(/datum/component/simple_rotation, ROTATION_ALTCLICK | ROTATION_CLOCKWISE | ROTATION_COUNTERCLOCKWISE | ROTATION_VERBS, null, CALLBACK(src, .proc/can_be_rotated))

/obj/structure/reagent_dispensers/plumbed/storage/update_overlays()
	. = ..()
	if(reagents)
		if(reagents.total_volume)
			var/mutable_appearance/tank_color = mutable_appearance('icons/obj/chemical_tanks.dmi', "tank_chem_overlay")
			tank_color.color = mix_color_from_reagents(reagents.reagent_list)
			add_overlay(tank_color)
		else
			cut_overlays()

/obj/structure/reagent_dispensers/plumbed/storage/proc/can_be_rotated(mob/user, rotation_type)
	if(anchored)
		to_chat(user, span_warning("It is fastened to the floor!"))
	return !anchored

/obj/structure/reagent_dispensers/plumbed/fuel
	name = "стационарный топливный бак"
	icon_state = "fuel_stationary"
	reagent_id = /datum/reagent/fuel
