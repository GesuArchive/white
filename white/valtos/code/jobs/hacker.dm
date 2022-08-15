/datum/job/hacker
	title = JOB_HACKER
	ru_title = "Взломщик"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	department_head = list(JOB_RESEARCH_DIRECTOR)
	faction = "Scarlet"
	total_positions = 0
	spawn_positions = 0
	supervisors = "научному руководителю"
	selection_color = "#00eeff"
	exp_requirements = 3000
	exp_type = EXP_TYPE_CREW
	display_order = JOB_DISPLAY_ORDER_SCIENTIST

	outfit = /datum/outfit/job/hacker

	mind_traits = list(TRAIT_HACKER)

/datum/atom_hud/hacker
	hud_icons = list(HACKER_HUD)

/mob/living/carbon/Initialize(mapload)
	. = ..()
	if(!src)
		return
	var/datum/atom_hud/hacker/hhud = GLOB.huds[DATA_HUD_HACKER]
	hhud.add_atom_to_hud(src)
	hud_list[HACKER_HUD].icon = image('white/valtos/icons/dz-031.dmi', src)
	hud_list[HACKER_HUD].icon_state = "node"

/mob/living/simple_animal/hostile/Initialize(mapload)
	. = ..()
	hud_list[HACKER_HUD]?.add_overlay("node_enemy")

/obj/item/gun/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(HAS_TRAIT(H, TRAIT_HACKER))
			prepare_huds()
			var/datum/atom_hud/hacker/hhud = GLOB.huds[DATA_HUD_HACKER]
			hhud.add_atom_to_hud(src)
			hud_list[HACKER_HUD].icon = image('white/valtos/icons/dz-031.dmi', src)
			hud_list[HACKER_HUD].icon_state = "node_weapon"

/datum/client_colour/hacker
	colour = list(rgb(255,15,15), rgb(0,255,25), rgb(0,0,255), rgb(0,0,0))
	priority = 6

/obj/item/clothing/suit/space/hacker_rig/equipped(mob/user, slot)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.dna)
			return
		spawn(10)
			if(!HAS_TRAIT(H, TRAIT_HACKER))
				H.dropItemToGround(src, TRUE)
				H.emote("agony")
				to_chat(H, span_danger("КАК?!"))
				visible_message(span_warning("<b>[H]</b> в панике бросает [src] на пол!"))

/obj/item/clothing/head/helmet/space/chronos/hacker/equipped(mob/user, slot)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.dna)
			return
		spawn(10)
			if(!HAS_TRAIT(H, TRAIT_HACKER))
				H.dropItemToGround(src, TRUE)
				H.emote("agony")
				to_chat(H, span_danger("КАК?!"))
				visible_message(span_warning("<b>[H]</b> в панике бросает [src] на пол!"))

/obj/item/clothing/glasses/hud/hacker_rig
	name = "NI-Трансфакторный Визор C3451"
	desc = "А ты заслуживаешь это?"
	icon_state = "hardsuit1-hacker_rig"
	inhand_icon_state = "hardsuit1-hacker_rig"
	darkness_view = 10
	flash_protect = FLASH_PROTECTION_WELDER
	resistance_flags = NONE
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	var/list/hudlist = list(DATA_HUD_MEDICAL_ADVANCED, DATA_HUD_DIAGNOSTIC_ADVANCED, DATA_HUD_SECURITY_ADVANCED, DATA_HUD_HACKER)
	vision_flags = SEE_MOBS | SEE_TURFS
	lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
	hud_trait = TRAIT_SECURITY_HUD

/obj/item/clothing/glasses/hud/hacker_rig/equipped(mob/user, slot)
	. = ..()

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.dna)
			return
		spawn(10)
			if(!HAS_TRAIT(H, TRAIT_HACKER))
				H.dropItemToGround(src, TRUE)
				H.emote("agony")
				to_chat(H, span_danger("КАК?!"))
				visible_message(span_warning("<b>[H]</b> в панике бросает [src] на пол!"))

	if(slot != ITEM_SLOT_EYES)
		return
	if(ishuman(user))
		for(var/hud in hudlist)
			var/datum/atom_hud/H = GLOB.huds[hud]
			H.show_to(user)
		ADD_TRAIT(user, TRAIT_MEDICAL_HUD, GLASSES_TRAIT)
		ADD_TRAIT(user, TRAIT_SECURITY_HUD, GLASSES_TRAIT)

/obj/item/clothing/glasses/hud/hacker_rig/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_MEDICAL_HUD, GLASSES_TRAIT)
	REMOVE_TRAIT(user, TRAIT_SECURITY_HUD, GLASSES_TRAIT)
	if(ishuman(user))
		for(var/hud in hudlist)
			var/datum/atom_hud/H = GLOB.huds[hud]
			H.hide_from(user)

/obj/item/clothing/glasses/hud/hacker_rig/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	var/mob/living/carbon/human/user = src.loc
	to_chat(user, span_danger("E:FATAL:RAM_READ_FAIL\nE:FATAL:STACK_EMPTY\nE:FATAL:READ_NULL_POINT\nE:FATAL:PWR_BUS_OVERLOAD"))
	SEND_SOUND(user, sound('sound/ai/hacker/emp.ogg'))

/obj/item/clothing/head/helmet/space/chronos/hacker
	name = "TK-Нанобролитовый Шлем X1845"
	desc = "А ты заслуживаешь это?"
	worn_icon = 'white/Wzzzz/clothing/mob/head.dmi'
	icon = 'white/Wzzzz/clothing/head.dmi'
	icon_state = "hardsuit1-null_rig"
	inhand_icon_state = "hardsuit1-null_rig"
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR
	strip_delay = 1300
	force = 1
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100,"energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100, "magic" = 100, "wound" = 100)

/obj/item/clothing/suit/space/hacker_rig
	name = "AQ-Квантовый Экзоскелет Н4781"
	desc = "А ты заслуживаешь этот костюм?"
	icon_state = "hardsuit1-null_rig"
	clothing_flags = STOPSPRESSUREDAMAGE
	inhand_icon_state = "hardsuit1-null_rig"
	resistance_flags = INDESTRUCTIBLE
	resistance_flags = NONE|FIRE_PROOF|FREEZE_PROOF
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'white/Wzzzz/clothing/suits.dmi'
	worn_icon = 'white/Wzzzz/clothing/mob/suit.dmi'
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100,"energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100, "magic" = 100, "wound" = 100)
	//slowdown = -2
	strip_delay = 1300

/obj/item/clothing/gloves/combat/guard
	name = "DZ-Блюспластовые Перчатки U8621"
	desc = "А нужны ли они тебе?"
	worn_icon = 'white/Wzzzz/clothing/mob/hands.dmi'
	icon = 'white/Wzzzz/clothing/gloves.dmi'
	icon_state = "guards"
	inhand_icon_state = "guards"
	siemens_coefficient = 0
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 100, FIRE = 0, ACID = 0)
	strip_delay = 500
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor = list("melee" = 100, "bullet" = 100, "laser" = 100,"energy" = 100, "bomb" = 100, "bio" = 100, "rad" = 100, "fire" = 100, "acid" = 100, "magic" = 100, "wound" = 100)

/obj/item/clothing/gloves/combat/guard/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/wearertargeting/punchcooldown)

/mob/living/carbon/proc/hackers_immortality()
	set category = "Хакерство"
	set name = "Бессмертие"

	var/mob/living/carbon/C = usr
	if(!C.stat)
		to_chat(C, span_notice("А я ещё не умер!"))
		return
	if(C.has_status_effect(STATUS_EFFECT_HACKERS_IMMORTALITY))
		to_chat(C, span_warning("А я уже воскрешаюсь!"))
		return
	C.apply_status_effect(STATUS_EFFECT_HACKERS_IMMORTALITY)
	return 1

/datum/status_effect/hackers_revive
	id = "hackers_revive"
	duration = 200
	alert_type = /atom/movable/screen/alert/status_effect/hackers_revive

/datum/status_effect/hackers_revive/on_apply()
	to_chat(owner, span_notice("Смерть не мой конец! Сейчас восстановимся..."))
	return ..()

/datum/status_effect/hackers_revive/on_remove()
	owner.revive(full_heal = TRUE, admin_revive = TRUE)
	owner.visible_message(span_warning("<b>[owner]</b> восстаёт из мёртвых!") , span_notice("Регенерирую полностью."))

/atom/movable/screen/alert/status_effect/hackers_revive
	name = "Цифровое бессмертие"
	desc = "Мне не страшна смерть!"
	icon_state = "shadow_mend"

/datum/crafting_recipe/hacker/head
	name = "TK-Нанобролитовый Шлем X1845"
	result = /obj/item/clothing/head/helmet/space/chronos/hacker
	tool_paths = list(
		/obj/item/weldingtool,
		/obj/item/screwdriver,
		/obj/item/multitool/tricorder,
		/obj/item/wrench,
		/obj/item/wirecutters
	)
	reqs = list(
		/obj/item/stack/sheet/cloth = 3,
		/obj/item/stack/sheet/mineral/plastitanium = 10,
		/obj/item/stack/sheet/plasteel = 5,
		/obj/item/stack/sheet/mineral/diamond = 1,
		/obj/item/stock_parts/matter_bin/bluespace = 2,
		/obj/item/stock_parts/micro_laser/quadultra = 2,
		/obj/item/stock_parts/manipulator/femto = 4,
		/obj/item/stock_parts/scanning_module/triphasic = 16,
		/obj/item/stock_parts/capacitor/quadratic = 2
	)
	time = 150
	category = CAT_CLOTHING
	always_available = FALSE

/datum/crafting_recipe/hacker/suit
	name = "AQ-Квантовый Экзоскелет Н4781"
	result = /obj/item/clothing/suit/space/hacker_rig
	tool_paths = list(
		/obj/item/weldingtool,
		/obj/item/screwdriver,
		/obj/item/multitool/tricorder,
		/obj/item/wrench,
		/obj/item/wirecutters
	)
	reqs = list(
		/obj/item/stack/sheet/cloth = 12,
		/obj/item/stack/sheet/mineral/plastitanium = 25,
		/obj/item/stack/sheet/plasteel = 20,
		/obj/item/stack/sheet/bluespace_crystal = 7,
		/obj/item/stock_parts/matter_bin/bluespace = 12,
		/obj/item/stock_parts/micro_laser/quadultra = 12,
		/obj/item/stock_parts/manipulator/femto = 25,
		/obj/item/stock_parts/scanning_module/triphasic = 8,
		/obj/item/stock_parts/capacitor/quadratic = 20
	)
	time = 150
	category = CAT_CLOTHING
	always_available = FALSE

/datum/crafting_recipe/hacker/gloves
	name = "DZ-Блюспластовые Перчатки U8621"
	result = /obj/item/clothing/gloves/combat/guard
	tool_paths = list(
		/obj/item/weldingtool,
		/obj/item/screwdriver,
		/obj/item/multitool/tricorder,
		/obj/item/wrench,
		/obj/item/wirecutters
	)
	reqs = list(
		/obj/item/stack/sheet/cloth = 4,
		/obj/item/stack/sheet/mineral/plastitanium = 15,
		/obj/item/stack/sheet/plasteel = 7,
		/obj/item/stack/sheet/bluespace_crystal = 7,
		/obj/item/stock_parts/matter_bin/bluespace = 2,
		/obj/item/stock_parts/micro_laser/quadultra = 4,
		/obj/item/stock_parts/manipulator/femto = 20,
		/obj/item/stock_parts/scanning_module/triphasic = 3,
		/obj/item/stock_parts/capacitor/quadratic = 40
	)
	time = 150
	category = CAT_CLOTHING
	always_available = FALSE
