//spider webs
/datum/mutation/human/webbing
	name = "Паутиновые железы"
	desc = "Позволяет носителю создавать паутину и беспрепятственно двигаться через нее."
	quality = POSITIVE
	text_gain_indication = span_notice("На запястьях появились странные железы, и из них тянется тонкая белесая нить.")
	instability = 15
	power_path = /datum/action/cooldown/spell/lay_genetic_web

/datum/mutation/human/webbing/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	ADD_TRAIT(owner, TRAIT_WEB_WEAVER, GENETIC_MUTATION)

/datum/mutation/human/webbing/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	REMOVE_TRAIT(owner, TRAIT_WEB_WEAVER, GENETIC_MUTATION)

// In the future this could be unified with the spider's web action
/datum/action/cooldown/spell/lay_genetic_web
	name = "Создание паутины"
	desc = "Хорошее средство для самозащиты, замедляет потенциальных недоброжелателей, но не препятствует вашему движению."
	button_icon = 'icons/mob/actions/actions_genetic.dmi'
	button_icon_state = "lay_web"

	cooldown_time = 4 SECONDS //the same time to lay a web
	spell_requirements = NONE

	/// How long it takes to lay a web
	var/webbing_time = 4 SECONDS
	/// The path of web that we create
	var/web_path = /obj/structure/spider/stickyweb/genetic

/datum/action/cooldown/spell/lay_genetic_web/cast(atom/cast_on)
	var/turf/web_spot = cast_on.loc
	if(!isturf(web_spot) || (locate(web_path) in web_spot))
		to_chat(cast_on, span_warning("Здесь сплести паутину не выйдет!"))
		reset_spell_cooldown()
		return FALSE

	cast_on.visible_message(
		span_notice("[cast_on] начинает выделять липкую субстанцию из своих запястий."),
		span_notice("Начинаю плетение паутины."),
	)

	if(!do_after(cast_on, webbing_time, target = web_spot))
		to_chat(cast_on, span_warning("Мне помешали!"))
		return

	new web_path(web_spot, cast_on)
	return ..()
