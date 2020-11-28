
//make incision
/datum/surgery_step/incise
	name = "сделать надрез"
	implements = list(TOOL_SCALPEL = 100, /obj/item/melee/transforming/energy/sword = 75, /obj/item/kitchen/knife = 65,
		/obj/item/shard = 45, /obj/item = 30) // 30% success with any sharp item.
	time = 16

/datum/surgery_step/incise/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>Начинаю делать надрез на [parse_zone(target_zone)] [target]...</span>",
		"<span class='notice'>[user] начинает делать надрез на [parse_zone(target_zone)] [target]...</span>",
		"<span class='notice'>[user] начинает делать надрез на [parse_zone(target_zone)] [target].</span>")

/datum/surgery_step/incise/tool_check(mob/user, obj/item/tool)
	if(implement_type == /obj/item && !tool.get_sharpness())
		return FALSE

	return TRUE

/datum/surgery_step/incise/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if ishuman(target)
		var/mob/living/carbon/human/H = target
		if (!(NOBLOOD in H.dna.species.species_traits))
			display_results(user, target, "<span class='notice'>Кровь течет из надреза [parse_zone(target_zone)] [H].</span>",
				"<span class='notice'>Кровь течет из надреза [parse_zone(target_zone)] [H].</span>",
				"")
			var/obj/item/bodypart/BP = target.get_bodypart(target_zone)
			if(BP)
				BP.generic_bleedstacks += 10
	return ..()

/datum/surgery_step/incise/nobleed/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'><i>Аккуратно</i> надрезаю [parse_zone(target_zone)] [target]...</span>",
		"<span class='notice'>[user] начинает делать <i>аккуратный</i> надрез на [parse_zone(target_zone)] [target].</span>",
		"<span class='notice'>[user] начинает делать <i>аккуратный</i> надрез на [parse_zone(target_zone)] [target].</span>")

//clamp bleeders
/datum/surgery_step/clamp_bleeders
	name = "зажать источник кровотечения"
	implements = list(TOOL_HEMOSTAT = 100, TOOL_WIRECUTTER = 60, /obj/item/stack/package_wrap = 35, /obj/item/stack/cable_coil = 15)
	time = 24

/datum/surgery_step/clamp_bleeders/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>Начинаю зажимать источник кровотечения на [parse_zone(target_zone)] [target]...</span>",
		"<span class='notice'>[user] начинает зажимать источник кровотечения на [parse_zone(target_zone)] [target].</span>",
		"<span class='notice'>[user] начинает зажимать источник кровотечения на [parse_zone(target_zone)] [target].</span>")

/datum/surgery_step/clamp_bleeders/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	if(locate(/datum/surgery_step/saw) in surgery.steps)
		target.heal_bodypart_damage(20,0)
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		var/obj/item/bodypart/BP = H.get_bodypart(target_zone)
		if(BP)
			BP.generic_bleedstacks -= 3
	return ..()

//retract skin
/datum/surgery_step/retract_skin
	name = "оттянуть кожу "
	implements = list(TOOL_RETRACTOR = 100, TOOL_SCREWDRIVER = 45, TOOL_WIRECUTTER = 35, /obj/item/stack/rods = 35)
	time = 24

/datum/surgery_step/retract_skin/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>Начинаю оттягивать кожу на [parse_zone(target_zone)] [target]...</span>",
		"<span class='notice'>[user] начинает оттягивать кожу на [parse_zone(target_zone)] [target].</span>",
		"<span class='notice'>[user] начинает оттягивать кожу на [parse_zone(target_zone)] [target].</span>")



//close incision
/datum/surgery_step/close
	name = "прижечь надрез"
	implements = list(TOOL_CAUTERY = 100, /obj/item/gun/energy/laser = 90, TOOL_WELDER = 70,
		/obj/item = 30) // 30% success with any hot item.
	time = 24

/datum/surgery_step/close/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>Начинаю прижигать надрез на [parse_zone(target_zone)] [target]...</span>",
		"<span class='notice'>[user] начинает прижигать надрез на [parse_zone(target_zone)] [target].</span>",
		"<span class='notice'>[user] начинает прижигать надрез на [parse_zone(target_zone)].</span>")

/datum/surgery_step/close/tool_check(mob/user, obj/item/tool)
	if(implement_type == TOOL_WELDER || implement_type == /obj/item)
		return tool.get_temperature()

	return TRUE

/datum/surgery_step/close/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	if(locate(/datum/surgery_step/saw) in surgery.steps)
		target.heal_bodypart_damage(45,0)
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		var/obj/item/bodypart/BP = H.get_bodypart(target_zone)
		if(BP)
			BP.generic_bleedstacks -= 3
	return ..()



//saw bone
/datum/surgery_step/saw
	name = "пилить кость"
	implements = list(TOOL_SAW = 100,/obj/item/melee/arm_blade = 75,
	/obj/item/fireaxe = 50, /obj/item/hatchet = 35, /obj/item/kitchen/knife/butcher = 25, /obj/item = 20) //20% success (sort of) with any sharp item with a force>=10
	time = 54

/datum/surgery_step/saw/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>Начинаю пилить кость на [parse_zone(target_zone)] [target]...</span>",
		"<span class='notice'>[user] начинает пилить кость на [parse_zone(target_zone)] [target].</span>",
		"<span class='notice'>[user] начинает пилить кость на [parse_zone(target_zone)] [target].</span>")

/datum/surgery_step/saw/tool_check(mob/user, obj/item/tool)
	if(implement_type == /obj/item && !(tool.get_sharpness() && (tool.force >= 10)))
		return FALSE
	return TRUE

/datum/surgery_step/saw/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	target.apply_damage(50, BRUTE, "[target_zone]", wound_bonus=CANT_WOUND)
	display_results(user, target, "<span class='notice'>Я отпилил [parse_zone(target_zone)] [target].</span>",
		"<span class='notice'>[user] отпилил [parse_zone(target_zone)] [target]!</span>",
		"<span class='notice'>[user] отпилил [parse_zone(target_zone)] [target]!</span>")
	return ..()

//drill bone
/datum/surgery_step/drill
	name = "сверлить кость"
	implements = list(TOOL_DRILL = 100, /obj/item/screwdriver/power = 80, /obj/item/pickaxe/drill = 60, TOOL_SCREWDRIVER = 25, /obj/item/kitchen/spoon = 20)
	time = 30

/datum/surgery_step/drill/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>Начинаю сверление кости в [parse_zone(target_zone)] [target]...</span>",
		"<span class='notice'>[user] начинает сверление кости в [parse_zone(target_zone)] [target].</span>",
		"<span class='notice'>[user] начинает сверление кости в [parse_zone(target_zone)] [target].</span>")

/datum/surgery_step/drill/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, "<span class='notice'>Я успешно просверлил кость в [parse_zone(target_zone)] [target].</span>",
		"<span class='notice'>[user] успешно просверлил кость в [parse_zone(target_zone)] [target]!</span>",
		"<span class='notice'>[user] успешно просверлил кость в [parse_zone(target_zone)] [target]!</span>")
	return ..()
