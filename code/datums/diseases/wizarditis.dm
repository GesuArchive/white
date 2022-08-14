/datum/disease/wizarditis
	name = "Визардитис"
	max_stages = 4
	spread_text = "Воздушное"
	cure_text = "Мэнли Дорф"
	cures = list(/datum/reagent/consumable/ethanol/manly_dorf)
	cure_chance = 100
	agent = "Ринсвиндус Вульгарис"
	viable_mobtypes = list(/mob/living/carbon/human)
	disease_flags = CAN_CARRY|CAN_RESIST|CURABLE
	spreading_modifier = 0.75
	desc = "Некоторые предполагают, что этот вирус является причиной существования Федерации космических волшебников. Пострадавшие субъекты проявляют признаки повреждения мозга, выкрикивают непонятные предложения или полную тарабарщину. На поздних стадиях субъекты иногда выражают чувство внутренней силы и, цитируют, «способность управлять самими силами космоса!» Глоток сильных, мужественных духов обычно возвращает их в нормальное, человеческое состояние."
	severity = DISEASE_SEVERITY_HARMFUL
	required_organs = list(/obj/item/bodypart/head)

/*
BIRUZ BENNAR
SCYAR NILA - teleport
NEC CANTIO - dis techno
EI NATH - shocking grasp
AULIE OXIN FIERA - knock
TARCOL MINTI ZHERI - forcewall
STI KALY - blind
*/

/datum/disease/wizarditis/stage_act(delta_time, times_fired)
	. = ..()
	if(!.)
		return

	switch(stage)
		if(2)
			if(DT_PROB(0.25, delta_time))
				affected_mob.say(pick("Ты не пройдёшь!", "Экспеллиармус!", "Бородой Мерлина!", "Почувствуй мощь Темной стороны!"), forced = "wizarditis")
			if(DT_PROB(0.25, delta_time))
				to_chat(affected_mob, span_danger("Ощущаю, что [pick("у меня недостаточно маны", "потоки магии закончились", "надо кого-то призвать")]."))
		if(3)
			if(DT_PROB(0.25, delta_time))
				affected_mob.say(pick("NEC CANTIO!","AULIE OXIN FIERA!", "STI KALY!", "TARCOL MINTI ZHERI!"), forced = "wizarditis")
			if(DT_PROB(0.25, delta_time))
				to_chat(affected_mob, span_danger("Ощущаю [pick("кипящую магию в моих венах", "эта местность даёт мне +1 к INT", "надобность кого-то призвать")]."))
		if(4)
			if(DT_PROB(0.5, delta_time))
				affected_mob.say(pick("NEC CANTIO!","AULIE OXIN FIERA!","STI KALY!","EI NATH!"), forced = "wizarditis")
				return
			if(DT_PROB(0.25, delta_time))
				to_chat(affected_mob, span_danger("Ощущаю [pick("приливную волну новой силы внутри меня", "эта местность даёт мне +2 к INT и +1 к WIS", "надобность телепортироваться")]."))
				spawn_wizard_clothes(50)
			if(DT_PROB(0.005, delta_time))
				teleport()


/datum/disease/wizarditis/proc/spawn_wizard_clothes(chance = 0)
	if(ishuman(affected_mob))
		var/mob/living/carbon/human/H = affected_mob
		if(prob(chance))
			if(!istype(H.head, /obj/item/clothing/head/wizard))
				if(!H.dropItemToGround(H.head))
					qdel(H.head)
				H.equip_to_slot_or_del(new /obj/item/clothing/head/wizard(H), ITEM_SLOT_HEAD)
			return
		if(prob(chance))
			if(!istype(H.wear_suit, /obj/item/clothing/suit/wizrobe))
				if(!H.dropItemToGround(H.wear_suit))
					qdel(H.wear_suit)
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/wizrobe(H), ITEM_SLOT_OCLOTHING)
			return
		if(prob(chance))
			if(!istype(H.shoes, /obj/item/clothing/shoes/sandal/magic))
				if(!H.dropItemToGround(H.shoes))
					qdel(H.shoes)
			H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal/magic(H), ITEM_SLOT_FEET)
			return
	else
		var/mob/living/carbon/H = affected_mob
		if(prob(chance))
			var/obj/item/staff/S = new(H)
			if(!H.put_in_hands(S))
				qdel(S)


/datum/disease/wizarditis/proc/teleport()
	var/list/theareas = get_areas_in_range(80, affected_mob)
	for(var/area/space/S in theareas)
		theareas -= S

	if(!theareas||!theareas.len)
		return

	var/area/thearea = pick(theareas)

	var/list/L = list()
	for(var/turf/T in get_area_turfs(thearea.type))
		if(T.z != affected_mob.z)
			continue
		if(T.name == "space")
			continue
		if(!T.density)
			var/clear = 1
			for(var/obj/O in T)
				if(O.density)
					clear = 0
					break
			if(clear)
				L+=T

	if(!L)
		return

	affected_mob.say("SCYAR NILA [uppertext(thearea.name)]!", forced = "wizarditis teleport")
	affected_mob.forceMove(pick(L))

	return
