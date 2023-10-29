//Programs that buff the host in generally passive ways.

/datum/nanite_program/nervous
	name = "Поддержка нервов"
	desc = "Наниты действуют как вторичная нервная система, сокращая время оглушения носителя в два раза."
	use_rate = 1.5
	rogue_types = list(/datum/nanite_program/nerve_decay)

/datum/nanite_program/nervous/enable_passive_effect()
	. = ..()
	if(ishuman(host_mob))
		var/mob/living/carbon/human/H = host_mob
		H.physiology.stun_mod *= 0.5

/datum/nanite_program/nervous/disable_passive_effect()
	. = ..()
	if(ishuman(host_mob))
		var/mob/living/carbon/human/H = host_mob
		H.physiology.stun_mod *= 2

/datum/nanite_program/adrenaline
	name = "Всплеск адреналина"
	desc = "Наниты вызывают всплеск адреналина при активации, вкалывая 3 единицы Экспериментальных стимуляторов, пробуждая носителя и временно ускоряя его, из-за чего он может уронить вещи из рук."
	can_trigger = TRUE
	trigger_cost = 25
	trigger_cooldown = 1200
	rogue_types = list(/datum/nanite_program/toxic, /datum/nanite_program/nerve_decay)

/datum/nanite_program/adrenaline/on_trigger()
	to_chat(host_mob, span_notice("You feel a sudden surge of energy!"))
	host_mob.set_resting(FALSE)
	host_mob.reagents.add_reagent(/datum/reagent/medicine/badstims, 3)

/datum/nanite_program/hardening
	name = "Укрепление кожи"
	desc = "Наниты формируют сеть под кожей носителя, защищая его от пулевых ранений и ранений от холодного оружия. Дает 25 брони от холодного оружия и 20 брони от пуль."
	use_rate = 0.5
	rogue_types = list(/datum/nanite_program/skin_decay)

//TODO on_hit effect that turns skin grey for a moment

/datum/nanite_program/hardening/enable_passive_effect()
	. = ..()
	if(ishuman(host_mob))
		var/mob/living/carbon/human/H = host_mob
		H.physiology.armor.melee += 25
		H.physiology.armor.bullet += 20

/datum/nanite_program/hardening/disable_passive_effect()
	. = ..()
	if(ishuman(host_mob))
		var/mob/living/carbon/human/H = host_mob
		H.physiology.armor.melee -= 25
		H.physiology.armor.bullet -= 20

/datum/nanite_program/refractive
	name = "Отражающая кожа"
	desc = "Наниты формируют мембрану под кожей носителя, уменьшая урон от лазеров и энергетического оружия. Добавляет 25 лазерной и 20 энергетической брони."
	use_rate = 0.50
	rogue_types = list(/datum/nanite_program/skin_decay)

/datum/nanite_program/refractive/enable_passive_effect()
	. = ..()
	if(ishuman(host_mob))
		var/mob/living/carbon/human/H = host_mob
		H.physiology.armor.laser += 25
		H.physiology.armor.energy += 20

/datum/nanite_program/refractive/disable_passive_effect()
	. = ..()
	if(ishuman(host_mob))
		var/mob/living/carbon/human/H = host_mob
		H.physiology.armor.laser -= 25
		H.physiology.armor.energy -= 20

/datum/nanite_program/coagulating
	name = "Ускоренное свертывание"
	desc = "Наниты вызывают быстрое свертывание крови при ранении носителя, невероятно сильно снижая шансы истечь кровью."
	use_rate = 0.20
	rogue_types = list(/datum/nanite_program/suffocating)

/datum/nanite_program/coagulating/enable_passive_effect()
	. = ..()
	if(ishuman(host_mob))
		var/mob/living/carbon/human/H = host_mob
		H.physiology.bleed_mod *= 0.5

/datum/nanite_program/coagulating/disable_passive_effect()
	. = ..()
	if(ishuman(host_mob))
		var/mob/living/carbon/human/H = host_mob
		H.physiology.bleed_mod *= 2

/datum/nanite_program/conductive
	name = "Электропроводимость"
	desc = "Наниты действуют как заземлитель для тока, защищая носителя. Однако удары током повреждают самих нанитов."
	use_rate = 0.20
	program_flags = NANITE_SHOCK_IMMUNE
	rogue_types = list(/datum/nanite_program/nerve_decay)

/datum/nanite_program/conductive/enable_passive_effect()
	. = ..()
	ADD_TRAIT(host_mob, TRAIT_SHOCKIMMUNE, "nanites")

/datum/nanite_program/conductive/disable_passive_effect()
	. = ..()
	REMOVE_TRAIT(host_mob, TRAIT_SHOCKIMMUNE, "nanites")

/datum/nanite_program/mindshield
	name = "Ментальный барьер"
	desc = "Наниты формируют защитную оболочку вокруг мозга носителя, защищая его от аномального влияния, аналогично импланту щита разума."
	use_rate = 0.10
	rogue_types = list(/datum/nanite_program/brain_decay, /datum/nanite_program/brain_misfire)

/datum/nanite_program/mindshield/enable_passive_effect()
	. = ..()
	if(!host_mob.mind.has_antag_datum(/datum/antagonist/rev, TRUE)) //won't work if on a rev, to avoid having implanted revs.
		ADD_TRAIT(host_mob, TRAIT_MINDSHIELD, "nanites")
		host_mob.sec_hud_set_implants()

/datum/nanite_program/mindshield/disable_passive_effect()
	. = ..()
	REMOVE_TRAIT(host_mob, TRAIT_MINDSHIELD, "nanites")
	host_mob.sec_hud_set_implants()
