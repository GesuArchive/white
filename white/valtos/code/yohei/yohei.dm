/obj/item/clothing/under/syndicate/yohei
	name = "униформа йохея"
	desc = "Удобная и практичная одежда для самой грязной работы."
	icon_state = "yohei"
	worn_icon = 'white/valtos/icons/clothing/mob/uniform.dmi'
	icon = 'white/valtos/icons/clothing/uniforms.dmi'
	inhand_icon_state = "bl_suit"
	can_adjust = FALSE
	armor = list(MELEE = 20, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 10, RAD = 10, FIRE = 50, ACID = 50)

/obj/item/clothing/under/syndicate/yohei/blue
	desc = "Удобная и практичная одежда для самой грязной работы. Эта синяя."
	icon_state = "yohei_blue"
	armor = list(MELEE = 20, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 25, RAD = 10, FIRE = 75, ACID = 90)

/obj/item/clothing/under/syndicate/yohei/red
	desc = "Удобная и практичная одежда для самой грязной работы. Эта красная."
	icon_state = "yohei_red"
	armor = list(MELEE = 25, BULLET = 15, LASER = 15, ENERGY = 15, BOMB = 15, BIO = 10, RAD = 10, FIRE = 60, ACID = 50)

/obj/item/clothing/under/syndicate/yohei/yellow
	desc = "Удобная и практичная одежда для самой грязной работы. Эта жёлтая."
	icon_state = "yohei_yellow"
	armor = list(MELEE = 20, BULLET = 10, LASER = 10, ENERGY = 25, BOMB = 25, BIO = 10, RAD = 25, FIRE = 75, ACID = 75)

/obj/item/clothing/under/syndicate/yohei/green
	desc = "Удобная и практичная одежда для самой грязной работы. Эта зелёная."
	icon_state = "yohei_green"
	armor = list(MELEE = 20, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 50, BIO = 10, RAD = 10, FIRE = 90, ACID = 50)

/obj/item/clothing/mask/breath/yohei
	name = "маска йохея"
	desc = "Обтягивающая и плотно сидящая маска, которая может быть подключена к источнику воздуха."
	clothing_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	flags_inv = HIDEFACIALHAIR | HIDEFACE | HIDESNOUT
	w_class = WEIGHT_CLASS_SMALL
	visor_flags = BLOCK_GAS_SMOKE_EFFECT | MASKINTERNALS
	visor_flags_inv = HIDEFACIALHAIR | HIDEFACE | HIDESNOUT
	flags_cover = MASKCOVERSMOUTH | MASKCOVERSEYES | PEPPERPROOF
	visor_flags_cover = MASKCOVERSMOUTH | MASKCOVERSEYES | PEPPERPROOF
	icon_state = "yohei"
	worn_icon = 'white/valtos/icons/clothing/mob/mask.dmi'
	icon = 'white/valtos/icons/clothing/masks.dmi'
	inhand_icon_state = "sechailer"
	equip_delay_other = 50
	armor = list(MELEE = 45, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 10, RAD = 10, FIRE = 50, ACID = 50)

/obj/item/clothing/shoes/jackboots/yohei
	name = "сапоги йохея"
	desc = "Модные ботинки, которые обычно носят наёмники."
	icon_state = "yohei"
	worn_icon = 'white/valtos/icons/clothing/mob/shoe.dmi'
	icon = 'white/valtos/icons/clothing/shoes.dmi'
	equip_delay_other = 60
	armor = list(MELEE = 45, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 10, RAD = 10, FIRE = 50, ACID = 50)

/obj/item/clothing/gloves/combat/yohei
	name = "перчатки йохея"
	desc = "Образец того как Нанотрейзен не доверяет своим работникам. Защищают неплохо от всего"
	icon_state = "yohei"
	worn_icon = 'white/valtos/icons/clothing/mob/glove.dmi'
	icon = 'white/valtos/icons/clothing/gloves.dmi'
	inhand_icon_state = "blackgloves"
	armor = list(MELEE = 45, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 10, BIO = 10, RAD = 10, FIRE = 50, ACID = 50)

/obj/item/clothing/suit/hooded/yohei
	name = "плащ йохея"
	desc = "Весьма дорогостоящее многофункциональное оборудование... А вот это просто плащ."
	icon_state = "yohei"
	worn_icon = 'white/valtos/icons/clothing/mob/suit.dmi'
	icon = 'white/valtos/icons/clothing/suits.dmi'
	inhand_icon_state = "coatwinter"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	cold_protection = CHEST|GROIN|ARMS|LEGS
	heat_protection = CHEST|GROIN|ARMS|LEGS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	armor = list(MELEE = 45, BULLET = 45, LASER = 45, ENERGY = 45, BOMB = 40, BIO = 10, RAD = 10, FIRE = 50, ACID = 50)
	hoodtype = /obj/item/clothing/head/hooded/yohei
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/big
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/toy, /obj/item/storage/fancy/cigarettes, /obj/item/lighter, /obj/item/gun, /obj/item/pickaxe, /obj/item/cat_hook)

/obj/item/clothing/head/hooded/yohei
	name = "капюшон йохея"
	desc = "Не даст башке замёрзнуть и защитит от большинства угроз."
	icon_state = "yohei"
	worn_icon = 'white/valtos/icons/clothing/mob/hat.dmi'
	icon = 'white/valtos/icons/clothing/hats.dmi'
	body_parts_covered = HEAD
	cold_protection = HEAD
	heat_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	max_heat_protection_temperature = FIRE_SUIT_MAX_TEMP_PROTECT
	flags_inv = HIDEHAIR|HIDEEARS|HIDEEYES
	armor = list(MELEE = 45, BULLET = 45, LASER = 45, ENERGY = 45, BOMB = 40, BIO = 10, RAD = 10, FIRE = 50, ACID = 50)

/obj/item/shadowcloak/yohei
	name = "генератор маскировки"
	desc = "Делает невидимым на непродолжительное время. Заряжается в темноте."
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "cloak"
	worn_icon = 'white/valtos/icons/clothing/mob/belt.dmi'
	icon = 'white/valtos/icons/clothing/belts.dmi'
	inhand_icon_state = "assaultbelt"
	worn_icon_state = "cloak"
	charge = 400
	max_charge = 400

/obj/item/shadowcloak/yohei/Initialize()
	. = ..()
	visible_message(span_clown("no fun allowed."))
	qdel(src)

/obj/item/shadowcloak/yohei/process(delta_time)
	if(user.get_item_by_slot(ITEM_SLOT_BELT) != src || user.pooed)
		Deactivate()
		return
	var/turf/T = get_turf(src)
	if(on)
		var/lumcount = T.get_lumcount()
		if(lumcount > 0.3)
			charge = max(0, charge - 25 * delta_time)//Quick decrease in light
		else
			charge = min(max_charge, charge + 30 * delta_time) //Charge in the dark
		animate(user,alpha = clamp(255 - charge,0,255),time = 10)

/obj/item/gun/ballistic/automatic/pistol/fallout/yohei9mm
	name = "пистолет Тиберия"
	desc = "Пистолет малой мощности и не сбывшихся надежд. Возможно последний экземпляр."
	icon_state = "gosling"
	inhand_icon_state = "devil"
	mag_type = /obj/item/ammo_box/magazine/fallout/m9mm
	fire_sound = 'white/valtos/sounds/fallout/gunsounds/9mm/9mm2.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	fire_delay = 8
	extra_damage = 30
	extra_penetration = 25

#define MODE_PAINKILLER "болеутоляющее"
#define MODE_OXYLOSS "кислородное голодание"
#define MODE_TOXDUMP "токсины"
#define MODE_FRACTURE "травмы"
#define MODE_BLOOD_INJECTOR "вливание крови"

/obj/item/pamk
	name = "ПАМК"
	desc = "Полевой Автоматический Медицинский Комплект. Инструкция сообщает: воткните в конечность и она исцелится."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "pamk_100"
	w_class = WEIGHT_CLASS_SMALL
	var/charge_left = 100
	var/current_mode = MODE_PAINKILLER

/obj/item/pamk/update_icon()
	. = ..()
	switch(charge_left)
		if(0)
			icon_state = "pamk_0"
		if(1 to 25)
			icon_state = "pamk_25"
		if(26 to 50)
			icon_state = "pamk_50"
		if(51 to 75)
			icon_state = "pamk_75"
		if(76 to 100)
			icon_state = "pamk_100"

/obj/item/pamk/proc/use_charge(amount)
	if(amount > charge_left)
		return FALSE
	charge_left -= amount
	playsound(get_turf(src), 'white/valtos/sounds/pamk_use.ogg', 80)
	update_icon()
	return TRUE

/obj/item/pamk/examine(mob/user)
	. = ..()
	. += "<hr><span class='notice'><b>ЗАРЯД:</b></span> [charge_left]/100.</span>"
	. += "\n<span class='notice'><b>РЕЖИМ:</b></span> [uppertext(current_mode)].</span>"

/obj/item/pamk/attack_self(mob/user)
	. = ..()
	var/new_mode
	switch(current_mode)
		if(MODE_PAINKILLER)
			new_mode = MODE_OXYLOSS
		if(MODE_OXYLOSS)
			new_mode = MODE_TOXDUMP
		if(MODE_TOXDUMP)
			new_mode = MODE_FRACTURE
		if(MODE_FRACTURE)
			new_mode = MODE_BLOOD_INJECTOR
		if(MODE_BLOOD_INJECTOR)
			new_mode = MODE_PAINKILLER
	current_mode = new_mode
	playsound(get_turf(src), 'white/valtos/sounds/pamk_mode.ogg', 80)
	to_chat(user, span_notice("<b>РЕЖИМ:</b></span> [uppertext(current_mode)]."))

/obj/item/pamk/attack(mob/living/M, mob/user)
	. = ..()
	try_heal(M, user)

/obj/item/pamk/proc/try_heal(mob/living/M, mob/user)
	var/obj/item/bodypart/limb = M.get_bodypart(check_zone(user.zone_selected))
	if(!limb)
		to_chat(user, span_notice("А куда колоть то?!"))
		return
	switch(current_mode)
		if(MODE_PAINKILLER)
			if(M.getBruteLoss() > 10 || M.getFireLoss() > 10)
				if(use_charge(10))
					M.heal_overall_damage(25, 25)
				else
					to_chat(user, span_warning("Недостаточно заряда, требуется 10 единиц."))
			else
				to_chat(user, span_warning("Не обнаружено повреждений, либо они незначительны."))
		if(MODE_OXYLOSS)
			if(M.getOxyLoss() > 5)
				if(use_charge(10))
					M.setOxyLoss(0)
				else
					to_chat(user, span_warning("Недостаточно заряда, требуется 10 единиц."))
			else
				to_chat(user, span_warning("Уровень кислорода в норме."))
		if(MODE_TOXDUMP)
			if(M.getToxLoss() > 5)
				if(use_charge(20))
					M.setToxLoss(0)
				else
					to_chat(user, span_warning("Недостаточно заряда, требуется 10 единиц."))
			else
				to_chat(user, span_warning("Токсины отсутствуют."))
		if(MODE_FRACTURE)
			if(limb?.wounds?.len)
				if(use_charge(20))
					for(var/thing in limb.wounds)
						var/datum/wound/W = thing
						W.remove_wound()
					to_chat(user, span_notice("Успешно исправили все переломы и вывихи в этой конечности."))
				else
					to_chat(user, span_warning("Недостаточно заряда, требуется 10 единиц."))
			else
				to_chat(user, span_warning("Не обнаружено травм в этой конечности."))
		if(MODE_BLOOD_INJECTOR)
			if(M.blood_volume <= initial(M.blood_volume) - 50)
				if(use_charge(30))
					M.restore_blood()
					to_chat(user, span_notice("Кровь восстановлена."))
				else
					to_chat(user, span_warning("Недостаточно заряда, требуется 10 единиц."))
			else
				to_chat(user, span_warning("Уровень крови в пределах нормы."))

#undef MODE_PAINKILLER
#undef MODE_OXYLOSS
#undef MODE_TOXDUMP
#undef MODE_FRACTURE
#undef MODE_BLOOD_INJECTOR

/datum/outfit/yohei
	name = "Йохей: Дженерик"

	ears = /obj/item/radio/headset
	uniform = /obj/item/clothing/under/syndicate/yohei
	mask = /obj/item/clothing/mask/breath/yohei
	shoes = /obj/item/clothing/shoes/jackboots/yohei
	gloves = /obj/item/clothing/gloves/combat/yohei
	suit = /obj/item/clothing/suit/hooded/yohei
	id = /obj/item/card/id/yohei

	suit_store = /obj/item/cat_hook

	r_pocket = /obj/item/flashlight/seclite
	l_pocket = /obj/item/pamk

	back = /obj/item/storage/backpack/satchel/leather
	backpack_contents = list()

/datum/outfit/yohei/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/obj/item/radio/R = H.ears
	R.set_frequency(FREQ_YOHEI)
	R.freqlock = FALSE
	R.independent = TRUE
	ADD_TRAIT(H, TRAIT_YOHEI, JOB_TRAIT)
	spawn(1 SECONDS) // fucking
		var/obj/item/card/id/yohei/Y = H.get_idcard(FALSE)
		H.mind?.adjust_experience(/datum/skill/ranged, SKILL_EXP_MASTER)
		if(Y && H.mind)
			Y.assigned_to = H.mind

/datum/outfit/yohei/medic
	name = "Йохей: Медик"

	glasses = /obj/item/clothing/glasses/hud/health/sunglasses
	belt = /obj/item/defibrillator/compact/combat/loaded
	uniform = /obj/item/clothing/under/syndicate/yohei/blue

	backpack_contents = list(/obj/item/pamk = 3, /obj/item/storage/firstaid/medical = 1, /obj/item/optable = 1, /obj/item/reagent_containers/glass/blastoff_ampoule = 1)

/datum/outfit/yohei/combatant
	name = "Йохей: Боевик"

	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	belt = /obj/item/shadowcloak/yohei
	uniform = /obj/item/clothing/under/syndicate/yohei/red
	r_pocket = /obj/item/ammo_box/magazine/fallout/m9mm

	backpack_contents = list(/obj/item/melee/classic_baton/telescopic/contractor_baton = 1, /obj/item/gun/ballistic/automatic/pistol/fallout/yohei9mm = 1, /obj/item/restraints/handcuffs/energy = 2)

/datum/outfit/yohei/breaker
	name = "Йохей: Взломщик"

	glasses = /obj/item/clothing/glasses/hud/diagnostic/sunglasses
	belt = /obj/item/storage/belt/military/abductor/full
	uniform = /obj/item/clothing/under/syndicate/yohei/yellow

	backpack_contents = list(/obj/item/construction/rcd/combat = 1, /obj/item/rcd_ammo/large = 1, /obj/item/quikdeploy/cade/plasteel = 5)

/datum/outfit/yohei/breaker/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()

	H.add_client_colour(/datum/client_colour/hacker)
	H.hud_list[HACKER_HUD].icon = null

	ADD_TRAIT(H, TRAIT_HACKER, JOB_TRAIT)

	spawn(5 SECONDS)
		var/datum/component/battletension/BT = H.GetComponent(/datum/component/battletension)
		if(BT)
			BT.pick_sound('white/valtos/sounds/snidleyWhiplash.ogg')
			BT.tension = 80
		to_chat(H, span_revenbignotice("Давно не виделись, а?"))
		if(H?.hud_used)
			H.hud_used.update_parallax_pref(H, 1)

		H.mind.teach_crafting_recipe(/datum/crafting_recipe/hacker/head)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/hacker/suit)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/hacker/gloves)

/datum/outfit/yohei/prospector
	name = "Йохей: Разведчик"

	glasses = /obj/item/clothing/glasses/meson/night
	belt = /obj/item/shadowcloak/yohei
	uniform = /obj/item/clothing/under/syndicate/yohei/green
	r_pocket = /obj/item/stack/rods/twentyfive
	back = /obj/item/gun/ballistic/crossbow/energy

	backpack_contents = list()

GLOBAL_VAR(yohei_main_controller)

/obj/lab_monitor/yohei
	name = "Монитор исполнения"
	desc = "Здесь выводятся задания. Стекло всё ещё выглядит не очень крепким..."

	var/obj/item/radio/internal_radio
	var/datum/yohei_task/current_task = null
	var/list/possible_tasks = list()
	var/list/action_guys = list()

/obj/lab_monitor/yohei/Initialize()
	. = ..()
	for(var/path in subtypesof(/datum/yohei_task))
		var/datum/yohei_task/T = path
		possible_tasks += T
	GLOB.yohei_main_controller = src

	internal_radio = new /obj/item/radio(src)
	internal_radio.listening = 0
	internal_radio.independent = TRUE
	internal_radio.set_frequency(FREQ_YOHEI)

/obj/lab_monitor/yohei/Destroy(force)
	. = ..()
	QDEL_NULL(internal_radio)
	GLOB.yohei_main_controller = null

/obj/lab_monitor/yohei/proc/is_this_target(mob/living/checkmob)
	if(istype(current_task, /datum/yohei_task/kill))
		var/datum/yohei_task/kill/KT = current_task
		if(KT.target == checkmob)
			return TRUE
	return FALSE

/obj/lab_monitor/yohei/attacked_by(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/pamk))
		var/obj/item/pamk/P = I
		if(P.charge_left >= 10)
			say("Полевой автоматический медицинский комплект всё ещё имеет заряд. Опустошите его.")
			return ..()
		P.charge_left = 100
		P.update_icon()
		inc_metabalance(user, -10, reason = "Небольшая жертва.")
		say("Полевой автоматический медицинский комплект был полностью заряжен. Приятной работы.")
	else
		return ..()

/obj/lab_monitor/yohei/attack_hand(mob/living/user)
	. = ..()

	if(!current_task)
		var/static/list/choices = list(
			"Классическая охота" = image(icon = 'white/valtos/icons/objects.dmi', icon_state = "classic"),
			"Помочь событиям" 	 = image(icon = 'white/valtos/icons/objects.dmi', icon_state = "gamemode"),
			"Кровавая месть" 	 = image(icon = 'white/valtos/icons/objects.dmi', icon_state = "revenge")
		)
		var/choice = show_radial_menu(user, src, choices, tooltips = TRUE)
		if(!choice)
			say("Ничего не выбрано!")
			return

		if(choice == "Классическая охота")
			internal_radio.talk_into(src, "Загружаю стандартное задание...", FREQ_YOHEI)
			var/datum/yohei_task/new_task = pick(possible_tasks)
			current_task = new new_task()
			return
		else if (choice == "Кровавая месть")
			internal_radio.talk_into(src, "Загружаю подпрограмму Феникс для пользователя [user.name]...", FREQ_YOHEI)
			var/list/victims = list()
			for(var/V in GLOB.data_core.locked)
				var/datum/data/record/R = V
				var/datum/mind/M = R.fields["mindref"]
				if(M)
					victims += M
			var/mob/victim = tgui_input_list(usr, "Кому же мы будем мстить?", "Чилипилки", victims)
			if(victim)
				var/datum/antagonist/A = user.mind.add_antag_datum(/datum/antagonist/custom)
				var/datum/objective/O = new /datum/objective/assassinate()
				O.owner = user.mind
				O.target = victim
				O.update_explanation_text()
				A.objectives += O
				A.greet()
				to_chat(victim, span_userdanger("Кто-то ОЧЕНЬ СИЛЬНО хочет мне навредить..."))
			return
		else
			internal_radio.talk_into(src, "Особых заданий больше НЕТ!", FREQ_YOHEI)
			//current_task = new /datum/yohei_task/gamemode()
			return

	if(current_task && current_task.check_task(user))
		internal_radio.talk_into(src, "Задание выполнено. Награда в размере [current_task.prize] выдана. Получение следующего задания...", FREQ_YOHEI)
		for(var/mob/living/carbon/human/H in action_guys)
			inc_metabalance(H, current_task.prize, reason = "Задание выполнено.")
		qdel(current_task)

		var/datum/yohei_task/new_task = pick(possible_tasks)
		current_task = new new_task()

	if(current_task && !(user in action_guys))
		action_guys += user
		internal_radio.talk_into(src, "[user.name] был добавлен в список исполнителей задания.", FREQ_YOHEI)

/obj/lab_monitor/yohei/examine(mob/user)
	. = ..()
	if(current_task)
		. += "<hr>"
		. += span_notice("<b>Задание:</b> [current_task.desc]")
		. += "\n<span class='notice'><b>Награда:</b> [current_task.prize]</span>"
		. += "\n<span class='notice'><b>Исполнители:</b> [english_list(action_guys)]</span>"

/datum/yohei_task
	var/desc = null
	var/prize = 0

/datum/yohei_task/proc/generate_task()
	return

/datum/yohei_task/proc/check_task(mob/user)
	return FALSE

/datum/yohei_task/New()
	generate_task()

/datum/yohei_task/proc/get_crewmember_minds()
	. = list()
	for(var/V in GLOB.data_core.locked)
		var/datum/data/record/R = V
		var/datum/mind/M = R.fields["mindref"]
		if(M)
			. += M

/datum/yohei_task/proc/get_someone_fuck()
	. = list()
	for(var/V in GLOB.clients)
		var/client/C = V
		if(C.mob && ishuman(C.mob))
			. += C.mob

/datum/yohei_task/proc/find_target()
	var/list/possible_targets = list()
	for(var/datum/mind/possible_target in get_crewmember_minds())
		if(ishuman(possible_target.current) && (possible_target.current.stat != DEAD))
			possible_targets += possible_target.current
	if(possible_targets.len > 0)
		return pick(possible_targets)
	return pick(get_someone_fuck())

/datum/yohei_task/kill
	desc = "Убить цель."
	prize = 50
	var/mob/living/target

/datum/yohei_task/kill/generate_task()
	target = find_target()
	desc = "Убить [target.real_name]."
	prize = max(rand(prize - 30, prize + 30), 1)
	to_chat(target, span_userdanger("Кто-то хочет мне навредить..."))

/datum/yohei_task/kill/check_task(mob/user)
	if(target && target.stat != DEAD)
		return FALSE
	return TRUE

/datum/yohei_task/capture
	desc = "Захватить цель."
	prize = 200
	var/mob/living/target

/datum/yohei_task/capture/generate_task()
	target = find_target()
	desc = "Захватить [target.real_name] и доставить живьём в логово."
	prize = max(rand(prize - 100, prize + 200), 1)

/datum/yohei_task/capture/check_task(mob/user)
	if(target && target.stat != DEAD)
		var/area/A = get_area(target)
		if(A.type != /area/ruin/powered/yohei_base)
			return FALSE
		target.Knockdown(5 SECONDS)
		if(prob(99))
			if(prob(10))
				target.gib()
				return TRUE
			target?.mind?.make_Traitor()
			return TRUE
		else
			target?.mind?.make_Wizard()
			return TRUE
	else
		qdel(src)
		return FALSE
/*
/datum/yohei_task/gamemode
	desc = "Нет особых заданий"
	prize = 0
	var/datum/antagonist/adatum = null

/datum/yohei_task/gamemode/generate_task()
	switch(SSticker.mode.type)
		if(/datum/game_mode/traitor)
			if(prob(50))
				desc = "Помочь Синдикату"
				adatum = /datum/antagonist/traitor
			else
				desc = "Помочь Станции"
				adatum = /datum/antagonist/traitor/internal_affairs
			return TRUE
		if(/datum/game_mode/wizard)
			if(prob(50))
				desc = "Помочь Волшебникам"
				adatum = /datum/antagonist/wizard/apprentice
			else
				desc = "Затроллить всех"
				adatum = /datum/antagonist/wizard/apprentice/imposter
			return TRUE
		if(/datum/game_mode/nuclear)
			desc = "Помочь Оперативникам Синдиката"
			adatum = /datum/antagonist/nukeop/reinforcement
			return TRUE
		if(/datum/game_mode/cult)
			desc = "Помочь Культистам Нар-Си"
			adatum = /datum/antagonist/cult
			return TRUE
		if(/datum/game_mode/clockcult)
			desc = "Помочь Служителям Ратвара"
			adatum = /datum/antagonist/servant_of_ratvar
			return TRUE
		if(/datum/game_mode/bloodsucker)
			desc = "Помочь Вампирам"
			adatum = /datum/antagonist/vassal
			return TRUE
		if(/datum/game_mode/changeling)
			desc = "Помочь Генокрадам"
			adatum = /datum/antagonist/changeling
			return TRUE
		if(/datum/game_mode/heretics)
			desc = "Помочь Еретикам"
			adatum = /datum/antagonist/heretic
			return TRUE
		if(/datum/game_mode/monkey)
			desc = "Помочь Мартышкам"
			adatum = /datum/antagonist/monkey
			return TRUE
		if(/datum/game_mode/shadowling)
			desc = "Помочь Теневикам"
			adatum = /datum/antagonist/thrall
			return TRUE
		if(/datum/game_mode/revolution)
			desc = "Помочь Революции"
			adatum = /datum/antagonist/rev
			return TRUE
		if(/datum/game_mode/gang)
			desc = "Помочь Гангстерам"
			adatum = pick(subtypesof(/datum/antagonist/gang))
			return TRUE
		else
			adatum = null
			return FALSE


/datum/yohei_task/gamemode/check_task(mob/user)
	if(!adatum)
		qdel(src)
		if(GLOB.yohei_main_controller)
			var/obj/lab_monitor/yohei/LM = GLOB.yohei_main_controller
			LM.current_task = null
		return FALSE
	if(!is_special_character(user))
		user.mind.add_antag_datum(adatum)
	return FALSE
*/
/area/ruin/powered/yohei_base
	name = "Ресурс Йохеев"
	icon_state = "dk_yellow"
	parallax_movedir = NORTH
	area_flags = BLOBS_ALLOWED | UNIQUE_AREA | BLOCK_SUICIDE | NOTELEPORT
	static_lighting = FALSE
	base_lighting_alpha = 255
	base_lighting_color = COLOR_WHITE

/obj/item/card/id/yohei
	name = "странная карточка"
	desc = "Что это такое?"
	icon_state = "yohei"
	icon = 'white/valtos/icons/card.dmi'
	assignment = "Yohei"
	registered_age = 666
	access = list(ACCESS_YOHEI, ACCESS_MAINT_TUNNELS)
	var/datum/mind/assigned_to
	var/assigned_by

/obj/item/card/id/yohei/Initialize(mapload)
	. = ..()
	var/datum/bank_account/bank_account = new /datum/bank_account(name)
	registered_account = bank_account

/obj/item/card/id/yohei/update_label()
	if(assigned_by)
		name = "Наёмный рабочий ([assigned_by])"
	else
		name = "[uppertext(copytext_char(md5("[rand(1, 10)][name]"), 1, 4))]-[rand(100000, 999999)]"

/obj/item/card/id/yohei/attackby(obj/item/W, mob/user, params)
	. = ..()

	if(!isidcard(W) || istype(W, /obj/item/card/id/yohei))
		return

	if(assigned_by || assigned_to.special_role)
		to_chat(user, span_danger("Уже кем-то нанят, какая жалость."))
		return

	if(assigned_to && user?.mind != assigned_to)
		var/obj/item/card/id/ID = W
		if(ID.registered_name)
			assigned_by = ID.registered_name
			assigned_to.special_role = "yohei"
			var/datum/antagonist/yohei/V = new
			V.protected_guy = user.mind
			assigned_to.add_antag_datum(V)
			to_chat(user, span_notice("Успешно нанимаю [assigned_to.name]. Теперь меня точно защитят."))
			update_label()
		else
			to_chat(user, span_danger("Карта неисправна. Самоутилизация активирована."))
			qdel(W)

/obj/effect/mob_spawn/human/donate
	name = "платно"
	desc = "ПЛАТНО - ЗНАЧИТ НУЖНО ПЛАТИТЬ!"
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "shiz"
	roundstart = FALSE
	death = FALSE
	var/req_sum = 500

/obj/effect/mob_spawn/human/donate/attack_ghost(mob/user)
	if(check_donations(user?.ckey) >= req_sum)
		. = ..()
	else
		to_chat(user, span_warning("Эта роль требует <b>[req_sum]</b> донат-поинтов для доступа."))
		return

/obj/effect/mob_spawn/human/donate/yohei
	name = "Точка входа Йохеев"
	desc = "Чудесные технологии!"
	invisibility = 60
	density = FALSE
	icon_state = "yohei_spawn"
	short_desc = "Что-то интересное?"
	flavour_text = "Наёмник посреди открытого космоса, до чего жизнь довела!"
	outfit = /datum/outfit/yohei
	assignedrole = "Yohei"
	req_sum = 1250
	uses = 16

/obj/effect/mob_spawn/human/donate/yohei/attack_ghost(mob/user)
	if(GLOB.migger_alarm)
		to_chat(user, span_userdanger("Последнюю капсулу направлявшуюся сюда недавно сбили в этом секторе. Похоже, пока лететь точно не стоит."))
		return
	var/static/list/choices = list(
		"Медик" 	= image(icon = 'white/valtos/icons/objects.dmi', icon_state = "ymedic"),
		"Боевик" 	= image(icon = 'white/valtos/icons/objects.dmi', icon_state = "ycombatant"),
		"Взломщик" 	= image(icon = 'white/valtos/icons/objects.dmi', icon_state = "ybreaker"),
		"Разведчик" = image(icon = 'white/valtos/icons/objects.dmi', icon_state = "yprospector")
		)
	var/choice = show_radial_menu(user, src, choices, tooltips = TRUE)
	if(!choice)
		return
	switch(choice)
		if("Медик")
			outfit = /datum/outfit/yohei/medic
			assignedrole = "Yohei: Medic"
		if("Боевик")
			outfit = /datum/outfit/yohei/combatant
			assignedrole = "Yohei: Combatant"
		if("Взломщик")
			outfit = /datum/outfit/yohei/breaker
			assignedrole = "Yohei: Breaker"
		if("Разведчик")
			outfit = /datum/outfit/yohei/prospector
			assignedrole = "Yohei: Prospector"
	if(user.ckey)
		var/datum/donator/D = get_donator(user.ckey)
		if(D && D.money >= 1250)
			D.money -= 1250
			var/client/C = GLOB.directory[user.ckey]
			if(C?.prefs)
				hairstyle =  C.prefs.hairstyle
				facial_hairstyle = C.prefs.facial_hairstyle
				skin_tone = C.prefs.skin_tone
		else
			to_chat(user, span_userdanger("Сработала защита от детей. Этот раунд последний."))
	. = ..()

/obj/effect/mob_spawn/human/donate/yohei/special(mob/living/carbon/human/H)
	var/newname = sanitize_name(reject_bad_text(stripped_input(H, "Меня когда-то звали [H.name]. Пришло время снова сменить прозвище?", "Прозвище", H.name, MAX_NAME_LEN)))
	if (!newname)
		return
	H.fully_replace_character_name(H.real_name, newname)

/datum/antagonist/yohei
	name = "yohei"
	roundend_category = "yohei"
	show_in_antagpanel = FALSE
	prevent_roundtype_conversion = FALSE
	var/datum/mind/protected_guy
	greentext_reward = 250

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
	. = ..()

/datum/antagonist/yohei/greet()
	to_chat(owner, span_warning("<B>Неужели, хоть кто-то решился на это. Теперь надо подумать как уберечь задницу [protected_guy.name] от смерти.</B>"))

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
		return "<span class='redtext big'>[owner.name] обосрался, позор!</span>"

/obj/item/book/yohei_codex
	name = "Кодекс Йохея"
	desc = "Весьма важный путеводитель."
	author = "Сомнительный Господин"
	icon_state = "stealthmanual"
	dat = "<center><h1>Положения кодекса</h1></center><i>«Прошу Вас судить обо мне по врагам, которых я приобрёл.»</i></br> — Франклин Делано Рузвельт.<ul><li>Никому не верь, но используй всех.</li><li>Наемник всегда готов отправиться куда угодно и встретить любую опасность.</li><li>Никаких друзей, никаких врагов. Только союзники и противники.</li><li>Всегда будь вежлив с клиентом.</li><li>Наемник никогда не жалуется.</li><li>Наемник не имеет привязанностей.</li><li>Жизнь растет на смерти.</li><li>Меняй распорядок. Шаблон — это ловушка.</li><li>Никогда не привлекай к себе внимания.</li><li>Не говори больше нужного.</li><li>Будь вежлив всегда. Особенно с врагами.</li><li>Тот, кто нанимает мою руку, нанимает всего меня.</li><li>Делай то, чего боишься больше всего, и обретешь храбрость.</li><li>Воображение — главное оружие воина.</li><li>Наемник никогда не отвлекается на общую картину. Мелочи играют главную роль.</li><li>Никогда не говори всю правду, торгуясь.</li><li>Услуга — это инвестиция.</li><li>Деньги — это сила.</li><li>Будь осторожен в любой ситуации.</li><li>Если ты должен умереть, сделай это с честью.</li></ul><b>Следуя данному кодексу Вы в полном праве можете называть себя Йохеем.</b> <i>Наверное.</i>"

/obj/item/cat_hook
	name = "кошкокрюк"
	desc = "Элегантный инструмент для внезапного прониковения и исчезновения. Достаточно лишь понять куда им можно выстрелить."
	icon = 'white/valtos/icons/objects.dmi'
	icon_state = "cat_hook"
	inhand_icon_state = "smg10mm"
	worn_icon_state = "gun"
	lefthand_file = 'white/valtos/icons/fallout/guns_lefthand.dmi'
	righthand_file = 'white/valtos/icons/fallout/guns_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_SUITSTORE | ITEM_SLOT_BELT

/obj/item/cat_hook/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(.)
		return

	if(!target || !user)
		return

	if(!proximity_flag)
		return

	if(!HAS_TRAIT(user, TRAIT_YOHEI))
		if(do_after(user, 1 SECONDS, target = user))
			user.visible_message(span_warning("[user] стреляет себе в ногу!"),
				span_userdanger("Успешно стреляю себе в ногу..."))
			var/mob/living/carbon/human/thinky = user
			thinky.apply_damage(30, BRUTE, pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG), wound_bonus = CANT_WOUND)
			playsound(get_turf(user), 'white/valtos/sounds/cathit.ogg', 60)
		return

	if(isturf(target))
		var/turf/T = target
		var/turf/picked
		if(isopenspace(T))
			T = SSmapping.get_turf_below(get_turf(T))
		if(isspaceturf(T))
			if(do_after(user, 5 SECONDS, target = T))
				if(is_station_level(T.z))
					picked = get_turf(pick(GLOB.yohei_beacons))
					to_chat(user, span_notice("Успешно нацеливаюсь на наш корабль..."))
				else
					picked = get_turf(pick(GLOB.generic_event_spawns))
					to_chat(user, span_notice("Успешно нацеливаюсь на станцию..."))
				if(do_after(user, 1 SECONDS, target = T))
					to_chat(user, span_notice("Произвожу выстрел..."))
					playsound(get_turf(user), 'white/valtos/sounds/catlaunch.ogg', 90)
					if(do_after(user, 10 SECONDS, target = T))
						if(prob(75))
							to_chat(user, span_reallybig("ЕСТЬ!"))
							playsound(get_turf(user), 'white/valtos/sounds/cathit.ogg', 60)
							if(do_after(user, 5 SECONDS, target = T))
								var/mob/living/carbon/human/H = user
								var/atom/movable/AM
								if(H.pulling)
									AM = H.pulling
									AM.forceMove(picked)
									to_chat(AM, span_danger("Ох..."))
								for(var/mob/M in H.buckled_mobs)
									M.forceMove(picked)
									to_chat(M, span_danger("Ох..."))
								H.forceMove(picked)
								H.adjustStaminaLoss(100)
								to_chat(user, span_notice("Вот я и на месте!"))
								return
						else
							to_chat(user, span_reallybig("МИМО!"))
							return
		else
			to_chat(user, span_danger("Не получится здесь. Нужен космос."))
	return
