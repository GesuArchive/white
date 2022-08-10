/* Beds... get your mind out of the gutter, they're for sleeping!
 * Contains:
 * 		Beds
 *		Roller beds
 */

/*
 * Beds
 */
/obj/structure/bed
	name = "кровать"
	desc = "На ней можно лежать. Или стоять."
	icon_state = "bed"
	icon = 'icons/obj/objects.dmi'
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = 90
	resistance_flags = FLAMMABLE
	max_integrity = 100
	integrity_failure = 0.35
	var/buildstacktype = /obj/item/stack/sheet/iron
	var/buildstackamount = 2
	var/bolts = TRUE

/obj/structure/bed/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/soft_landing)

/obj/structure/bed/examine(mob/user)
	. = ..()
	if(bolts)
		. += "<hr><span class='notice'>Скручено несколькими <b>болтами</b>.</span>"

/obj/structure/bed/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(buildstacktype)
			new buildstacktype(loc,buildstackamount)
	..()

/obj/structure/bed/attack_paw(mob/user)
	return attack_hand(user)

/obj/structure/bed/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_WRENCH && !(flags_1&NODECONSTRUCT_1))
		W.play_tool_sound(src)
		deconstruct(TRUE)
	else
		return ..()

/*
 * Roller beds
 */
/obj/structure/bed/roller
	name = "каталка"
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "down"
	anchored = FALSE
	resistance_flags = NONE

	var/foldabletype = /obj/item/roller

/obj/structure/bed/roller/Initialize(mapload)
	. = ..()
	AddElement( \
		/datum/element/contextual_screentip_bare_hands, \
		rmb_text = "Сложить", \
	)

/obj/structure/bed/roller/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/roller/robo))
		var/obj/item/roller/robo/R = W
		if(R.loaded)
			to_chat(user, span_warning("У меня уже есть пассажир!"))
			return

		if(has_buckled_mobs())
			if(buckled_mobs.len > 1)
				unbuckle_all_mobs()
				user.visible_message(span_notice("[user] поднимает всех с [src]."))
			else
				user_unbuckle_mob(buckled_mobs[1],user)
		else
			R.loaded = src
			forceMove(R)
			user.visible_message(span_notice("[user] собирает [src].") , span_notice("Собираю [src]."))
		return 1
	else
		return ..()

/obj/structure/bed/roller/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!ishuman(user) || !user.canUseTopic(src, BE_CLOSE))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(has_buckled_mobs())
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	user.visible_message(span_notice("[user] складывает [src]."), span_notice("Складываю [src]."))
	var/obj/structure/bed/roller/folding_bed = new foldabletype(get_turf(src))
	user.put_in_hands(folding_bed)
	qdel(src)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/bed/roller/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(over_object == usr && Adjacent(usr))
		if(!ishuman(usr) || !usr.canUseTopic(src, BE_CLOSE))
			return FALSE
		if(has_buckled_mobs())
			return FALSE
		usr.visible_message(span_notice("[usr] складывает [src.name].") , span_notice("Складываю [src.name]."))
		var/obj/structure/bed/roller/B = new foldabletype(get_turf(src))
		usr.put_in_hands(B)
		qdel(src)

/obj/structure/bed/roller/post_buckle_mob(mob/living/M)
	set_density(TRUE)
	icon_state = "up"
	//Push them up from the normal lying position
	M.pixel_y = M.base_pixel_y

/obj/structure/bed/roller/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	if(has_gravity())
		playsound(src, 'sound/effects/roll.ogg', 100, TRUE)


/obj/structure/bed/roller/post_unbuckle_mob(mob/living/M)
	set_density(FALSE)
	icon_state = "down"
	//Set them back down to the normal lying position
	M.pixel_y = M.base_pixel_y + M.body_position_pixel_y_offset


/obj/item/roller
	name = "каталка"
	desc = "Сборная кровать для транспортировки людей."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "folded"
	w_class = WEIGHT_CLASS_NORMAL // No more excuses, stop getting blood everywhere

/obj/item/roller/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/roller/robo))
		var/obj/item/roller/robo/R = I
		if(R.loaded)
			to_chat(user, span_warning("[capitalize(R.name)] уже имеет в запасе каталку!"))
			return
		user.visible_message(span_notice("[user] забирает [src].") , span_notice("Загружаю [src] в [R]."))
		R.loaded = new/obj/structure/bed/roller(R)
		qdel(src) //"Load"
		return
	else
		return ..()

/obj/item/roller/attack_self(mob/user)
	deploy_roller(user, user.loc)

/obj/item/roller/afterattack(obj/target, mob/user , proximity)
	. = ..()
	if(!proximity)
		return
	if(isopenturf(target))
		deploy_roller(user, target)

/obj/item/roller/proc/deploy_roller(mob/user, atom/location)
	var/obj/structure/bed/roller/R = new /obj/structure/bed/roller(location)
	R.add_fingerprint(user)
	qdel(src)

/obj/item/roller/robo //ROLLER ROBO DA!
	name = "каталкодок"
	desc = "Сборная кровать для транспортировки людей. Держите при её при себе всегда."
	var/obj/structure/bed/roller/loaded = null

/obj/item/roller/robo/Initialize(mapload)
	. = ..()
	loaded = new(src)

/obj/item/roller/robo/examine(mob/user)
	. = ..()
	. += "<hr>Док [loaded ? "загружен" : "пуст"]."

/obj/item/roller/robo/deploy_roller(mob/user, atom/location)
	if(loaded)
		loaded.forceMove(location)
		user.visible_message(span_notice("[user] выдавливает [loaded].") , span_notice("Выдавливаю [loaded]."))
		loaded = null
	else
		to_chat(user, span_warning("Док пустой!"))

//Dog bed

/obj/structure/bed/dogbed
	name = "собачья кровать"
	icon_state = "dogbed"
	desc = "Удобная на вид кровать для собаки. Можно даже пристегнуть своего питомца на случай, если гравитация отключится."
	anchored = FALSE
	buildstacktype = /obj/item/stack/sheet/mineral/wood
	buildstackamount = 10
	var/owned = FALSE

/obj/structure/bed/dogbed/ian
	desc = "Выглядит удобной!"
	name = "кроватка Яна"
	anchored = TRUE

/obj/structure/bed/dogbed/cayenne
	desc = "Выглядит как-то... рыбно."
	name = "кровать Кайенны"
	anchored = TRUE

/obj/structure/bed/dogbed/lia
	desc = "Выглядит как-то... рыбно."
	name = "кровать Лии"
	anchored = TRUE

/obj/structure/bed/dogbed/renault
	desc = "Выглядит удобно. Лисий человек нуждается в лисичке."
	name = "кровать Рено"
	anchored = TRUE

/obj/structure/bed/dogbed/mcgriff
	desc = "Кровать МакГрифа, потому что даже борцам с преступностью иногда нужно вздремнуть."
	name = "кровать МакГрифа"

/obj/structure/bed/dogbed/runtime
	desc = "Удобная кошачья кровать. Можно даже пристегнуть своего питомца на случай, если гравитация отключится."
	name = "Кровать Рантайма"
	anchored = TRUE

///Used to set the owner of a dogbed, returns FALSE if called on an owned bed or an invalid one, TRUE if the possesion succeeds
/obj/structure/bed/dogbed/proc/update_owner(mob/living/M)
	if(owned || type != /obj/structure/bed/dogbed) //Only marked beds work, this is hacky but I'm a hacky man
		return FALSE //Failed
	owned = TRUE
	name = "кровать [M]"
	desc = "Выглядит комфортно."
	return TRUE //Let any callers know that this bed is ours now

/obj/structure/bed/dogbed/buckle_mob(mob/living/M, force, check_loc)
	. = ..()
	update_owner(M)

/obj/structure/bed/alien
	name = "отдыхалка"
	desc = "Похоже на штуки с Земли. Могут ли инопланетяне красть наши технологии?"
	icon_state = "abed"


/obj/structure/bed/maint
	name = "грязный матрас"
	desc = "Старый потертый матрас. Вы стараетесь не думать о том, что может быть причиной этих пятен."
	icon_state = "dirty_mattress"

/obj/structure/bed/maint/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_MOLD, CELL_VIRUS_TABLE_GENERIC, rand(2,4), 25)

//Double Beds, for luxurious sleeping, i.e. the captain and maybe heads- if people use this for ERP, send them to skyrat
/obj/structure/bed/double
	name = "двухспальная кровать"
	desc = "Роскошная двуспальная кровать для тех, кто слишком важен для маленьких снов."
	icon_state = "bed_double"
	buildstackamount = 4
	max_buckled_mobs = 2
	///The mob who buckled to this bed second, to avoid other mobs getting pixel-shifted before he unbuckles.
	var/mob/living/goldilocks

/obj/structure/bed/double/post_buckle_mob(mob/living/target)
	if(buckled_mobs.len > 1 && !goldilocks) //Push the second buckled mob a bit higher from the normal lying position
		target.pixel_y = target.base_pixel_y + 6
		goldilocks = target

/obj/structure/bed/double/post_unbuckle_mob(mob/living/target)
	target.pixel_y = target.base_pixel_y + target.body_position_pixel_y_offset
	if(target == goldilocks)
		goldilocks = null

