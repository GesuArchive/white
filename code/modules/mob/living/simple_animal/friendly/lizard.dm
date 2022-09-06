/mob/living/simple_animal/hostile/lizard
	name = "Lizard"
	desc = "A cute tiny lizard."
	icon_state = "lizard"
	icon_living = "lizard"
	icon_dead = "lizard_dead"
	speak_emote = list("шипит")
	health = 5
	maxHealth = 5
	faction = list("Lizard")
	attack_verb_continuous = "кусает"
	attack_verb_simple = "кусает"
	melee_damage_lower = 1
	melee_damage_upper = 2
	response_help_continuous = "гладит"
	response_help_simple = "гладит"
	response_disarm_continuous = "прогоняет"
	response_disarm_simple = "прогоняет"
	response_harm_continuous = "давит"
	response_harm_simple = "давит"
	density = FALSE
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	mob_biotypes = MOB_ORGANIC|MOB_BEAST|MOB_REPTILE
	gold_core_spawnable = FRIENDLY_SPAWN
	obj_damage = 0
	environment_smash = ENVIRONMENT_SMASH_NONE
	var/static/list/edibles = typecacheof(list(/mob/living/simple_animal/butterfly, /mob/living/simple_animal/hostile/cockroach)) //list of atoms, however turfs won't affect AI, but will affect consumption.
	pet_bonus = TRUE
	pet_bonus_emote = "sticks its tongue out contentedly!"

/mob/living/simple_animal/hostile/lizard/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_VENTCRAWLER_ALWAYS, INNATE_TRAIT)

/mob/living/simple_animal/hostile/lizard/CanAttack(atom/the_target)//Can we actually attack a possible target?
	if(see_invisible < the_target.invisibility)//Target's invisible to us, forget it
		return FALSE
	if(is_type_in_typecache(the_target,edibles))
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/lizard/AttackingTarget()
	if(is_type_in_typecache(target,edibles)) //Makes sure player lizards only consume edibles.
		visible_message(span_notice("[name] consumes [target] in a single gulp.") , span_notice("You consume [target] in a single gulp."))
		QDEL_NULL(target) //Nom
		adjustBruteLoss(-2)
		return TRUE
	else
		return ..()

/mob/living/simple_animal/hostile/lizard/space
	name = "Space Lizard"
	desc = "A cute tiny lizard with a tiny space helmet."
	icon_state = "lizard_space"
	icon_living = "lizard_space"
	unsuitable_atmos_damage = 0
	minbodytemp = TCMB
	maxbodytemp = T0C + 40

/mob/living/simple_animal/hostile/lizard/wags_his_tail
	name = "Wags-His-Tail"
	desc = "The janitorial department's trusty pet lizard."
