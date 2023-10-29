/datum/component/zombie_weapon //приколы из зомбирук чтоб зомби с разными типами оружия (армблейды, тентакли) могли инфицировать и кушоть
	var/list/obj/item/organ/zombie_infection/possible_tumors = list(
		/obj/item/organ/zombie_infection
	)
	var/infection_chance = 100

/datum/component/zombie_weapon/Initialize(mapload)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_ITEM_AFTERATTACK, PROC_REF(on_afterattack))

/datum/component/zombie_weapon/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ITEM_AFTERATTACK)

/datum/component/zombie_weapon/proc/on_afterattack(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	SIGNAL_HANDLER
	if(!proximity_flag)
		return
	if(isliving(target))
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			if(!H.check_shields(user, source.force, "инфекцию"))
				infect(target)
			return
		else
			feast(target, user)

/datum/component/zombie_weapon/proc/infect(mob/living/carbon/human/target)
	if(!istype(target))
		return
	if(!prob(infection_chance) && target.stat != DEAD)
		return
	CHECK_DNA_AND_SPECIES(target)
	if(NOZOMBIE in target.dna.species.species_traits)
		return
	if(HAS_TRAIT(target, TRAIT_PARASITE_IMMUNE))
		return
	var/obj/item/organ/zombie_infection/infection
	infection = target.get_organ_slot(ORGAN_SLOT_ZOMBIE)
	if(!infection)
		var/tumor_type = pick(possible_tumors)
		infection = new tumor_type()
		infection.Insert(target)

/datum/component/zombie_weapon/proc/feast(mob/living/target, mob/living/carbon/eater)
	if(!istype(target))
		return
	if(target.stat != DEAD)
		return
	var/hp_gained = target.maxHealth
	target.gib()
	eater.adjustBruteLoss(-hp_gained, 0)
	eater.adjustToxLoss(-hp_gained, 0)
	eater.adjustFireLoss(-hp_gained, 0)
	eater.adjustCloneLoss(-hp_gained, 0)
	eater.updatehealth()
	eater.adjustOrganLoss(ORGAN_SLOT_BRAIN, -hp_gained)
	eater.set_nutrition(min(eater.nutrition + hp_gained, NUTRITION_LEVEL_FULL))
