/datum/surgery/advanced/bioware/ligament_reinforcement
	name = "Укрепление связок"
	desc = "Хирургическая процедура, добавляющая защитную ткань и костяную клетку вокруг соединений туловища и конечностей, предотвращая расчленение. \
	Однако, в результате нервные соединения легче оборвать, что ведет к большему шансу вывести из строя конечности при получении урона."
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/incise,
				/datum/surgery_step/incise,
				/datum/surgery_step/reinforce_ligaments,
				/datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_CHEST)
	bioware_target = BIOWARE_LIGAMENTS

/datum/surgery_step/reinforce_ligaments
	name = "укрепление связок"
	accept_hand = TRUE
	time = 125

/datum/surgery_step/reinforce_ligaments/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>Начинаю укреплять связки [target].</span>",
		"<span class='notice'>[user] начал укреплять связки [target].</span>",
		"<span class='notice'>[user] начал работу со связками [target].</span>")

/datum/surgery_step/reinforce_ligaments/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, "<span class='notice'>Укрепил связки [target]!</span>",
		"<span class='notice'>[user] укрепил связки [target]!</span>",
		"<span class='notice'>[user] закончил работу со связками [target].</span>")
	new /datum/bioware/reinforced_ligaments(target)
	return ..()

/datum/bioware/reinforced_ligaments
	name = "Укрепленные связки"
	desc = "Связки и нервные окончания, соединяющие туловище с конечностями, защищены смесью костей и тканей, и их куда сложнее отделить от туловища, но куда проще поранить."
	mod_type = BIOWARE_LIGAMENTS

/datum/bioware/reinforced_ligaments/on_gain()
	..()
	ADD_TRAIT(owner, TRAIT_NODISMEMBER, "reinforced_ligaments")
	ADD_TRAIT(owner, TRAIT_EASYLIMBWOUND, "reinforced_ligaments")

/datum/bioware/reinforced_ligaments/on_lose()
	..()
	REMOVE_TRAIT(owner, TRAIT_NODISMEMBER, "reinforced_ligaments")
	REMOVE_TRAIT(owner, TRAIT_EASYLIMBWOUND, "reinforced_ligaments")
