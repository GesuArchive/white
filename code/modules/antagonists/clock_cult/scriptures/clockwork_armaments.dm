//==================================//
// !           Armaments          ! //
//==================================//
/datum/clockcult/scripture/clockwork_armaments
	name = "Механическое оружие"
	desc = "Призывает механические доспехи и оружие, чтобы быть готовыми к битве."
	tip = "Призывает механические доспехи и оружие, чтобы быть готовыми к битве."
	button_icon_state = "clockwork_armor"
	power_cost = 150
	invokation_time = 20
	invokation_text = list("Через мужество и надежду...", "мы защитим тебя!")
	category = SPELLTYPE_PRESERVATION
	cogs_required = 0

/datum/clockcult/scripture/clockwork_armaments/invoke_success()
	var/mob/living/M = invoker
	var/choice = input(M,"Какое оружие мы выберем?", "Механическое оружие") as anything in list("Копьё", "Молот", "Меч", "Лук")
	var/datum/antagonist/servant_of_ratvar/servant = is_servant_of_ratvar(M)
	if(!servant)
		return FALSE
	//Equip mob with gamer gear
	var/static/datum/outfit/clockcult/armaments/armaments_spear = new
	var/static/datum/outfit/clockcult/armaments/hammer/armaments_hammer = new
	var/static/datum/outfit/clockcult/armaments/sword/armaments_sword = new
	var/static/datum/outfit/clockcult/armaments/bow/armaments_bow = new
	switch(choice)
		if("Копьё")
			armaments_spear.equip(M)
		if("Молот")
			armaments_hammer.equip(M)
		if("Меч")
			armaments_sword.equip(M)
		if("Лук")
			armaments_bow.equip(M)
