/datum/ai_controller/tdroid/core
	continue_processing_when_client = TRUE

/obj/item/organ/tactical_core
	name = "тактическое ядро"
	desc = "Тактическое ядро андроида неизвестной марки. Используйте встроенный ДНК-сканер для установки коммандира."
	icon = 'white/baldenysh/icons/obj/organs.dmi'
	icon_state = "tactical_core"
	zone = BODY_ZONE_HEAD
	slot = "tactical_core"
	organ_flags = ORGAN_SYNTHETIC
	var/emp_vulnerability = 20

	var/AI_type = /datum/ai_controller/tdroid/core
	var/datum/ai_controller/tdroid/core/AI
	var/mob/living/commander_mob

/obj/item/organ/tactical_core/Insert(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()
	if(AI)
		AI.PossessPawn(M)
	else
		M.ai_controller = new AI_type(M)
		AI = M.ai_controller
	AI.RegisterCommander(commander_mob)

/obj/item/organ/tactical_core/Remove(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()
	AI.UnpossessPawn()

/obj/item/organ/tactical_core/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(prob(emp_vulnerability/severity))
		organ_flags |= ORGAN_SYNTHETIC_EMP
		if(AI && AI.blackboard[BB_TDROID_COMMANDER])
			AI.UnregisterCommander()

/obj/item/organ/tactical_core/examine(mob/user)
	. = ..()
	if(commander_mob)
		. += span_notice("\nКоммандир: [commander_mob.name]") //ваще надо на строчку днк заменить но пока похуй

/obj/item/organ/tactical_core/attack_self(mob/user)
	. = ..()
	if(isliving(user))
		commander_mob = user
