/obj/item/integrated_circuit_printer/upgraded/prog
	name = "Advanced ICP"
	icon_state = "adv_icp"
	w_class = WEIGHT_CLASS_NORMAL
/*
/datum/quirk/programmer
	name = "Программист"
	desc = "Прибытие на станцию в носках программиста будет давать вам специальный принтер интегральных схем."
	value = 1
	mob_trait = "programmer"
	gain_text = span_notice("Вы знаете всё о программировании и кроссдресинге.")
	lose_text = span_danger("Чувствую себя нормальным.")
	medical_record_text = "Пациент утверждает, что если одеваться, как японская школьница, то его навыки программирования улучшатся."

/datum/quirk/programmer/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	if(H.socks == "Stockings (Programmer)" && H.jumpsuit_style == "Jumpskirt")
		var/obj/item/integrated_circuit_printer/upgraded/prog/P = new(get_turf(H))
		var/list/slots = list(
			"backpack" = ITEM_SLOT_BACKPACK,
			"hands" = ITEM_SLOT_HANDS,
		)
		H.equip_in_one_of_slots(P, slots, qdel_on_fail = FALSE)
	else
		var/obj/item/integrated_circuit_printer/IC = new(get_turf(H))
		H.put_in_hands(IC)
*/
