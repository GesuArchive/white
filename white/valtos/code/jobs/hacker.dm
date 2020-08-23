/datum/job/hacker
	title = "Hacker"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	department_head = list("Research Director")
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "научному руководителю"
	selection_color = "#00eeff"
	exp_requirements = 30000
	exp_type = EXP_TYPE_CREW
	display_order = JOB_DISPLAY_ORDER_SCIENTIST

	outfit = /datum/outfit/job/hacker

	mind_traits = list(TRAIT_HACKER)

/datum/job/hacker/get_access()
	return get_all_accesses()

/datum/atom_hud/hacker
	hud_icons = list(HACKER_HUD)

/mob/living/carbon/Initialize()
	. = ..()
	if(!src)
		return
	var/datum/atom_hud/hacker/hhud = GLOB.huds[DATA_HUD_HACKER]
	hhud.add_to_hud(src)
	hud_list[HACKER_HUD].icon = image('white/valtos/icons/dz-031.dmi', src)
	hud_list[HACKER_HUD].icon_state = "node"

/mob/living/simple_animal/hostile/Initialize()
	. = ..()
	hud_list[HACKER_HUD].add_overlay("node_enemy")

/obj/item/gun/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(HAS_TRAIT(H, TRAIT_HACKER))
			prepare_huds()
			var/datum/atom_hud/hacker/hhud = GLOB.huds[DATA_HUD_HACKER]
			hhud.add_to_hud(src)
			hud_list[HACKER_HUD].icon = image('white/valtos/icons/dz-031.dmi', src)
			hud_list[HACKER_HUD].icon_state = "node_weapon"

/datum/client_colour/hacker
	colour = list(rgb(255,15,15), rgb(0,255,25), rgb(0,0,255), rgb(0,0,0))
	priority = 6

/obj/item/clothing/suit/space/wzzzz/hacker_rig/equipped(mob/user, slot)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.dna)
			return
		spawn(10)
			if(!HAS_TRAIT(H, TRAIT_HACKER))
				H.dropItemToGround(src, TRUE)
				H.emote("scream")
				to_chat(H, "<span class='danger'>КАК?!</span>")
				visible_message("<span class='warning'><b>[H]</b> в панике бросает [src] на пол!</span>")

/obj/item/clothing/head/helmet/space/chronos/hacker/equipped(mob/user, slot)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.dna)
			return
		spawn(10)
			if(!HAS_TRAIT(H, TRAIT_HACKER))
				H.dropItemToGround(src, TRUE)
				H.emote("scream")
				to_chat(H, "<span class='danger'>КАК?!</span>")
				visible_message("<span class='warning'><b>[H]</b> в панике бросает [src] на пол!</span>")

/obj/item/clothing/glasses/hud/wzzzz/hacker_rig
	name = "NI-Трансфакторный Визор C3451"
	desc = "А ты заслуживаешь это?"
	icon_state = "hardsuit1-hacker_rig"
	inhand_icon_state = "hardsuit1-hacker_rig"
	darkness_view = 10
	flash_protect = FLASH_PROTECTION_WELDER
	resistance_flags = NONE
	worn_icon = 'white/Wzzzz/icons/clothing/mob1/hardhead.dmi'
	icon = 'white/Wzzzz/icons/clothing/clothing/hardhead.dmi'
	var/list/hudlist = list(DATA_HUD_MEDICAL_ADVANCED, DATA_HUD_DIAGNOSTIC_ADVANCED, DATA_HUD_SECURITY_ADVANCED, DATA_HUD_HACKER)
	vision_flags = SEE_MOBS | SEE_TURFS
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	hud_trait = TRAIT_SECURITY_HUD

/obj/item/clothing/glasses/hud/wzzzz/hacker_rig/equipped(mob/user, slot)
	. = ..()

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.dna)
			return
		spawn(10)
			if(!HAS_TRAIT(H, TRAIT_HACKER))
				H.dropItemToGround(src, TRUE)
				H.emote("scream")
				to_chat(H, "<span class='danger'>КАК?!</span>")
				visible_message("<span class='warning'><b>[H]</b> в панике бросает [src] на пол!</span>")

	if(slot != ITEM_SLOT_EYES)
		return
	if(ishuman(user))
		for(var/hud in hudlist)
			var/datum/atom_hud/H = GLOB.huds[hud]
			H.add_hud_to(user)
		ADD_TRAIT(user, TRAIT_MEDICAL_HUD, GLASSES_TRAIT)
		ADD_TRAIT(user, TRAIT_SECURITY_HUD, GLASSES_TRAIT)

/obj/item/clothing/glasses/hud/wzzzz/hacker_rig/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_MEDICAL_HUD, GLASSES_TRAIT)
	REMOVE_TRAIT(user, TRAIT_SECURITY_HUD, GLASSES_TRAIT)
	if(ishuman(user))
		for(var/hud in hudlist)
			var/datum/atom_hud/H = GLOB.huds[hud]
			H.remove_hud_from(user)

/obj/item/clothing/glasses/hud/wzzzz/hacker_rig/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	var/mob/living/carbon/human/user = src.loc
	to_chat(user, "<span class='danger'>E:FATAL:RAM_READ_FAIL\nE:FATAL:STACK_EMPTY\nE:FATAL:READ_NULL_POINT\nE:FATAL:PWR_BUS_OVERLOAD</span>")
	SEND_SOUND(user, sound('sound/ai/hacker/emp.ogg'))

/obj/item/clothing/head/helmet/space/chronos/hacker
	name = "TK-Нанобролитовый Шлем X1845"
	desc = "А ты заслуживаешь это?"
	worn_icon = 'white/Wzzzz/icons/clothing/mob1/hardhead.dmi'
	icon = 'white/Wzzzz/icons/clothing/clothing/hardhead.dmi'
	icon_state = "hardsuit1-null_rig"
	inhand_icon_state = "hardsuit1-null_rig"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	strip_delay = 1300
	force = 1
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100,"energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100, "magic" = 100, "wound" = 100)

/obj/item/clothing/suit/space/wzzzz/hacker_rig
	name = "AQ-Квантовый Экзоскелет Н4781"
	desc = "А ты заслуживаешь этот костюм?"
	icon_state = "hardsuit1-null_rig"
	clothing_flags = STOPSPRESSUREDAMAGE
	inhand_icon_state = "hardsuit1-null_rig"
	resistance_flags = INDESTRUCTIBLE
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'white/Wzzzz/icons/clothing/clothing/hard.dmi'
	worn_icon = 'white/Wzzzz/icons/clothing/mob1/hard.dmi'
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100,"energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100, "magic" = 100, "wound" = 100)
	//slowdown = -2
	strip_delay = 1300

/obj/item/clothing/gloves/combat/wzzzz/guard
	name = "DZ-Блюспластовые Перчатки U8621"
	desc = "А нужны ли они тебе?"
	worn_icon = 'white/Wzzzz/icons/clothing/mob1/hands.dmi'
	icon = 'white/Wzzzz/icons/clothing/clothing/gloves.dmi'
	icon_state = "guards"
	inhand_icon_state = "guards"
	siemens_coefficient = 0
	permeability_coefficient = 0.01
	strip_delay = 500
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100,"energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100, "magic" = 100, "wound" = 100)

/obj/item/clothing/gloves/combat/wzzzz/guard/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/wearertargeting/punchcooldown)

/obj/effect/proc_holder/spell/self/hacker_heal
	name = "Источник силы"
	desc = "Восполняет недостатки в теле."
	human_req = TRUE
	clothes_req = FALSE
	charge_max = 600
	cooldown_min = 600
	invocation = "Уёбки, сука!"
	invocation_type = "whisper"
	school = "restoration"
	sound = 'white/valtos/sounds/hacker_heal.ogg'
	action_icon_state = "spacetime"

/obj/effect/proc_holder/spell/self/hacker_heal/cast(list/targets, mob/living/carbon/human/user)
	user.visible_message("<span class='warning'>Странный свет исходит от <b>[user]</b>!</span>", "<span class='notice'>Мне удалось немного исправить своё тело!</span>")
	user.adjustBruteLoss(-10)
	user.adjustFireLoss(-10)

/obj/effect/proc_holder/spell/targeted/remove_retard
	name = "Стереть"
	desc = "При помощи этого я могу уничтожать тех, кто портит систему."
	school = "destruction"
	charge_type = "recharge"
	charge_max	= 6000
	charge_counter = 0
	clothes_req = FALSE
	stat_allowed = FALSE
	invocation = "Исчезни, пидор!"
	invocation_type = "shout"
	range = 4
	cooldown_min = 6000
	selection_type = "range"
	action_icon_state = "spacetime"

/obj/effect/proc_holder/spell/targeted/remove_retard/cast(list/targets, mob/user = usr)
	if(!targets.len)
		to_chat(user, "<span class='warning'>Не нашел гниду!</span>")
		return

	var/mob/living/carbon/target = targets[1]

	if(!(target in oview(range)))
		to_chat(user, "<span class='warning'>Этот пидор слишком далеко!</span>")
		return

	to_chat(target, "<span class='danger'>Кто-то хочет мне навредить!</span>")

	user.visible_message("<span class='warning'><b>[user]</b> бормочет себе что-то под нос!</span>", \
						   "<span class='danger'>Сейчас я этого пидораса сотру нахуй!</span>")

	if(do_after(user, 50, target = target))
		user.whisper(md5("Цель: [target]"))
		if(do_after(user, 30, target = target))
			user.whisper(md5("Метод: удаление [target]"))
			if(do_after(user, 30, target = target))
				user.say("Эй, [target], тебе сейчас будет пиздец!")
				if(do_after(user, 60, target = target))
					user.whisper(md5("Удаление  [target]..."))
					target.emote("scream")
					target.visible_message("<span class='danger'><b>[target]</b> исчезает!</span>", \
									"<span class='danger'>Мне пиздец!</span>")
					playsound(target, 'white/valtos/sounds/mechanized/kr1.wav', 100)
					spawn(5)
						qdel(target.client)
						spawn(5)
							target.dust(TRUE,TRUE)

/mob/living/carbon/proc/hackers_immortality()
	set category = "МАГИЯ"
	set name = "Бессмертие"

	var/mob/living/carbon/C = usr
	if(!C.stat)
		to_chat(C, "<span class='notice'>А я ещё не умер!</span>")
		return
	if(C.has_status_effect(STATUS_EFFECT_HACKERS_IMMORTALITY))
		to_chat(C, "<span class='warning'>А я уже воскрешаюсь!</span>")
		return
	C.apply_status_effect(STATUS_EFFECT_HACKERS_IMMORTALITY)
	return 1

/datum/status_effect/hackers_revive
	id = "hackers_revive"
	duration = 200
	alert_type = /obj/screen/alert/status_effect/hackers_revive

/datum/status_effect/hackers_revive/on_apply()
	to_chat(owner, "<span class='notice'>Смерть не мой конец! Сейчас восстановимся...</span>")
	return ..()

/datum/status_effect/hackers_revive/on_remove()
	owner.revive(full_heal = TRUE, admin_revive = TRUE)
	owner.visible_message("<span class='warning'><b>[owner]</b> восстаёт из мёртвых!</span>", "<span class='notice'>Я регенерирую полностью.</span>")
	owner.update_mobility()

/obj/screen/alert/status_effect/hackers_revive
	name = "Цифровое бессмертие"
	desc = "Мне не страшна смерть!"
	icon_state = "shadow_mend"

/obj/effect/proc_holder/spell/self/hacker_immater
	name = "Материализация"
	desc = "Энтропию в материю!"
	human_req = TRUE
	clothes_req = FALSE
	charge_max = 762
	cooldown_min = 762
	invocation = "Ммм, данон!"
	invocation_type = "whisper"
	school = "evocation"
	sound = 'white/valtos/sounds/hacker_heal.ogg'
	action_icon_state = "spike"
	var/list/allowed_items = list(/obj/item/stack/sheet/metal,\
								  /obj/item/stack/sheet/glass,\
								  /obj/item/stack/sheet/plasteel,\
								  /obj/item/stack/sheet/mineral/plasma,\
								  /obj/item/stack/sheet/mineral/gold,\
								  /obj/item/stack/sheet/mineral/silver,\
								  /obj/item/stack/sheet/mineral/uranium,\
								  /obj/item/stack/sheet/mineral/titanium,\
								  /obj/item/stack/sheet/mineral/diamond)

/obj/effect/proc_holder/spell/self/hacker_immater/cast(list/targets, mob/living/carbon/human/user)

	var/obj/item/stack/sheet/sheetsel = input("Предмет:", "Создаём!", null, null) as null|anything in allowed_items

	if(!sheetsel)
		return FALSE
	else
		var/obj/item/S = new sheetsel(get_turf(user))
		user.put_in_hands(S)
		user.visible_message("<span class='warning'>Странный свет исходит от <b>[user]</b>!</span>", "<span class='notice'>Создаю что-тооооооооо!</span>")


/datum/crafting_recipe/hacker/head
	name = "TK-Нанобролитовый Шлем X1845"
	result = /obj/item/clothing/head/helmet/space/chronos/hacker
	tools = list(/obj/item/weldingtool,
				 /obj/item/screwdriver,
				 /obj/item/multitool/tricorder,
				 /obj/item/wrench,
				 /obj/item/wirecutters)
	reqs = list(/obj/item/stack/sheet/cloth = 3,
				/obj/item/stack/sheet/mineral/plastitanium = 10,
				/obj/item/stack/sheet/plasteel = 5,
				/obj/item/stack/sheet/mineral/diamond = 1,
				/obj/item/stock_parts/matter_bin/bluespace = 2,
				/obj/item/stock_parts/micro_laser/quadultra = 2,
				/obj/item/stock_parts/electrolite/bluespace = 1,
				/obj/item/stock_parts/manipulator/femto = 4,
				/obj/item/stock_parts/scanning_module/triphasic = 16,
				/obj/item/stock_parts/capacitor/quadratic = 2)
	time = 150
	category = CAT_CLOTHING
	always_available = FALSE

/datum/crafting_recipe/hacker/suit
	name = "AQ-Квантовый Экзоскелет Н4781"
	result = /obj/item/clothing/suit/space/wzzzz/hacker_rig
	tools = list(/obj/item/weldingtool,
				 /obj/item/screwdriver,
				 /obj/item/multitool/tricorder,
				 /obj/item/wrench,
				 /obj/item/wirecutters)
	reqs = list(/obj/item/stack/sheet/cloth = 12,
				/obj/item/stack/sheet/mineral/plastitanium = 25,
				/obj/item/stack/sheet/plasteel = 20,
				/obj/item/stack/sheet/bluespace_crystal = 7,
				/obj/item/stock_parts/matter_bin/bluespace = 12,
				/obj/item/stock_parts/micro_laser/quadultra = 12,
				/obj/item/stock_parts/electrolite/bluespace = 12,
				/obj/item/stock_parts/manipulator/femto = 25,
				/obj/item/stock_parts/scanning_module/triphasic = 8,
				/obj/item/stock_parts/capacitor/quadratic = 20)
	time = 150
	category = CAT_CLOTHING
	always_available = FALSE

/datum/crafting_recipe/hacker/gloves
	name = "DZ-Блюспластовые Перчатки U8621"
	result = /obj/item/clothing/gloves/combat/wzzzz/guard
	tools = list(/obj/item/weldingtool,
				 /obj/item/screwdriver,
				 /obj/item/multitool/tricorder,
				 /obj/item/wrench,
				 /obj/item/wirecutters)
	reqs = list(/obj/item/stack/sheet/cloth = 4,
				/obj/item/stack/sheet/mineral/plastitanium = 15,
				/obj/item/stack/sheet/plasteel = 7,
				/obj/item/stack/sheet/bluespace_crystal = 7,
				/obj/item/stock_parts/matter_bin/bluespace = 2,
				/obj/item/stock_parts/micro_laser/quadultra = 4,
				/obj/item/stock_parts/electrolite/bluespace = 5,
				/obj/item/stock_parts/manipulator/femto = 20,
				/obj/item/stock_parts/scanning_module/triphasic = 3,
				/obj/item/stock_parts/capacitor/quadratic = 40)
	time = 150
	category = CAT_CLOTHING
	always_available = FALSE

/*
// Hacking

/obj/item/modular_computer/tablet/hacktool
	name = "планшет"
	icon = 'icons/obj/contractor_tablet.dmi'
	icon_state = "tablet"
	icon_state_unpowered = "tablet"
	icon_state_powered = "tablet"
	icon_state_menu = "assign"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_ID | ITEM_SLOT_BELT
	comp_light_luminosity = 6.3
	has_variants = FALSE

/obj/item/modular_computer/tablet/hacktool/Initialize()
	. = ..()
	var/obj/item/computer_hardware/hard_drive/small/hacker/hard_drive = new
	var/datum/computer_file/program/hacktool/ht = new

	active_program = ht
	ht.program_state = PROGRAM_STATE_ACTIVE
	ht.computer = src

	hard_drive.store_file(ht)

	install_component(new /obj/item/computer_hardware/processor_unit/small)
	install_component(new /obj/item/computer_hardware/battery(src, /obj/item/stock_parts/cell/computer))
	install_component(hard_drive)
	install_component(new /obj/item/computer_hardware/network_card)
	install_component(new /obj/item/computer_hardware/card_slot)
	install_component(new /obj/item/computer_hardware/printer/mini)

/obj/item/computer_hardware/hard_drive/small/hacker
	desc = "An efficient SSD for portable devices developed by a rival organisation."
	power_usage = 8
	max_capacity = 120

/datum/computer_file/program/hacktool
	filename = "hacktool"
	filedesc = "Tool for hacking everything"
	program_icon_state = "assign"
	extended_desc = "Содержит виртуальную машину со своим набором программ."
	size = 60
	requires_ntnet = 0
	available_on_ntnet = 0
	unsendable = 1
	undeletable = 1
	tgui_id = "HackerHackTool"
	ui_x = 500
	ui_y = 600

/datum/computer_file/program/hacktool/run_program(var/mob/living/user)
	. = ..(user)
*/
