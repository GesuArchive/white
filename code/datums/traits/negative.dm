//predominantly negative traits

/// Defines for locations of items being added to your inventory on spawn
#define LOCATION_LPOCKET "в левом кармане"
#define LOCATION_RPOCKET "в правом кармане"
#define LOCATION_BACKPACK "в сумке"
#define LOCATION_HANDS "в руках"

/datum/quirk/badback
	name = "Больная спина"
	desc = "Из-за моей плохой осанки рюкзаки будет носить КРАЙНЕ неудобно."
	value = -8
	mood_quirk = TRUE
	gain_text = span_danger("Моя спина ОЧЕНЬ СИЛЬНО болит!")
	lose_text = span_notice("Моя спина чувствует себя лучше...")
	medical_record_text = "Сканирование пациента даёт показание, что его спина сильно болит."
	hardcore_value = 4

/datum/quirk/badback/on_process()
	var/mob/living/carbon/human/H = quirk_holder
	if(H.back && istype(H.back, /obj/item/storage/backpack))
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "back_pain", /datum/mood_event/back_pain)
	else
		SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "back_pain")

/datum/quirk/blooddeficiency
	name = "Дефицит крови"
	desc = "Мой организм не будет производить достаточно крови для нормального функционирования."
	value = -8
	gain_text = span_danger("Чувствую онемение.")
	lose_text = span_notice("Чувствую себя бодрым!")
	medical_record_text = " Пациенту необходима дополнительная помощь для переливания крови из-за её дефицита в организме."
	hardcore_value = 8

/datum/quirk/blooddeficiency/on_process(delta_time)
	var/mob/living/carbon/human/H = quirk_holder
	if(NOBLOOD in H.dna.species.species_traits) //can't lose blood if your species doesn't have any
		return

	if (H.blood_volume > (BLOOD_VOLUME_SAFE - 25)) // just barely survivable without treatment
		H.blood_volume -= 0.275 * delta_time

/datum/quirk/blindness
	name = "Слепой"
	desc = "Буду абсолютно слепым. Ничего не сможет воспрепятствовать этому."
	value = -16
	gain_text = span_danger("Ничего не вижу!")
	lose_text = span_notice("Чудесным образом снова вижу!")
	medical_record_text = "Пациент имеет постоянную слепоту."
	hardcore_value = 15

/datum/quirk/blindness/add()
	quirk_holder.become_blind(ROUNDSTART_TRAIT)

/datum/quirk/blindness/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/clothing/glasses/blindfold/white/B = new(get_turf(H))
	if(!H.equip_to_slot_if_possible(B, ITEM_SLOT_EYES, bypass_equip_delay_self = TRUE)) //if you can't put it on the user's eyes, put it in their hands, otherwise put it on their eyes
		H.put_in_hands(B)

	/* A couple of brain tumor stats for anyone curious / looking at this quirk for balancing:
	 * - It takes less 16 minute 40 seconds to die from brain death due to a brain tumor.
	 * - It takes 1 minutes 40 seconds to take 10% (20 organ damage) brain damage.
	 * - 5u mannitol will heal 12.5% (25 organ damage) brain damage
	 */
/datum/quirk/brainproblems
	name = "Паразит в голове"
	desc = "В моей голове заведётся маленький дружок, который медленно будет пожирать мой мозг. Будет хорошим выбором носить с собой маннитол."
	value = -12
	gain_text = span_danger("Чувствую боль в голове.")
	lose_text = span_notice("Чувствую, что голова перестала болеть.")
	medical_record_text = "Пациент имеет паразита в голове, который медленно пожирает его мозг, и в скором будущем это может привести к летальному исходу."
	hardcore_value = 12
	/// Location of the bottle of pills on spawn
	var/where

/datum/quirk/brainproblems/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/pills = new /obj/item/storage/pill_bottle/mannitol/braintumor()
	var/list/slots = list(
		LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
		LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
		LOCATION_BACKPACK = ITEM_SLOT_BACKPACK,
		LOCATION_HANDS = ITEM_SLOT_HANDS
	)
	where = H.equip_in_one_of_slots(pills, slots, FALSE) || "у моих ног"

/datum/quirk/brainproblems/post_add()
	if(where == LOCATION_BACKPACK)
		var/mob/living/carbon/human/H = quirk_holder
		H.back.atom_storage.show_contents(H)

	to_chat(quirk_holder, span_boldnotice("У вас имеется пачка маннитола [where], которая будет помогать вам остаться в живых. Не стоит слишком сильно надеяться на него!"))

/datum/quirk/brainproblems/on_process(delta_time)
	if(HAS_TRAIT(quirk_holder, TRAIT_TUMOR_SUPPRESSED))
		return
	quirk_holder.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.2 * delta_time)

/datum/quirk/deafness
	name = "Глухонемой"
	desc = "Я перестану слышать какие-либо звуки."
	value = -8
	mob_trait = TRAIT_DEAF
	gain_text = span_danger("Не могу слышать.")
	lose_text = span_notice("Теперь я снова слышу!")
	medical_record_text = "Ушная улитка пациента повреждена и не подвергается лечению."
	hardcore_value = 12

/datum/quirk/depression
	name = "Депрессивный"
	desc = "Иногда я просто буду ненавидеть свою жизнь."
	mob_trait = TRAIT_DEPRESSION
	value = -3
	gain_text = span_danger("Чувствую себя депрессивным.")
	lose_text = span_notice("Больше не чувствую себя депрессивным.")  // если один это было так легко!
	medical_record_text = "Пациент имеет серьёзное психическое заболевание, в результате чего у него возникают острые эпизоды депрессии."
	mood_quirk = TRUE
	hardcore_value = 1

/datum/quirk/depression/on_process(delta_time)
	if(DT_PROB(0.05, delta_time))
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "depression_mild", /datum/mood_event/depression_mild)

/datum/quirk/family_heirloom
	name = "Семейная реликвия"
	desc = "Буду владельцем семейной реликвии, которая передаётся мне из поколения в поколение. Стоило бы держать эту реликвию всегда с собой."
	value = -2
	mood_quirk = TRUE
	var/obj/item/heirloom
	var/where
	medical_record_text = "Пациент демонстрирует неестественную привязанность к его семейной реликвии."
	hardcore_value = 1

/datum/quirk/family_heirloom/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/heirloom_type

	if(ismoth(H) && prob(50))
		heirloom_type = /obj/item/flashlight/lantern/heirloom_moth
	else
		switch(quirk_holder?.mind?.assigned_role)
			//Service jobs
			if(JOB_CLOWN)
				heirloom_type = /obj/item/bikehorn/golden
			if(JOB_MIME)
				heirloom_type = /obj/item/food/baguette
			if(JOB_JANITOR)
				heirloom_type = pick(/obj/item/mop, /obj/item/clothing/suit/caution, /obj/item/reagent_containers/glass/bucket, /obj/item/paper/fluff/stations/soap)
			if(JOB_COOK)
				heirloom_type = pick(/obj/item/reagent_containers/food/condiment/saltshaker, /obj/item/kitchen/rollingpin, /obj/item/clothing/head/chefhat)
			if(JOB_BOTANIST)
				heirloom_type = pick(/obj/item/cultivator, /obj/item/reagent_containers/glass/bucket, /obj/item/toy/plush/beeplushie)
			if(JOB_BARTENDER)
				heirloom_type = pick(/obj/item/reagent_containers/glass/rag, /obj/item/clothing/head/that, /obj/item/reagent_containers/food/drinks/shaker)
			if(JOB_CURATOR)
				heirloom_type = pick(/obj/item/pen/fountain, /obj/item/storage/pill_bottle/dice)
			if(JOB_CHAPLAIN)
				heirloom_type = pick(/obj/item/toy/windup_toolbox, /obj/item/reagent_containers/food/drinks/bottle/holywater)
			if(JOB_ASSISTANT, JOB_INTERN, JOB_FREELANCER)
				heirloom_type = pick(/obj/item/storage/toolbox/mechanical/old/heirloom, /obj/item/clothing/gloves/cut/heirloom)
			//Security/Command
			if(JOB_CAPTAIN)
				heirloom_type = /obj/item/reagent_containers/food/drinks/flask/gold
			if(JOB_HEAD_OF_SECURITY)
				heirloom_type = /obj/item/book/manual/wiki/security_space_law
			if(JOB_HEAD_OF_PERSONNEL)
				heirloom_type = /obj/item/reagent_containers/food/drinks/trophy/silver_cup
			if(JOB_WARDEN)
				heirloom_type = /obj/item/book/manual/wiki/security_space_law
			if(JOB_SECURITY_OFFICER)
				heirloom_type = pick(/obj/item/book/manual/wiki/security_space_law, /obj/item/clothing/head/beret/sec)
			if(JOB_RUSSIAN_OFFICER)
				heirloom_type = pick(/obj/item/book/manual/wiki/security_space_law, /obj/item/reagent_containers/food/drinks/bottle/vodka)
			if(JOB_VETERAN)
				heirloom_type = pick(/obj/item/book/manual/wiki/security_space_law, /obj/item/reagent_containers/food/drinks/boyarka)
			if(JOB_DETECTIVE)
				heirloom_type = /obj/item/reagent_containers/food/drinks/bottle/whiskey
			if(JOB_LAWYER)
				heirloom_type = pick(/obj/item/gavelhammer, /obj/item/book/manual/wiki/security_space_law)
			if(JOB_PRISONER)
				heirloom_type = /obj/item/pen/blue
			//RnD
			if(JOB_RESEARCH_DIRECTOR)
				heirloom_type = /obj/item/toy/plush/slimeplushie
			if(JOB_SCIENTIST)
				heirloom_type = /obj/item/toy/plush/slimeplushie
			if(JOB_ROBOTICIST)
				heirloom_type = pick(subtypesof(/obj/item/toy/prize) + /obj/item/toy/plush/pkplush) //look at this nerd
			if(JOB_GENETICIST)
				heirloom_type = /obj/item/clothing/under/shorts/purple
			//Medical
			if(JOB_CHIEF_MEDICAL_OFFICER)
				heirloom_type = /obj/item/storage/firstaid/ancient/heirloom
			if(JOB_MEDICAL_DOCTOR)
				heirloom_type = /obj/item/storage/firstaid/ancient/heirloom
			if(JOB_PARAMEDIC, JOB_FIELD_MEDIC)
				heirloom_type = /obj/item/storage/firstaid/ancient/heirloom
			if(JOB_PSYCHOLOGIST)
				heirloom_type = /obj/item/storage/pill_bottle
			if(JOB_CHEMIST)
				heirloom_type = pick(/obj/item/book/manual/wiki/chemistry, /obj/item/ph_booklet)
			if(JOB_VIROLOGIST)
				heirloom_type = /obj/item/reagent_containers/syringe
			//Engineering
			if(JOB_CHIEF_ENGINEER)
				heirloom_type = pick(/obj/item/clothing/head/hardhat/white, /obj/item/screwdriver, /obj/item/wrench, /obj/item/weldingtool, /obj/item/crowbar, /obj/item/wirecutters)
			if(JOB_STATION_ENGINEER, JOB_MECHANIC, JOB_SPECIALIST)
				heirloom_type = pick(/obj/item/clothing/head/hardhat, /obj/item/screwdriver, /obj/item/wrench, /obj/item/weldingtool, /obj/item/crowbar, /obj/item/wirecutters)
			if(JOB_ATMOSPHERIC_TECHNICIAN)
				heirloom_type = pick(/obj/item/lighter, /obj/item/lighter/greyscale, /obj/item/storage/box/matches)
			//Supply
			if(JOB_QUARTERMASTER)
				heirloom_type = pick(/obj/item/stamp, /obj/item/stamp/denied)
			if(JOB_CARGO_TECHNICIAN)
				heirloom_type = /obj/item/clipboard
			if(JOB_SHAFT_MINER, JOB_HUNTER)
				heirloom_type = pick(/obj/item/pickaxe/mini, /obj/item/shovel)

	if(!heirloom_type)
		heirloom_type = pick(
		/obj/item/toy/cards/deck,
		/obj/item/lighter,
		/obj/item/dice/d20)
	heirloom = new heirloom_type(get_turf(quirk_holder))
	var/list/slots = list(
		LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
		LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
		LOCATION_BACKPACK = ITEM_SLOT_BACKPACK,
		LOCATION_HANDS = ITEM_SLOT_HANDS
	)
	where = H.equip_in_one_of_slots(heirloom, slots, FALSE) || "у моих ног"

/datum/quirk/family_heirloom/post_add()
	if(where == LOCATION_BACKPACK)
		var/mob/living/carbon/human/H = quirk_holder
		H.back.atom_storage.show_contents(H)

	to_chat(quirk_holder, span_boldnotice("Дорогая для вас реликвия [heirloom.name] [where], передавалась из поколения в поколение. Хранить в безопасности!"))

	var/list/names = splittext(quirk_holder.real_name, " ")
	var/family_name = names[names.len]

	heirloom.AddComponent(/datum/component/heirloom, quirk_holder.mind, family_name)

/datum/quirk/family_heirloom/on_process()
	if(heirloom in quirk_holder.get_all_contents())
		SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "family_heirloom_missing")
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "family_heirloom", /datum/mood_event/family_heirloom)
	else
		SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "family_heirloom")
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "family_heirloom_missing", /datum/mood_event/family_heirloom_missing)

/datum/quirk/family_heirloom/remove()
	if(quirk_holder) // if the holder is still exists lets remove moods
		SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "family_heirloom_missing")
		SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "family_heirloom")

/datum/quirk/frail
	name = "Хилый"
	desc = "Мои кости очень хрупкие! Мои конечности не смогут выдержать слишком много повреждений."
	value = -6
	mob_trait = TRAIT_EASILY_WOUNDED
	gain_text = span_danger("Чувствую себя слабым.")
	lose_text = span_notice("Вновь чувствую себя крепким!")
	medical_record_text = "Пациент имеет очень слабые кости, рекомендуется кальцевая диета."
	hardcore_value = 4

/datum/quirk/heavy_sleeper
	name = "Крепкий сон"
	desc = "Буду крепко спать. Время на пробуждение будет слегка увеличено."
	value = -2
	mob_trait = TRAIT_HEAVY_SLEEPER
	gain_text = span_danger("Чувствую себя вялым.")
	lose_text = span_notice("Вновь чувствую себя бодрым!")
	medical_record_text = "Пациент имеет отрицательные результаты качества сна и его трудно разбудить."
	hardcore_value = 2

/datum/quirk/hypersensitive
	name = "Нытик"
	desc = "Хорошо ли это, или плохо, но влияние на мое настроение будет более сильнее, чем должно быть."
	value = -2
	gain_text = span_danger("Мне хочется создать одну огромную проблему из всего.")
	lose_text = span_notice("Мне больше не хочется устраивать кипиш.")
	medical_record_text = "Пациент демонстрирует высокие перепады настроения."
	hardcore_value = 3

/datum/quirk/hypersensitive/add()
	var/datum/component/mood/mood = quirk_holder.GetComponent(/datum/component/mood)
	if(mood)
		mood.mood_modifier += 0.5

/datum/quirk/hypersensitive/remove()
	if(quirk_holder)
		var/datum/component/mood/mood = quirk_holder.GetComponent(/datum/component/mood)
		if(mood)
			mood.mood_modifier -= 0.5

/datum/quirk/light_drinker
	name = "Трезвенник"
	desc = "Я трезвенник. Влияние на меня от алкоголя будет увеличено."
	value = -2
	mob_trait = TRAIT_LIGHT_DRINKER
	gain_text = span_notice("Даже мысль об алкоголе заставляет вашу голову кружиться.")
	lose_text = span_danger("Чувствую себя более устойчивее к алкоголю.")
	medical_record_text = "Пациент демонстрирует низкую устойчивость к алкоголю."
	hardcore_value = 3

/datum/quirk/nearsighted //t. errorage
	name = "Близорукий"
	desc = "Я близорукий и мне необходимо ношение очков."
	value = -1
	gain_text = span_danger("Вещи вдалеке кажутся мне сильно расплывчатыми.")
	lose_text = span_notice("Вещи вдалеке теперь видны более четко.")
	medical_record_text = "Пациенту необходимо носить пара очков, чтобы не страдать от близорукости."
	hardcore_value = 5

/datum/quirk/nearsighted/add()
	quirk_holder.become_nearsighted(ROUNDSTART_TRAIT)

/datum/quirk/nearsighted/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/clothing/glasses/regular/glasses = new(get_turf(H))
	if(!H.equip_to_slot_if_possible(glasses, ITEM_SLOT_EYES, bypass_equip_delay_self = TRUE))
		H.put_in_hands(glasses)

/datum/quirk/nyctophobia
	name = "Боязнь темноты"
	desc = "Боюсь темноты. Будучи в темноте без света, необходимо идти шагом или..."
	value = -3
	medical_record_text = "Пациент демонстрирует страх к темноте."
	hardcore_value = 5

/datum/quirk/nyctophobia/on_process()
	var/mob/living/carbon/human/H = quirk_holder
	if(H.dna.species.id in list("shadow", "nightmare"))
		return //we're tied with the dark, so we don't get scared of it; don't cleanse outright to avoid cheese
	var/turf/T = get_turf(quirk_holder)
	if(!T)
		return
	var/lums = T.get_lumcount()
	if(lums <= 0.2)
		if(quirk_holder.m_intent == MOVE_INTENT_RUN)
			to_chat(quirk_holder, span_warning("Так, спокойно, спокойно... ничего страшного..."))
			quirk_holder.toggle_move_intent()
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "nyctophobia", /datum/mood_event/nyctophobia)
	else
		SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "nyctophobia")

/datum/quirk/nonviolent
	name = "Пацифист"
	desc = "Мысль о насилии будет заставлять меня чувствовать себя неприятно. Настолько, что не смогу нанести вред окружающим."
	value = -8
	mob_trait = TRAIT_PACIFISM
	gain_text = span_danger("Чувствую себя жутко, подумав о насилии!")
	lose_text = span_notice("Чувствую, что можно защитить себя вновь.")
	medical_record_text = "Пациент является пацифистом и не может заставить себя причинить вред кому-либо."
	hardcore_value = 6

/datum/quirk/nonviolent/on_process()
	if(quirk_holder.mind && LAZYLEN(quirk_holder.mind.antag_datums))
		to_chat(quirk_holder, span_boldannounce("Моя антагонистическая натура заставила меня обдумать свой пацифизм..."))
		qdel(src)

/datum/quirk/paraplegic
	name = "Инвалид"
	desc = "Мои ноги не функционируют и больше ничего не может помочь мне вновь встать на ноги. По крайней мере, у меня есть инвалидная коляска."
	value = -12
	human_only = TRUE
	gain_text = null // Handled by trauma.
	lose_text = null
	medical_record_text = "Пациент страдает параличом нижних конечностей."
	hardcore_value = 15

/datum/quirk/paraplegic/add()
	var/datum/brain_trauma/severe/paralysis/paraplegic/T = new()
	var/mob/living/carbon/human/H = quirk_holder
	H.gain_trauma(T, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/paraplegic/on_spawn()
	if(quirk_holder.buckled) // Handle late joins being buckled to arrival shuttle chairs.
		quirk_holder.buckled.unbuckle_mob(quirk_holder)

	var/turf/T = get_turf(quirk_holder)
	var/obj/structure/chair/spawn_chair = locate() in T

	var/obj/vehicle/ridden/wheelchair/wheels
	if(quirk_holder.client?.get_award_status(HARDCORE_RANDOM_SCORE) >= 5000) //More than 5k score? you unlock the gamer wheelchair.
		wheels = new /obj/vehicle/ridden/wheelchair/gold(T)
	else
		wheels = new(T)
	if(spawn_chair) // Makes spawning on the arrivals shuttle more consistent looking
		wheels.setDir(spawn_chair.dir)

	wheels.buckle_mob(quirk_holder)

	// During the spawning process, they may have dropped what they were holding, due to the paralysis
	// So put the things back in their hands.

	for(var/obj/item/I in T)
		if(I.fingerprintslast == quirk_holder.ckey)
			quirk_holder.put_in_hands(I)

/datum/quirk/poor_aim
	name = "Плохо стреляющий"
	desc = "Мои навыки обращения с оружием оставляют желать лучшего."
	value = -4
	mob_trait = TRAIT_POOR_AIM
	medical_record_text = "У пациента сильная дрожь в обеих руках."
	hardcore_value = 3

/datum/quirk/prosopagnosia
	name = "Прозопагнозия"
	desc = "Я не смогу больше распознавать лица."
	value = -4
	mob_trait = TRAIT_PROSOPAGNOSIA
	medical_record_text = "Пациент страдает от прозопагнозии и не может узнать лица."
	hardcore_value = 5

/datum/quirk/prosthetic_limb
	name = "Протез конечности"
	desc = "Ввиду инцидента, который случился в прошлом, мне удалось потерять одну из конечностей. Случайная конечность будет заменена на дешевый протез."
	value = -4
	var/slot_string = "limb"
	medical_record_text = "Во время физического обследования у пациента был обнаружен протез."
	hardcore_value = 3

/datum/quirk/prosthetic_limb/on_spawn()
	var/limb_slot = pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/bodypart/old_part = H.get_bodypart(limb_slot)
	var/obj/item/bodypart/prosthetic
	switch(limb_slot)
		if(BODY_ZONE_L_ARM)
			prosthetic = new/obj/item/bodypart/l_arm/robot/surplus(quirk_holder)
			slot_string = "левая рука"
		if(BODY_ZONE_R_ARM)
			prosthetic = new/obj/item/bodypart/r_arm/robot/surplus(quirk_holder)
			slot_string = "правая рука"
		if(BODY_ZONE_L_LEG)
			prosthetic = new/obj/item/bodypart/l_leg/robot/surplus(quirk_holder)
			slot_string = "левая нога"
		if(BODY_ZONE_R_LEG)
			prosthetic = new/obj/item/bodypart/r_leg/robot/surplus(quirk_holder)
			slot_string = "правая нога"
	prosthetic.replace_limb(H)
	qdel(old_part)
	H.regenerate_icons()

/datum/quirk/prosthetic_limb/post_add()
	to_chat(quirk_holder, "<span class='boldannounce'>Моя [slot_string] была заменена протезом. Он довольно хрупкий и его легче сломать. Для лечения протеза, \
	необходимо будет использовать сварочный инструмент или кабели, вместо обычных пластырей или бинтов.</span>")

/datum/quirk/pushover
	name = "Неуверенный"
	desc = "Мой первый инстинкт будет позволять людям толкать меня. Вырываться из захвата будет сложнее."
	value = -8
	mob_trait = TRAIT_GRABWEAKNESS
	gain_text = span_danger("Чувствую себя неуверенно.")
	lose_text = span_notice("Теперь-то я смогу защитить себя!")
	medical_record_text = "Пациент представляет собой неуверенную и наивную личность, и им легко манипулировать."
	hardcore_value = 4

/datum/quirk/insanity
	name = "Синдром Диссоциации Реальности"
	desc = "Страдаете от серьёзного психического расстройства, которое вызывает очень сильные галлюцинации. Вещество \"Майндбрейкер\" поможет мне подавить эти эффекты. <b>Это не является лицензией на убийство</b>"
	value = -8
	//no mob trait because it's handled uniquely
	gain_text = span_userdanger("...")
	lose_text = span_notice("Чувствую себя нормальным..")
	medical_record_text = "Пациент страдает от Синдрома Диссоциации Реальности, вызывающее у него тяжелые галлюцинации."
	hardcore_value = 6

/datum/quirk/insanity/on_process(delta_time)
	if(quirk_holder.reagents.has_reagent(/datum/reagent/toxin/mindbreaker, needs_metabolizing = TRUE))
		quirk_holder.hallucination = 0
		return
	if(DT_PROB(2, delta_time)) //we'll all be mad soon enough
		madness()

/datum/quirk/insanity/proc/madness()
	quirk_holder.hallucination += rand(10, 25)

/datum/quirk/insanity/post_add() //I don't /think/ we'll need this but for newbies who think "roleplay as insane" = "license to kill" it's probably a good thing to have
	if(!quirk_holder.mind || quirk_holder.mind.special_role)
		return
	to_chat(quirk_holder, "<span class='big bold info'>Учтите, что ваш синдром диссоциации НЕ даёт права нападать на других людей, или каким-нибудь образом портить раунд окружающим. \
Вы не антагонист, и правила игры все еще действуют на вас, как на остальных игроков.</span>")

/datum/quirk/social_anxiety
	name = "Социофоб"
	desc = "Разговор с людьми очень сложен для вас, и вы будете заикаться при попытке заговорить, или просто молчать."
	value = -3
	gain_text = span_danger("Начинаю волноваться насчёт мнения окружающих.")
	lose_text = span_notice("Становится легче говорить.")  //if only it were that easy!
	medical_record_text = "Пациент, как правило, беспокоится о социальных связях и предпочитает избегать их."
	hardcore_value = 4
	var/dumb_thing = TRUE

/datum/quirk/social_anxiety/add()
	RegisterSignal(quirk_holder, COMSIG_MOB_EYECONTACT, PROC_REF(eye_contact))
	RegisterSignal(quirk_holder, COMSIG_MOB_EXAMINATE, PROC_REF(looks_at_floor))

/datum/quirk/social_anxiety/remove()
	UnregisterSignal(quirk_holder, list(COMSIG_MOB_EYECONTACT, COMSIG_MOB_EXAMINATE))

/datum/quirk/social_anxiety/on_process(delta_time)
	if(HAS_TRAIT(quirk_holder, TRAIT_FEARLESS))
		return
	var/nearby_people = 0
	for(var/mob/living/carbon/human/H in oview(3, quirk_holder))
		if(H.client)
			nearby_people++
	var/mob/living/carbon/human/H = quirk_holder
	if(DT_PROB(2 + nearby_people, delta_time))
		H.stuttering = max(3, H.stuttering)
	else if(DT_PROB(min(3, nearby_people), delta_time) && !H.silent)
		to_chat(H, span_danger("Решаю просто немного помолчать. Мне <i>совсем</i> не хочется разговаривать."))
		H.silent = max(10, H.silent)
	else if(DT_PROB(0.5, delta_time) && dumb_thing)
		to_chat(H, span_userdanger("Вспоминаю дурацкую вещь, которую сказали давным давно и испытываю внутреннюю боль."))
		dumb_thing = FALSE //only once per life
		if(prob(1))
			new/obj/item/food/spaghetti/pastatomato(get_turf(H)) //now that's what I call spaghetti code

// small chance to make eye contact with inanimate objects/mindless mobs because of nerves
/datum/quirk/social_anxiety/proc/looks_at_floor(datum/source, atom/A)
	SIGNAL_HANDLER

	var/mob/living/mind_check = A
	if(prob(85) || (istype(mind_check) && mind_check.mind))
		return

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), quirk_holder, span_smallnotice("[capitalize(A.name)] смотрит прямо на меня.")), 3)

/datum/quirk/social_anxiety/proc/eye_contact(datum/source, mob/living/other_mob, triggering_examiner)
	SIGNAL_HANDLER

	if(prob(75))
		return
	var/msg
	if(triggering_examiner)
		msg = "[capitalize(other_mob.name)] смотрит прямо на меня, "
	else
		msg = "[capitalize(other_mob.name)] смотрит прямо на меня, "

	switch(rand(1,3))
		if(1)
			quirk_holder.Jitter(10)
			msg += "жуть!"
		if(2)
			quirk_holder.stuttering = max(3, quirk_holder.stuttering)
			msg += "страшно!"
		if(3)
			quirk_holder.Stun(2 SECONDS)
			msg += "АХ!"

	SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "anxiety_eyecontact", /datum/mood_event/anxiety_eyecontact)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), quirk_holder, span_userdanger("[msg]")), 3) // so the examine signal has time to fire and this will print after
	return COMSIG_BLOCK_EYECONTACT

/datum/mood_event/anxiety_eyecontact
	description = "<span class='warning'>Sometimes eye contact makes me so nervous...</span>\n"
	mood_change = -10
	timeout = 3 MINUTES

/datum/quirk/junkie
	name = "Наркоман"
	desc = "Страдаю от наркотической зависимости."
	value = -6
	gain_text = span_danger("Внезапно ощущаю тягу к наркотикам.")
	medical_record_text = "Пациент страдает от зависимости и тяжелых наркотиков."
	hardcore_value = 4
	var/drug_list = list(/datum/reagent/drug/crank, /datum/reagent/drug/krokodil, /datum/reagent/medicine/morphine, /datum/reagent/drug/happiness, /datum/reagent/drug/methamphetamine) //List of possible IDs
	var/datum/reagent/reagent_type //!If this is defined, reagent_id will be unused and the defined reagent type will be instead.
	var/datum/reagent/reagent_instance //! actual instanced version of the reagent
	var/where_drug //! Where the drug spawned
	var/obj/item/drug_container_type //! If this is defined before pill generation, pill generation will be skipped. This is the type of the pill bottle.
	var/where_accessory //! where the accessory spawned
	var/obj/item/accessory_type //! If this is null, an accessory won't be spawned.
	var/process_interval = 30 SECONDS //! how frequently the quirk processes
	var/next_process = 0 //! ticker for processing

/datum/quirk/junkie/on_spawn()
	var/mob/living/carbon/human/H = quirk_holder
	if (!reagent_type)
		reagent_type = pick(drug_list)
	reagent_instance = new reagent_type()
	if(H.mind)
		for(var/addiction in reagent_instance.addiction_types)
			H.mind.add_addiction_points(addiction, 1000) ///Max that shit out
	var/current_turf = get_turf(quirk_holder)
	if (!drug_container_type)
		drug_container_type = /obj/item/storage/pill_bottle
	var/obj/item/drug_instance = new drug_container_type(current_turf)
	if (istype(drug_instance, /obj/item/storage/pill_bottle))
		var/pill_state = "pill[rand(1,20)]"
		for(var/i in 1 to 7)
			var/obj/item/reagent_containers/pill/P = new(drug_instance)
			P.icon_state = pill_state
			P.reagents.add_reagent(reagent_type, 1)

	var/obj/item/accessory_instance
	if (accessory_type)
		accessory_instance = new accessory_type(current_turf)
	var/list/slots = list(
		LOCATION_LPOCKET = ITEM_SLOT_LPOCKET,
		LOCATION_RPOCKET = ITEM_SLOT_RPOCKET,
		LOCATION_BACKPACK = ITEM_SLOT_BACKPACK
	)
	where_drug = H.equip_in_one_of_slots(drug_instance, slots, FALSE) || "у моих ног"
	if (accessory_instance)
		where_accessory = H.equip_in_one_of_slots(accessory_instance, slots, FALSE) || "у моих ног"
	spawn(1 SECONDS)
		announce_drugs()

/datum/quirk/junkie/post_add()
	if(where_drug == LOCATION_BACKPACK || where_accessory == LOCATION_BACKPACK)
		var/mob/living/carbon/human/H = quirk_holder
		H.back.atom_storage.show_contents(H)

/datum/quirk/junkie/remove()
	if(quirk_holder && reagent_instance)
		for(var/addiction_type in subtypesof(/datum/addiction))
			quirk_holder.mind.remove_addiction_points(addiction_type, MAX_ADDICTION_POINTS) //chat feedback here. No need of lose_text.

/datum/quirk/junkie/proc/announce_drugs()
	to_chat(quirk_holder, span_boldnotice("Пронёс [initial(drug_container_type.name)] из [initial(reagent_type.name)] [where_drug]. Скоро он закончится, и мне необходимо будет найти дополнительную дозу."))

/datum/quirk/junkie/on_process()
	if(HAS_TRAIT(quirk_holder, TRAIT_NOMETABOLISM))
		return
	var/mob/living/carbon/human/H = quirk_holder
	if(world.time > next_process)
		next_process = world.time + process_interval
		var/deleted = QDELETED(reagent_instance)
		var/missing_addiction = FALSE
		for(var/addiction_type in reagent_instance.addiction_types)
			if(H?.mind && !LAZYACCESS(H.mind.active_addictions, addiction_type))
				missing_addiction = TRUE
		if(deleted || missing_addiction)
			if(deleted)
				reagent_instance = new reagent_type()
			to_chat(quirk_holder, span_danger("Хочу [reagent_instance?.name].."))
			if(H?.mind)
				for(var/addiction in reagent_instance.addiction_types)
					H.mind.add_addiction_points(addiction, 1000) ///Max that shit out

/datum/quirk/junkie/smoker
	name = "Курильщик"
	desc = "Страдаю от никотиновой зависимости и мне придется регулярно выкуривать пачку сигарет. Не очень-то и полезно для легких."
	value = -4
	gain_text = span_danger("Мне стоит снова закурить.")
	medical_record_text = "Пациент является курильщиком."
	reagent_type = /datum/reagent/drug/nicotine
	accessory_type = /obj/item/lighter/greyscale
	hardcore_value = 1

/datum/quirk/junkie/smoker/on_spawn()
	drug_container_type = pick(/obj/item/storage/fancy/cigarettes,
		/obj/item/storage/fancy/cigarettes/cigpack_midori,
		/obj/item/storage/fancy/cigarettes/cigpack_uplift,
		/obj/item/storage/fancy/cigarettes/cigpack_robust,
		/obj/item/storage/fancy/cigarettes/cigpack_robustgold,
		/obj/item/storage/fancy/cigarettes/cigpack_carp)
	quirk_holder?.mind?.store_memory("Мой любимый тип сигарет [initial(drug_container_type.name)].")
	. = ..()

/datum/quirk/junkie/smoker/announce_drugs()
	to_chat(quirk_holder, span_notice("\nПачка сигарет [initial(drug_container_type.name)] [where_drug], и зажигалочка [where_accessory]. Надо убедиться, что я найду свой любимый бренд, если тот закончится."))


/datum/quirk/junkie/smoker/on_process()
	. = ..()
	var/mob/living/carbon/human/H = quirk_holder
	var/obj/item/I = H.get_item_by_slot(ITEM_SLOT_MASK)
	if (istype(I, /obj/item/clothing/mask/cigarette))
		var/obj/item/storage/fancy/cigarettes/C = drug_container_type
		if(istype(I, initial(C.spawn_type)))
			SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "wrong_cigs")
			return
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "wrong_cigs", /datum/mood_event/wrong_brand)

/datum/quirk/unstable
	name = "Неуравновешенный"
	desc = "Больше не сможете вернуть свою психику, если каким-то образом поврежу её. Надо быть очень осторожным и поддерживать свое настроение выше нормы!"
	value = -10
	mob_trait = TRAIT_UNSTABLE
	gain_text = span_danger("Столько вещей сейчас в голове...")
	lose_text = span_notice("Чувствую себя гораздо спокойнее.")
	medical_record_text = "Психика пациента находится в уязвимом состоянии и не сможет больше оправиться после травмы."
	hardcore_value = 9

/datum/quirk/allergic
	name = "Аллергия"
	desc = "С детства у меня имеется аллергия к некоторым препаратам и реагентам."
	value = -6
	gain_text = span_danger("Чувствую сдвиг вашей иммунной системы.")
	lose_text = span_notice("Чувствую, что ваш иммунитет стал более устойчивее.")
	medical_record_text = "Иммунитет пациента очень резко реагирует на определенные препараты."
	hardcore_value = 3
	var/list/allergies = list()
	var/list/blacklist = list(/datum/reagent/medicine/c2,/datum/reagent/medicine/epinephrine,/datum/reagent/medicine/adminordrazine,/datum/reagent/medicine/omnizine/godblood,/datum/reagent/medicine/cordiolis_hepatico,/datum/reagent/medicine/synaphydramine,/datum/reagent/medicine/diphenhydramine)

/datum/quirk/allergic/on_spawn()
	var/list/chem_list = subtypesof(/datum/reagent/medicine) - blacklist
	for(var/i in 0 to 5)
		var/chem = pick(chem_list)
		chem_list -= chem
		allergies += chem

/datum/quirk/allergic/post_add()
	var/display = ""
	for(var/C in allergies)
		var/datum/reagent/chemical = C
		display += initial(chemical.name) + ", "
	name = "Extreme " + display +"Allergies"
	medical_record_text = "Иммунитет пациента сильно реагирует на [display]!"
	quirk_holder?.mind.store_memory("У меня аллергия к [display]")
	to_chat(quirk_holder, span_boldnotice("У меня аллергия к [display]!"))
	if(!ishuman(quirk_holder))
		return
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/obj/item/clothing/accessory/allergy_dogtag/dogtag = new(get_turf(human_holder))
	var/list/slots = list (
		"backpack" = ITEM_SLOT_BACKPACK,
		"hands" = ITEM_SLOT_HANDS
	)
	dogtag.display = display
	human_holder.equip_in_one_of_slots(dogtag, slots , qdel_on_fail = TRUE)

/datum/quirk/allergic/on_process(delta_time)
	. = ..()
	if(!iscarbon(quirk_holder))
		return
	var/mob/living/carbon/carbon_quirk_holder = quirk_holder
	for(var/M in allergies)
		var/datum/reagent/instantiated_med = carbon_quirk_holder.reagents.has_reagent(M)
		if(!instantiated_med)
			continue
		//Just halts the progression, I'd suggest you run to medbay asap to get it fixed
		if(carbon_quirk_holder.reagents.has_reagent(/datum/reagent/medicine/epinephrine))
			instantiated_med.reagent_removal_skip_list |= ALLERGIC_REMOVAL_SKIP
			return //intentionally stops the entire proc so we avoid the organ damage after the loop
		instantiated_med.reagent_removal_skip_list -= ALLERGIC_REMOVAL_SKIP
		carbon_quirk_holder.adjustToxLoss(3 * delta_time)
		carbon_quirk_holder.reagents.add_reagent(/datum/reagent/toxin/histamine, 3 * delta_time)
		if(DT_PROB(10, delta_time))
			carbon_quirk_holder.vomit()
			carbon_quirk_holder.adjustOrganLoss(pick(ORGAN_SLOT_BRAIN,ORGAN_SLOT_APPENDIX,ORGAN_SLOT_LUNGS,ORGAN_SLOT_HEART,ORGAN_SLOT_LIVER,ORGAN_SLOT_STOMACH),10)

/datum/quirk/allergic/hyper
	name = "Гипераллергия"
	desc = "Совершенно непредсказумые изменения в организме привели к непереносимости воды."
	value = -8
	allergies = list(/datum/reagent/water, /datum/reagent/water/holywater)
	blacklist = list()

/datum/quirk/bad_touch
	name = "Плохое прикосновение"
	desc = "Не люблю обниматься. Будет предпочтительнее, если меня оставят в покое."
	mob_trait = TRAIT_BADTOUCH
	value = -1
	gain_text = span_danger("You just want people to leave you alone.")
	lose_text = span_notice("You could use a big hug.")
	medical_record_text = "Patient has disdain for being touched. Potentially has undiagnosed haphephobia."
	mood_quirk = TRUE
	hardcore_value = 1

/datum/quirk/bad_touch/add()
	RegisterSignals(quirk_holder, list(COMSIG_LIVING_GET_PULLED, COMSIG_CARBON_HUGGED, COMSIG_CARBON_HEADPAT), PROC_REF(uncomfortable_touch))

/datum/quirk/bad_touch/remove()
	UnregisterSignal(quirk_holder, list(COMSIG_LIVING_GET_PULLED, COMSIG_CARBON_HUGGED, COMSIG_CARBON_HEADPAT))

/datum/quirk/bad_touch/proc/uncomfortable_touch()
	SIGNAL_HANDLER

	var/datum/component/mood/mood = quirk_holder.GetComponent(/datum/component/mood)
	if(mood.sanity <= SANITY_NEUTRAL)
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "bad_touch", /datum/mood_event/very_bad_touch)
	else
		SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "bad_touch", /datum/mood_event/bad_touch)

/datum/quirk/claustrophobia
	name = "Клаустрофобия"
	desc = "Боюсь находиться в тесном пространстве. Если меня поместят внутрь какого-либо контейнера, шкафчика или иного оборудования, у меня начнется паническая атака, и мне будет трудно дышать."
	value = -4
	medical_record_text = "Пациент демонстрирует явные признаки клаустрофобии."
	hardcore_value = 5

/datum/quirk/claustrophobia/remove()
	SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "claustrophobia")

/datum/quirk/claustrophobia/process(delta_time)
	if(quirk_holder.stat != CONSCIOUS || quirk_holder.IsSleeping() || quirk_holder.IsUnconscious())
		return

	if(isturf(quirk_holder.loc))
		SEND_SIGNAL(quirk_holder, COMSIG_CLEAR_MOOD_EVENT, "claustrophobia", /datum/mood_event/claustrophobia)
		return

	SEND_SIGNAL(quirk_holder, COMSIG_ADD_MOOD_EVENT, "claustrophobia", /datum/mood_event/claustrophobia)
	quirk_holder.losebreath += 0.25 // miss a breath one in four times
	if(DT_PROB(25, delta_time))
		to_chat(quirk_holder, span_warning("Чувствую себя в ловушке! Нужно бежать... не могу дышать...")) // джордж флойд

#undef LOCATION_LPOCKET
#undef LOCATION_RPOCKET
#undef LOCATION_BACKPACK
#undef LOCATION_HANDS
