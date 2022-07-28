
/datum/wound/loss
	name = "Потеря конечности"
	desc = "Ай, мля!!"

	sound_effect = 'sound/effects/dismember.ogg'
	severity = WOUND_SEVERITY_LOSS
	threshold_minimum = WOUND_DISMEMBER_OUTRIGHT_THRESH // not actually used since dismembering is handled differently, but may as well assign it since we got it
	status_effect_type = null
	scar_keyword = "dismember"
	wound_flags = null
	already_scarred = TRUE // We manually assign scars for dismembers through endround missing limbs and aheals

/// Our special proc for our special dismembering, the wounding type only matters for what text we have
/datum/wound/loss/proc/apply_dismember(obj/item/bodypart/dismembered_part, wounding_type=WOUND_SLASH, outright = FALSE, attack_direction)
	if(!istype(dismembered_part) || !dismembered_part.owner || !(dismembered_part.body_zone in viable_zones) || isalien(dismembered_part.owner) || !dismembered_part.can_dismember())
		qdel(src)
		return

	set_victim(dismembered_part.owner)

	if(dismembered_part.body_zone == BODY_ZONE_CHEST)
		occur_text = "была разорвана, внутренние органы вылетают с [prob(35) ? "вкусным" : "неприятным"] звуком!" //[prob(35) ? "вкусно"] жрал?
	else if(outright)
		switch(wounding_type)
			if(WOUND_BLUNT)
				occur_text = "кость была раздроблена, отделяя конечность от тела"
			if(WOUND_SLASH)
				occur_text = "плоть была разрублена, отделяя конечность от тела"
			if(WOUND_PIERCE)
				occur_text = "плоть была раскромсана, отделяя конечность от тела"
			if(WOUND_BURN)
				occur_text = "часть была сожжена, превращая конечность в пыль"
	else
		switch(wounding_type)
			if(WOUND_BLUNT)
				occur_text = "кость была раздроблена, отделяя конечность от тела"
			if(WOUND_SLASH)
				occur_text = "плоть была разрублена, отделяя конечность от тела"
			if(WOUND_PIERCE)
				occur_text = "плоть была раскромсана, отделяя конечность от тела"
			if(WOUND_BURN)
				occur_text = "часть была сожжена, превращая конечность в пыль"

	var/msg = span_smalldanger("Последняя кость удерживающая [ru_parse_zone(dismembered_part.name)] <b>[victim]</b> [occur_text]!")

	victim.visible_message(msg, span_userdanger("Моя последняя кость удерживающая [ru_parse_zone(dismembered_part.name)] [occur_text]!"))

	set_limb(dismembered_part)
	second_wind()
	log_wound(victim, src)
	if(wounding_type != WOUND_BURN && victim.blood_volume)
		victim.spray_blood(attack_direction, severity)
	dismembered_part.dismember(wounding_type == WOUND_BURN ? BURN : BRUTE, TRUE, (wounding_type != WOUND_BLUNT) )
	qdel(src)
