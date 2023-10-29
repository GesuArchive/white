/datum/action/item_action/ninjastatus
	check_flags = NONE
	name = "Считывание статуса"
	desc = "Даёт подробную информацию о вашем текущем статусе."
	button_icon_state = "health"
	button_icon = 'icons/obj/device.dmi'

/**
 * Proc called to put a status readout to the ninja in chat.
 *
 * Called put some information about the ninja's current status into chat.
 * This information used to be displayed constantly on the status tab screen
 * when the suit was on, but was turned into this as to remove the code from
 * human.dm
 */
/obj/item/clothing/suit/space/space_ninja/proc/ninjastatus()
	var/mob/living/carbon/human/ninja = affecting
	var/list/info_list = list()
	info_list += "<span class='info'>Статус SpiderOS: [s_initialized ? "Initialized" : "Disabled"]</span>\n"
	info_list += "<span class='info'>Текущее время: [station_time_timestamp()]</span>\n"
	//Ninja status
	info_list += "<span class='info'>Отпечатки пальцев: [md5(ninja.dna.unique_identity)]</span>\n"
	info_list += "<span class='info'>Уникальная идентичность: [ninja.dna.unique_enzymes]</span>\n"
	info_list += "<span class='info'>Общий статус: [ninja.stat > 1 ? "dead" : "[ninja.health]% healthy"]</span>\n"
	info_list += "<span class='info'>Статус питания: [ninja.nutrition]</span>\n"
	info_list += "<span class='info'>Потеря кислорода: [ninja.getOxyLoss()]</span>\n"
	info_list += "<span class='info'>Уровни токсинов: [ninja.getToxLoss()]</span>\n"
	info_list += "<span class='info'>Тяжесть ожога: [ninja.getFireLoss()]</span>\n"
	info_list += "<span class='info'>Величина физического урона: [ninja.getBruteLoss()]</span>\n"
	info_list += "<span class='info'>Уровни радиации: [ninja.radiation] rad</span>\n"
	info_list += "<span class='info'>Температура тела: [ninja.bodytemperature-T0C] degrees C ([ninja.bodytemperature*1.8-459.67] degrees F)</span>\n"

	//Diseases
	if(length(ninja.diseases))
		info_list += "Viruses:"
		for(var/datum/disease/ninja_disease in ninja.diseases)
			info_list += "<span class='info'>* [ninja_disease.name], Тип: [ninja_disease.spread_text], Стадия: [ninja_disease.stage]/[ninja_disease.max_stages], Возможное лекарство: [ninja_disease.cure_text]</span>\n"

	to_chat(ninja, "[info_list.Join()]")
