/obj/item/mop
	desc = "Мир \"janitalia\" не был бы полным без швабры."
	name = "швабра"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mop"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	force = 8
	throwforce = 10
	throw_speed = 3
	throw_range = 7
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb_continuous = list("моет", "лупит", "бьёт", "ударяет")
	attack_verb_simple = list("моет", "лупит", "бьёт", "ударяет")
	resistance_flags = FLAMMABLE
	var/mopcount = 0
	var/mopcap = 15
	var/mopspeed = 15
	force_string = "крепкая... против микробов"
	var/insertable = TRUE

/obj/item/mop/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cleaner, mopspeed, pre_clean_callback=CALLBACK(src, .proc/should_clean), on_cleaned_callback=CALLBACK(src, .proc/apply_reagents))
	create_reagents(mopcap)
	GLOB.janitor_devices += src

/obj/item/mop/Destroy(force)
	GLOB.janitor_devices -= src
	return ..()

///Checks whether or not we should clean.
/obj/item/mop/proc/should_clean(datum/cleaning_source, atom/atom_to_clean, mob/living/cleaner)
	if(istype(atom_to_clean, /obj/item/reagent_containers/glass/bucket) || istype(atom_to_clean, /obj/structure/janitorialcart))
		return DO_NOT_CLEAN
	if(reagents.total_volume < 0.1)
		to_chat(cleaner, span_warning("Швабра сухая"))
		return DO_NOT_CLEAN
	return reagents.has_chemical_flag(REAGENT_CLEANS, 1)

/**
 * Applies reagents to the cleaned floor and removes them from the mop.
 *
 * Arguments
 * * cleaning_source the source of the cleaning
 * * cleaned_turf the turf that is being cleaned
 * * cleaner the mob that is doing the cleaning
 */
/obj/item/mop/proc/apply_reagents(datum/cleaning_source, turf/cleaned_turf, mob/living/cleaner)
	reagents.expose(cleaned_turf, TOUCH, 10) //Needed for proper floor wetting.
	var/val2remove = 1
	if(cleaner?.mind)
		val2remove = round(cleaner.mind.get_skill_modifier(/datum/skill/cleaning, SKILL_SPEED_MODIFIER), 0.1)
	reagents.remove_any(val2remove)			//reaction() doesn't use up the reagents

/obj/effect/attackby(obj/item/weapon, mob/user, params)
	if(SEND_SIGNAL(weapon, COMSIG_ITEM_ATTACK_EFFECT, src, user, params) & COMPONENT_NO_AFTERATTACK)
		return TRUE

	if(istype(weapon, /obj/item/mop) || istype(weapon, /obj/item/soap))
		return
	else
		return ..()


/obj/item/mop/proc/janicart_insert(mob/user, obj/structure/janitorialcart/J)
	if(insertable)
		J.put_in_cart(src, user)
		J.mymop=src
		J.update_icon()
	else
		to_chat(user, span_warning("Эта штука не помещается у меня в [J.name]."))
		return

/obj/item/mop/cyborg
	insertable = FALSE

/obj/item/mop/advanced
	name = "продвинутая швабра"
	desc = "Самый передовой инструмент в арсенале уборщика, в комплекте с влагоуловителем для смачивания! Просто представьте сколько размозженных голов и кровавых луж, вы сможете ей убрать!"
	mopcap = 10
	icon_state = "advmop"
	inhand_icon_state = "mop"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	force = 12
	throwforce = 14
	throw_range = 4
	mopspeed = 8
	var/refill_enabled = TRUE //Self-refill toggle for when a janitor decides to mop with something other than water.
	/// Amount of reagent to refill per second
	var/refill_rate = 0.5
	var/refill_reagent = /datum/reagent/water //Determins what reagent to use for refilling, just in case someone wanted to make a HOLY MOP OF PURGING

/obj/item/mop/advanced/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/item/mop/advanced/attack_self(mob/user)
	refill_enabled = !refill_enabled
	if(refill_enabled)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj,src)
	to_chat(user, span_notice("Устанавливаю переключатель конденсатора в положение '[refill_enabled ? "ВКЛ" : "ВЫКЛ"]'."))
	playsound(user, 'sound/machines/click.ogg', 30, TRUE)

/obj/item/mop/advanced/process(delta_time)
	var/amadd = min(mopcap - reagents.total_volume, refill_rate * delta_time)
	if(amadd > 0)
		reagents.add_reagent(refill_reagent, amadd)

/obj/item/mop/advanced/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'>Переключатель конденсатора сейчас в положении <b>[refill_enabled ? "ВКЛ" : "ВЫКЛ"]</b>.</span>"

/obj/item/mop/advanced/Destroy()
	if(refill_enabled)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/mop/advanced/cyborg
	insertable = FALSE
