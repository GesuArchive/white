/datum/surgery/plastic_surgery
	name = "Пластическая хирургия"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/retract_skin, /datum/surgery_step/reshape_face, /datum/surgery_step/close)
	possible_locs = list(BODY_ZONE_HEAD)

//reshape_face
/datum/surgery_step/reshape_face
	name = "изменить лицо"
	implements = list(TOOL_SCALPEL = 100, /obj/item/kitchen/knife = 50, TOOL_WIRECUTTER = 35)
	time = 64

/datum/surgery_step/reshape_face/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message(span_notice("[user] начинает менять внешность [skloname(target.name, RODITELNI, target.gender)].") , span_notice("Начинаю менять внешность [skloname(target.name, RODITELNI, target.gender)]..."))
	display_results(user, target, span_notice("Начинаю менять внешность [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] начинает менять внешность [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] делает надрез на лице [skloname(target.name, RODITELNI, target.gender)]."))
	display_pain(target, "Лицо горит от множественных порезов!")

/datum/surgery_step/reshape_face/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(HAS_TRAIT_FROM(target, TRAIT_DISFIGURED, TRAIT_GENERIC))
		REMOVE_TRAIT(target, TRAIT_DISFIGURED, TRAIT_GENERIC)
		display_results(user, target, span_notice("Успешно изменил внешность [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] успешно изменил внешность [skloname(target.name, RODITELNI, target.gender)]!") ,
			span_notice("[user] завершил операцию на лице [skloname(target.name, RODITELNI, target.gender)]."))
		display_pain(target, "Все лицо щиплет!")
	else
		var/list/names = list()
		if(!isabductor(user))
			for(var/i in 1 to 10)
				names += target.dna.species.random_name(target.gender, TRUE)
		else
			for(var/_i in 1 to 9)
				names += "Субъект [target.gender == MALE ? "i" : "o"]-[pick("a", "b", "c", "d", "e")]-[rand(10000, 99999)]"
			names += target.dna.species.random_name(target.gender, TRUE) //give one normal name in case they want to do regular plastic surgery
		var/chosen_name = tgui_input_list(user, "Выберите новое имя.", "Plastic Surgery", names)
		if(!chosen_name)
			return
		var/oldname = target.real_name
		target.real_name = chosen_name
		var/newname = target.real_name	//something about how the code handles names required that I use this instead of target.real_name
		display_results(user, target, span_notice("Лицо [oldname] полностью изменено, и [target.ru_who()] новое имя [newname].") ,
			span_notice("[user] изменяет внешность [oldname], и [target.ru_who()] новое имя [newname]!") ,
			span_notice("[user] завершает операцию на лице [skloname(target.name, RODITELNI, target.gender)]."))
		display_pain(target, "Я сегодня не такой как вчера!")
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.sec_hud_set_ID()
	return ..()

/datum/surgery_step/reshape_face/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_warning("[gvorno(TRUE)], но я облажался, изуродовав внешность [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_notice("[user] облажался, изуродовав внешность [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_notice("[user] завершил операцию на лице [skloname(target.name, RODITELNI, target.gender)]."))
	display_pain(target, "Мое лицо! Мое прекрастное лицо! Оно обезображено!")
	ADD_TRAIT(target, TRAIT_DISFIGURED, TRAIT_GENERIC)
	return FALSE
