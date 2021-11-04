//==================================//
// !       Integration Cog       ! //
//==================================//

/datum/clockcult/scripture/integration_cog
	name = "Интеграционная шестерня"
	desc = "Создает интеграционную шестерню, которую можно вставлять в электрощитки для получения энергии и разблокировки священных писаний."
	tip = "Установите интеграционные шестерни в электрощитки, чтобы активизировать секту и открыть новые священные писания."
	button_icon_state = "Integration Cog"
	power_cost = 0
	invokation_time = 10
	invokation_text = list("Тик-так Дви'Гатель...")
	category = SPELLTYPE_SERVITUDE

/datum/clockcult/scripture/integration_cog/invoke_success()
	var/obj/item/clockwork/integration_cog/IC = new()
	if(invoker.put_in_hands(IC, TRUE))
		to_chat(invoker, span_brass("Вызываю интеграционную шестерню!"))
		playsound(src, 'sound/machines/click.ogg', 50)
	else
		to_chat(invoker, span_brass("У меня должна быть свободна неактивная рука, чтобы вызвать интеграционную шестерню!"))
		return FALSE
