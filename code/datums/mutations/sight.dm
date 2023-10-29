//Nearsightedness restricts your vision by several tiles.
/datum/mutation/human/nearsight
	name = "Близорукость"
	desc = "Обладатель этой мутации имеет плохое зрение."
	quality = MINOR_NEGATIVE
	text_gain_indication = span_danger("Я стал видеть намного хуже!")

/datum/mutation/human/nearsight/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	owner.become_nearsighted(GENETIC_MUTATION)

/datum/mutation/human/nearsight/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	owner.cure_nearsighted(GENETIC_MUTATION)


///Blind makes you blind. Who knew?
/datum/mutation/human/blind
	name = "Слепота"
	desc = "Носитель этой мутации слеп как крот."
	quality = NEGATIVE
	text_gain_indication = span_danger("Я ничерта не вижу!")

/datum/mutation/human/blind/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	owner.become_blind(GENETIC_MUTATION)

/datum/mutation/human/blind/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	owner.cure_blind(GENETIC_MUTATION)

///Thermal Vision lets you see mobs through walls
/datum/mutation/human/thermal
	name = "Термосенсорное восприятие"
	desc = "Позволяет носителю чувствовать тепловые сигнатуры живых объектов даже сквозь многометровые стальные перегородки."
	quality = POSITIVE
	difficulty = 18
	text_gain_indication = span_notice("Мир окрасился всеми оттенками оранжевого и кажется даже стены не могут удержать эти теплые краски...")
	text_lose_indication = span_notice("Мир снова сузился до размеров этой комнаты, он снова стал холодным и пустым...")
	instability = 25
	var/visionflag = TRAIT_THERMAL_VISION

/datum/mutation/human/thermal/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return

	ADD_TRAIT(owner, visionflag, GENETIC_MUTATION)
	owner.update_sight()

/datum/mutation/human/thermal/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, visionflag, GENETIC_MUTATION)
	owner.update_sight()

///X-ray Vision lets you see through walls.
/datum/mutation/human/thermal/x_ray
	name = "Рентгеновское зрение"
	desc = "Редчайшая мутация, возможно даже навсегда утеренная для будущих поколений, позволяет в прямом смысле видеть сквозь стены!" //actual x-ray would mean you'd constantly be blasting rads, wich might be fun for later //hmb
	text_gain_indication = span_notice("Стены внезапно исчезли!")
	instability = 35
	locked = TRUE
	visionflag = TRAIT_XRAY_VISION

///Laser Eyes lets you shoot lasers from your eyes!
/datum/mutation/human/laser_eyes
	name = "Глаза-Лазеры"
	desc = "Перестраивает хрусталик глаза позволяя аккумулировать свет и выстреливать им в цель в виде сконцентрированного лазерного луча."
	quality = POSITIVE
	locked = TRUE
	difficulty = 16
	text_gain_indication = span_notice("Я чувствую как мои глаза накапливают свет...")
	layer_used = FRONT_MUTATIONS_LAYER
	limb_req = BODY_ZONE_HEAD

/datum/mutation/human/laser_eyes/New(class_ = MUT_OTHER, timer, datum/mutation/human/copymut)
	..()
	if(!(type in visual_indicators))
		visual_indicators[type] = list(mutable_appearance('icons/effects/genetics.dmi', "lasereyes", -FRONT_MUTATIONS_LAYER))

/datum/mutation/human/laser_eyes/on_acquiring(mob/living/carbon/human/H)
	. = ..()
	if(.)
		return
	RegisterSignal(H, COMSIG_MOB_ATTACK_RANGED, PROC_REF(on_ranged_attack))

/datum/mutation/human/laser_eyes/on_losing(mob/living/carbon/human/H)
	. = ..()
	if(.)
		return
	UnregisterSignal(H, COMSIG_MOB_ATTACK_RANGED)

/datum/mutation/human/laser_eyes/get_visual_indicator()
	return visual_indicators[type][1]

///Triggers on COMSIG_MOB_ATTACK_RANGED. Does the projectile shooting.
/datum/mutation/human/laser_eyes/proc/on_ranged_attack(mob/living/carbon/human/source, atom/target, modifiers)
	SIGNAL_HANDLER

	if(source.a_intent != INTENT_HARM)
		return
	to_chat(source, span_warning("Я стреляю лазером прямо из своих глаз!"))
	source.changeNext_move(CLICK_CD_RANGE)
	source.newtonian_move(get_dir(target, source))
	var/obj/projectile/beam/laser_eyes/LE = new(source.loc)
	LE.firer = source
	LE.def_zone = ran_zone(source.zone_selected)
	LE.preparePixelProjectile(target, source, modifiers)
	INVOKE_ASYNC(LE, TYPE_PROC_REF(/obj/projectile, fire))
	playsound(source, 'sound/weapons/taser2.ogg', 75, TRUE)
	source.adjust_nutrition(-1)
	source.hydration = source.hydration - 1
	source.blood_volume = source.blood_volume - 0.25

///Projectile type used by laser eyes
/obj/projectile/beam/laser_eyes
	name = "луч"
	icon = 'icons/effects/genetics.dmi'
	icon_state = "eyelasers"
