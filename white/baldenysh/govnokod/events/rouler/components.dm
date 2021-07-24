/datum/component/zombie_weapon //приколы из зомбирук чтоб зомби с разными типами оружия (армблейды, тентакли) могли инфицировать и кушать
	var/list/obj/item/organ/zombie_infection/possible_tumors = list( //хз мб в дефайн переделать, но пока так будет для дебага
		/obj/item/organ/zombie_infection
	)

/datum/component/zombie_weapon/Initialize()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_ITEM_AFTERATTACK, .proc/on_afterattack)

/datum/component/zombie_weapon/proc/on_afterattack(target, user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(isliving(target))
		if(ishuman(target))
			infect(target)
		else
			feast(target, user)

/datum/component/zombie_weapon/proc/infect(mob/living/carbon/target)
	if(!istype(target))
		return
	CHECK_DNA_AND_SPECIES(target)
	if(NOZOMBIE in target.dna.species.species_traits)
		return
	var/obj/item/organ/zombie_infection/infection
	infection = target.getorganslot(ORGAN_SLOT_ZOMBIE)
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
