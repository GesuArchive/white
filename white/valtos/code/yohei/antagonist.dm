/datum/antagonist/yohei
	name = "yohei"
	roundend_category = "yohei"
	show_in_antagpanel = FALSE
	prevent_roundtype_conversion = FALSE
	var/datum/mind/protected_guy
	greentext_reward = 100

/datum/antagonist/yohei/proc/forge_objectives()
	var/datum/objective/protect/protect_objective = new /datum/objective/protect
	protect_objective.owner = owner
	protect_objective.target = protected_guy
	if(!ishuman(protected_guy.current))
		protect_objective.human_check = FALSE
	protect_objective.explanation_text = "Защитить [protected_guy.name], моего нанимателя."
	objectives += protect_objective

/datum/antagonist/yohei/on_gain()
	forge_objectives()
	if(GLOB.yohei_main_controller)
		var/obj/lab_monitor/yohei/LM = GLOB.yohei_main_controller
		var/mob/living/yohei = owner.current
		LM.remove_from_action_guys(yohei)
	. = ..()

/datum/antagonist/yohei/greet()
	to_chat(owner, span_warning  ("<B>Базовый контракт заморожен. Согласно протоколу 'WhiteHat'[protected_guy.name] теперь мой начальник и желательно защитить его от смерти.</B>"))


//Squashed up a bit
/datum/antagonist/yohei/roundend_report()
	var/objectives_complete = TRUE
	if(objectives.len)
		for(var/datum/objective/objective in objectives)
			if(!objective.check_completion())
				objectives_complete = FALSE
				break

	if(objectives_complete)
		return "<span class='greentext big'>[owner.name] успешно выполняет работу.</span>"
	else
		return "<span class='redtext big'>[owner.name] не смог выполнить обязательства контракта, позор!</span>"

