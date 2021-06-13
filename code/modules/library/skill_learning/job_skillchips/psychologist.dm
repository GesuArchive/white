/obj/item/skillchip/job/psychology
	name = "HYPERG1G4 skillchip"
	desc = "Learn to bend the abyss to your will."
	auto_traits = list(TRAIT_SUPERMATTER_SOOTHER, TRAIT_SUPERMATTER_MADNESS_IMMUNE)
	skill_name = "Supermatter Cognition Theory"
	skill_description = "Understand the correct mental patterns to keep in mind around matter in a hyperfractal state, causing immunity to visions and making the matter in question \"calmer\"."
	skill_icon = "spa"
	activate_message = "<span class='notice'>You start thinking in patterns that will render you immune to visions from, and act as a calming influence for, matter in a hyperfractal state.</span>"
	deactivate_message = "<span class='notice'>Your thoughts become more disordered and jumbled. You are no longer immune to the abyss.</span>"

	var/datum/action/item_action/cure_ptsr/ptsr_cure

/obj/item/skillchip/job/psychology/Initialize(mapload, is_removable = FALSE)
	. = ..()
	ptsr_cure = new(src)

/obj/item/skillchip/job/psychology/Destroy()
	QDEL_NULL(ptsr_cure)
	return ..()

/datum/action/item_action/cure_ptsr
	name = "Вылечить ПТСР"
	button_icon_state = "hand"

/datum/action/item_action/cure_ptsr/Trigger()
	select_person(owner)
	return TRUE

/datum/action/item_action/cure_ptsr/proc/select_person(mob/user)
	var/mob/living/carbon/human/picked_human
	picked_human = input(user, "Лечение ПТСР", "Это будет стоить тебе всего 100 метакэша. Убедись, что цель отработала их для тебя сполна, перед лечением.") as null|mob in view(4, user)
	if(!picked_human)
		to_chat(user, "<span class='notice'>Никого не выбрали.</span>")
		return
	if(picked_human.stat != CONSCIOUS)
		to_chat(user, "<span class='notice'>[picked_human] не сможет вылечиться в таком состоянии.</span>")
		return
	if(!picked_human.has_trauma_type(resilience = TRAUMA_RESILIENCE_PSYCHONLY))
		to_chat(user, "<span class='notice'>У [picked_human] нет ПТСР.</span>")
		return
	var/area/A = get_area(picked_human)
	if(!istype(A, /area/medical/psychology))
		to_chat(user, "<span class='notice'>[picked_human] должен быть в моём кабинете.</span>")
		return
	inc_metabalance(user, -100, reason="Лечение выполнено успешно!")
	picked_human.cure_all_traumas(TRAUMA_RESILIENCE_PSYCHONLY)
