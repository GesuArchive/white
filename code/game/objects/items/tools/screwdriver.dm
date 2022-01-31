/obj/item/screwdriver
	name = "отвёртка"
	desc = "Ею можно откручивать и закручивать различные штуки."
	gender = FEMALE
	icon = 'white/valtos/icons/items.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	icon_state = "screwdriver_map"
	inhand_icon_state = "screwdriver"
	worn_icon_state = "screwdriver"
	belt_icon_state = "screwdriver"
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	force = 5
	w_class = WEIGHT_CLASS_TINY
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	custom_materials = list(/datum/material/iron=75)
	attack_verb_continuous = list("втыкает")
	attack_verb_simple = list("втыкает")
	hitsound = 'sound/weapons/bladeslice.ogg'
	usesound = list('sound/items/screwdriver.ogg', 'sound/items/screwdriver2.ogg')
	tool_behaviour = TOOL_SCREWDRIVER
	toolspeed = 1
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 50, ACID = 30)
	drop_sound = 'sound/items/handling/screwdriver_drop.ogg'
	pickup_sound =  'sound/items/handling/screwdriver_pickup.ogg'
	sharpness = SHARP_POINTY
	var/random_color = TRUE //if the screwdriver uses random coloring
	var/static/list/screwdriver_colors = list(
		"blue" = rgb(24, 97, 213),
		"red" = rgb(255, 0, 0),
		"pink" = rgb(213, 24, 141),
		"brown" = rgb(160, 82, 18),
		"green" = rgb(14, 127, 27),
		"cyan" = rgb(24, 162, 213),
		"yellow" = rgb(255, 165, 0)
	)

/obj/item/screwdriver/suicide_act(mob/user)
	user.visible_message(span_suicide("[user] is stabbing [src] into [user.ru_ego()] [pick("temple", "heart")]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return(BRUTELOSS)

/obj/item/screwdriver/Initialize()
	. = ..()
	AddElement(/datum/element/eyestab)
	if(random_color) //random colors!
		icon_state = "screwdriver"
		var/our_color = pick(screwdriver_colors)
		add_atom_colour(screwdriver_colors[our_color], FIXED_COLOUR_PRIORITY)
		update_icon()
	if(prob(75))
		pixel_y = rand(0, 16)

/obj/item/screwdriver/update_overlays()
	. = ..()
	if(!random_color) //icon override
		return
	var/mutable_appearance/base_overlay = mutable_appearance(icon, "screwdriver_screwybits")
	base_overlay.appearance_flags = RESET_COLOR
	. += base_overlay

/obj/item/screwdriver/worn_overlays(isinhands = FALSE, icon_file)
	. = list()
	if(isinhands && random_color)
		var/mutable_appearance/M = mutable_appearance(icon_file, "screwdriver_head")
		M.appearance_flags = RESET_COLOR
		. += M

/obj/item/screwdriver/get_belt_overlay()
	if(random_color)
		var/mutable_appearance/body = mutable_appearance('white/valtos/icons/belt_overlays.dmi', "screwdriver")
		var/mutable_appearance/head = mutable_appearance('white/valtos/icons/belt_overlays.dmi', "screwdriver_head")
		body.color = color
		head.add_overlay(body)
		return head
	else
		return mutable_appearance('white/valtos/icons/belt_overlays.dmi', icon_state)

/obj/item/screwdriver/abductor
	name = "инопланетная отвёртка"
	desc = "Похожа на экспериментальную сверхзвуковую отвертку."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "screwdriver_a"
	inhand_icon_state = "screwdriver_nuke"
	usesound = 'sound/items/pshoom.ogg'
	toolspeed = 0.1
	random_color = FALSE

/obj/item/screwdriver/abductor/get_belt_overlay()
	return mutable_appearance('white/valtos/icons/belt_overlays.dmi', "screwdriver_nuke")

/obj/item/screwdriver/power
	name = "шуруповерт"
	desc = "Удобный и компактный инструмент со сменными насадками."
	icon_state = "drill"
	belt_icon_state = null
	inhand_icon_state = "drill"
	worn_icon_state = "drill"
	icon = 'white/valtos/icons/items.dmi'
	lefthand_file = 'white/valtos/icons/lefthand.dmi'
	righthand_file = 'white/valtos/icons/righthand.dmi'
	custom_materials = list(/datum/material/iron=150,/datum/material/silver=50,/datum/material/titanium=25) //done for balance reasons, making them high value for research, but harder to get
	force = 8 //might or might not be too high, subject to change
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 8
	throw_speed = 2
	throw_range = 3//it's heavier than a screw driver/wrench, so it does more damage, but can't be thrown as far
	attack_verb_continuous = list("дреллирует", "накручивает", "отвёртничает", "вмазывает")
	attack_verb_simple = list("дреллирует", "накручивает", "отвёртничает", "вмазывает")
	hitsound = 'sound/items/drill_hit.ogg'
	usesound = 'sound/items/drill_use.ogg'
	toolspeed = 0.7
	random_color = FALSE

/obj/item/screwdriver/power/get_belt_overlay()
	return mutable_appearance('white/valtos/icons/belt_overlays.dmi', icon_state)

/obj/item/screwdriver/power/Initialize()
	. = ..()
	AddComponent(/datum/component/transforming, \
		force_on = force, \
		throwforce_on = throwforce, \
		hitsound_on = hitsound, \
		w_class_on = w_class, \
		clumsy_check = FALSE)
	RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, .proc/on_transform)

/*
 * Signal proc for [COMSIG_TRANSFORMING_ON_TRANSFORM].
 *
 * Toggles between crowbar and wirecutters and gives feedback to the user.
 */
/obj/item/screwdriver/power/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	tool_behaviour = (active ? TOOL_WRENCH : TOOL_SCREWDRIVER)
	balloon_alert(user, "ставлю [active ? "большую" : "маленькую"] крутяку")
	playsound(user ? user : src, 'sound/items/change_drill.ogg', 50, TRUE)
	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/screwdriver/power/examine()
	. = ..()
	. += "<hr>На конце установлен [tool_behaviour == TOOL_SCREWDRIVER ? "маленькая" : "большая"] крутяка."

/obj/item/screwdriver/power/suicide_act(mob/user)
	if(tool_behaviour == TOOL_SCREWDRIVER)
		user.visible_message(span_suicide("[user] is putting [src] to [user.ru_ego()] temple. It looks like [user.p_theyre()] trying to commit suicide!"))
	else
		user.visible_message(span_suicide("[user] is pressing [src] against [user.ru_ego()] head! It looks like [user.p_theyre()] trying to commit suicide!"))
	playsound(loc, 'sound/items/drill_use.ogg', 50, TRUE, -1)
	return(BRUTELOSS)

/obj/item/screwdriver/cyborg
	name = "автоматическая отвертка"
	desc = "Мощная автоматическая отвертка, разработанная для быстрой и точной работы."
	icon = 'white/Feline/icons/cyber_arm_tools.dmi'
	icon_state = "screwdriver_cyborg"
	hitsound = 'sound/items/drill_hit.ogg'
	usesound = 'sound/items/drill_use.ogg'
	toolspeed = 0.5
	random_color = FALSE
