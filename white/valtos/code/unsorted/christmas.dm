/obj/item/stack/garland_pack
	name = "упаковка с гирляндами"
	singular_name = "упаковка с гирляндой"
	desc = "Похоже, пришло время вешать это на стены."
	icon = 'white/valtos/icons/ny.dmi'
	icon_state = "garland_pack"
	merge_type = /obj/item/stack/garland_pack
	max_amount = 50
	novariants = TRUE

/obj/item/stack/garland_pack/fifty
	amount = 50

/obj/item/stack/garland_pack/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(isclosedturf(target) && proximity)
		user.changeNext_move(1)
		var/turf/closed/T = target
		if(locate(/obj/structure/garland) in T)
			to_chat(user, span_warning("Здесь уже есть гирлянда!"))
			return
		if(use(1))
			user.visible_message(span_notice("[user] вешает [src] на [T].") , \
								span_notice("Вешаю гирлянду на [T]."))
			playsound(T, 'sound/items/deconstruct.ogg', 50, TRUE)
			var/obj/structure/garland/S = new(T)
			transfer_fingerprints_to(S)

/obj/structure/snowflakes
	name = "снежинки"
	desc = "Выглядят ужасно."
	icon = 'white/valtos/icons/ny.dmi'
	icon_state = "snowflakes_1"
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE

/obj/structure/snowflakes/Initialize()
	. = ..()
	icon_state = "snowflakes_[rand(1, 4)]"

/obj/structure/garland
	name = "гирлянда"
	desc = "Зима близко!"
	anchored = TRUE
	opacity = FALSE
	icon = 'white/valtos/icons/ny.dmi'
	icon_state = "garland"
	layer = SIGN_LAYER
	max_integrity = 100
	var/on = FALSE
	var/brightness = 4

/obj/structure/garland/Initialize()
	. = ..()
	light_color = pick("#ff0000", "#6111ff", "#ffa500", "#44faff")
	update_garland()

/obj/structure/garland/proc/update_garland()
	if(!on)
		icon_state = "garland_on"
		set_light(brightness)
	else
		icon_state = "garland"
		set_light(0)

/obj/structure/garland/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(I.tool_behaviour == TOOL_MULTITOOL)
		to_chat(user, span_notice("[on ? "Выключаю" : "Включаю"] гирлянду."))
		update_garland()

/obj/structure/garland/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	to_chat(user, span_notice("Начинаю снимать [src]..."))
	if(do_after(user, 50, target = src))
		var/obj/item/stack/garland_pack/M = new(loc)
		transfer_fingerprints_to(M)
		if(user.put_in_hands(M, TRUE))
			playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
			qdel(src)
